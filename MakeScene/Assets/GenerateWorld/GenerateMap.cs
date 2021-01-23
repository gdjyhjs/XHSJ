using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Threading;
using UnityEngine;
using Random = System.Random;

namespace GenerateWorld {

    public class GenerateMap : MonoBehaviour {



        public float sea_altitude = -0.5f;
        public float ground_altitude = 0f;
        public float city_altitude = 0.05f;


        /// <summary>
        /// 地图边缘大小
        /// </summary>
        public int map_edge = 100;

        /// <summary>
        /// 地图的大小
        /// </summary>
        public int map_size = 10000;

        /// <summary>
        /// 城市的大小
        /// </summary>
        public int city_size = 200;

        /// <summary>
        /// 城市的距离
        /// </summary>
        public int city_dis = 200;

        /// <summary>
        /// 城市的大小随机幅度
        /// </summary>
        public int city_random = 100;

        /// <summary>
        /// 城市的数量
        /// </summary>
        public int city_count = 3;

        /// <summary>
        /// 场地的大小
        /// </summary>
        public int field_size = 15;

        /// <summary>
        /// 场地的距离
        /// </summary>
        public int field_dis = 5;

        /// <summary>
        /// 场地的大小随机幅度
        /// </summary>
        public int field_random = 10;

        /// <summary>
        /// 场地的数量
        /// </summary>
        public int field_count = 100;

        /// <summary>
        /// 空地的大小
        /// </summary>
        public int ground_size = 100;

        /// <summary>
        /// 用来做水的obj
        /// </summary>
        public StaticObjData waterObj;

        /// <summary>
        /// 用来做海洋的obj
        /// </summary>
        public StaticObjData seaObj;

        /// <summary>
        /// 用来做地面的obj
        /// </summary>
        public StaticObjData groundObj;

        /// <summary>
        /// 用来做城镇地面的obj
        /// </summary>
        public StaticObjData city_groundObj;

        /// <summary>
        /// 用来做森林的obj
        /// </summary>
        public StaticObjData forestObj;

        /// <summary>
        /// 用来做道路的obj
        /// </summary>
        public StaticObjData wayObj;

        /// <summary>
        /// 用来做墙的obj
        /// </summary>
        public StaticObjData wallObj;

        /// <summary>
        /// 用来做墙节点的obj
        /// </summary>
        public StaticObjData wallNodeObj;

        /// <summary>
        /// 用来做树的obj
        /// </summary>
        public StaticObjsData[] treeObjs;

        /// <summary>
        /// 用来做房子的obj
        /// </summary>
        public StaticObjsData[] houseObjs;

        /// <summary>
        /// 用来做必要商店的obj
        /// </summary>
        public StaticObjsData[] shopObjs;

        /// <summary>
        /// 用来做拓展商店的obj
        /// </summary>
        public StaticObjsData[] exshopObjs;

        /// <summary>
        /// 用于地面装饰物的obj
        /// </summary>
        public StaticObjsData[] decorateObjs;

        /// <summary>
        /// 随机种子
        /// </summary>
        public int seed = 100;

        /// <summary>
        /// 树密度
        /// </summary>
        public int tree_density = 5;
        /// <summary>
        /// 地面装饰物密度
        /// </summary>
        public int decorate_density = 20;

        List<SpaceData> grounds;
        List<SpaceData> walls;
        List<SpaceData> ways;
        List<SpaceData> houses;
        List<SpaceData> decorates;
        List<SpaceData> doors;
        List<SpaceData> allData;

        private List<GameObject> all_obj;
        public MapData map_data;
        

        private void Awake() {
            Init();
        }

        private void Init() {
            seaObj.Init();
            groundObj.Init();
            city_groundObj.Init();
            forestObj.Init();
            wallObj.Init();
            wallNodeObj.Init();
            wayObj.Init();
            waterObj.Init();
            foreach (var item in shopObjs) {
                item.Init();
            }
            foreach (var item in houseObjs) {
                item.Init();
            }
        }

        public void NewWorld() {
            StopAllCoroutines();
            if (thread != null) {
                thread.Abort();
            }
            StartCoroutine(LoadWorld());
        }

        public bool onGenerateMap = false;
        public GenerateState generate_state;
        public float step_progress;
        Thread thread;
        // public float all_progress;
        public IEnumerator LoadWorld() {
            onGenerateMap = false;
            generate_state = GenerateState.Begin;
            step_progress = 0;
            string path = MapPath();
            if (File.Exists(path)) {
                generate_state = GenerateState.LoadFile;
                onGenerateMap = true;
                thread = new Thread(() => {
                    byte[] bytes = File.ReadAllBytes(path);
                    using (MemoryStream ms = new MemoryStream(bytes)) {
                        // //以二进制格式将对象或整个连接对象图形序列化和反序列化。
                        IFormatter formatter = new BinaryFormatter();
                        //把字符串以二进制放进memStream中
                        map_data = (MapData)formatter.Deserialize(ms);
                    }
                    onGenerateMap = false;
                });
                thread.Start();
                while (onGenerateMap) {
                    yield return 0;
                }
            } else {
                onGenerateMap = true;
                thread = new Thread(GenerateWorld);
                thread.Start();
                while (onGenerateMap) {
                    yield return 0;
                }
            }

            generate_state = GenerateState.BuildWorld;
            yield return CreateWorldGameObject(map_data.allData);
            generate_state = GenerateState.End;
        }

        public string MapPath() {
            return string.Format("{0}_{1}.map", seed, generate_size);
        }

        public void GenerateWorld() {
            MapTools.SetRandomSeed(seed);
            DateTime start_time = DateTime.Now;
            if (seed < 0) {
                seed = (int)start_time.Second;
            }
            grounds = new List<SpaceData>();
            walls = new List<SpaceData>();
            ways = new List<SpaceData>();
            houses = new List<SpaceData>();
            decorates = new List<SpaceData>();
            doors = new List<SpaceData>();

            generate_state = GenerateState.Space;
            step_progress = 0;

            grounds.AddRange(CreateSpacePos(city_count, city_size, city_random, city_dis, SpaceType.City));
            grounds.AddRange(CreateSpacePos(field_count, field_size, field_random, field_dis, SpaceType.Forest));
            grounds.AddRange(CreateGround(grounds.ToArray()));
            generate_state = GenerateState.City;
            step_progress = 0;

            BuildCity();
            generate_state = GenerateState.Decorate;
            step_progress = 0;
            BuildDecorate();

            generate_state = GenerateState.SaveFile;
            step_progress = 0;

            allData = new List<SpaceData>(grounds.Count + walls.Count + ways.Count + houses.Count + decorates.Count);
            allData.AddRange(grounds);
            allData.AddRange(walls);
            allData.AddRange(ways);
            allData.AddRange(houses);
            allData.AddRange(decorates);
            allData.AddRange(doors);

            int map_size = this.map_size / 2 + map_edge;
            Vector3 map_pos = new Vector3(map_size, sea_altitude, map_size);
            Vector3 sea_scale = new Vector3(this.map_size * 8 + 1000, 1, this.map_size * 8 + 1000);
            allData.Add(new SpaceData(map_pos, sea_scale, SpaceType.Sea, useMeshScale: true));
            Vector3 water_scale = new Vector3(this.map_size + map_edge * 2, 1, this.map_size + map_edge * 2);
            allData.Add(new SpaceData(map_pos + new Vector3(0, 0.05f, 0), water_scale, SpaceType.Water, useMeshScale: true));

            SpaceData[] all_data = allData.ToArray();
            map_data = new MapData() { allData = all_data };

            using (MemoryStream ms = new MemoryStream()) {
                IFormatter formatter = new BinaryFormatter();
                formatter.Serialize(ms, map_data);
                byte[] mepData = ms.GetBuffer();
                File.WriteAllBytes(MapPath(), mepData);
            }

            grounds = null;
            walls = null;
            ways = null;
            houses = null;
            decorates = null;
            doors = null;
            allData = null;

            DateTime end_time = DateTime.Now;
            Debug.Log("创造世界总花费时间：" + (end_time - start_time).TotalMilliseconds);
            onGenerateMap = false;
        }

        private void BuildDecorate() {
            DateTime start_time = DateTime.Now;

            List<SpaceData> tmp_trees = new List<SpaceData>();
            int min_map_pos = map_edge - ground_size;
            float max_map_pos = map_size + map_edge + ground_size;

            for (int x1 = min_map_pos; x1 < max_map_pos; x1++) {
                step_progress = x1 / max_map_pos;
                for (int y1 = min_map_pos; y1 < max_map_pos; y1++) {
                    float x = x1 + MapTools.RandomRange(-0.38f, 0.38f);
                    float z = y1 + MapTools.RandomRange(-0.38f, 0.38f);
                    float max_dis = default;
                    Vector3 center = default;
                    CreateType create = CreateType.Node;
                    foreach (SpaceData item in grounds) {
                        if (item.IsTherein(new Vector3(x, 0, z), 2)) {
                            if (item.type == SpaceType.City) {
                                create = CreateType.City;
                                break;
                            } else if (item.type == SpaceType.Forest) {
                                create = CreateType.Tree;
                                center = item.pos;
                                max_dis = Mathf.Max(item.scale.x, item.scale.z) / 2.5f;
                                break;
                            } else if (item.type == SpaceType.Ground) {
                                if (item.IsTherein(new Vector3(x, 0, z), -space_edge)) {
                                    create = CreateType.Decorate;
                                    break;
                                }
                            }
                        }
                    }

                    if (create != CreateType.Node) {
                        int ran_create_id = MapTools.RandomRange(0, 100);
                        if (ran_create_id < tree_density) {
                            if (create == CreateType.Tree && create != CreateType.City) {
                                Vector3 pos = new Vector3(x, 1, z);
                                float center_dis = Vector3.Distance(pos, center);
                                bool can_create = center_dis < max_dis;
                                // 城门周围50米不创建树
                                if (can_create) {
                                    foreach (var item in doors) {
                                        if (Vector3.Distance(item.pos, pos) < space_size) {
                                            can_create = false;
                                            break;
                                        }
                                    }
                                }
                                if (can_create) {
                                    float tree_size = MapTools.RandomRange(0.75f, 1.25f);
                                    if (center_dis < max_dis * 0.5f) {
                                        tree_size *= MapTools.RandomRange(1f, 1.25f);
                                    } else if (center_dis < max_dis * 0.25f) {
                                        tree_size *= MapTools.RandomRange(1.25f, 1.5f);
                                    } else if (center_dis < max_dis * 0.1f) {
                                        tree_size *= MapTools.RandomRange(1.5f, 2f);
                                    }
                                    int ran = MapTools.RandomRange(0, treeObjs[0].objs.Length);
                                    SpaceData tree = new SpaceData(pos, new Vector3(tree_size, tree_size, tree_size), SpaceType.Tree, angle: MapTools.RandomRange(0f, 360f), id: 0, idx: ran);
                                    foreach (var item in tmp_trees) {
                                        if (item.IsOverlap(tree, 1)) {
                                            can_create = false;
                                        }
                                    }
                                    if (can_create) {
                                        tmp_trees.Add(tree);
                                    }
                                }
                            }
                        } else if (ran_create_id < decorate_density) {
                            var pos = new Vector3(x, 1, z);
                            bool can_create = true;
                            if (create == CreateType.City) {
                                can_create = false;
                            }
                            if (can_create) {
                                int ran = MapTools.RandomRange(0, decorateObjs[0].objs.Length);
                                float decorate_size = MapTools.RandomRange(0.2f, 0.5f);
                                SpaceData decorate = new SpaceData(pos, new Vector3(decorate_size, decorate_size, decorate_size), SpaceType.Decorate, angle: MapTools.RandomRange(0f, 360f), id: 0, idx: ran);
                                decorates.Add(decorate);
                            }
                        }
                    }
                }
            }
            decorates.AddRange(tmp_trees);

            DateTime end_time = DateTime.Now;
            Debug.Log("创造装饰物花费时间：" + (end_time - start_time).TotalMilliseconds);
        }


        int house_width = 10;
        int house_length = 8;
        // 每个区域大概50*50  边界留10米  道路3米宽 围墙宽3米 城门宽5米
        int space_size = 50;
        int space_edge = 10;
        int way_width = 2;
        int wall_width = 2;
        int wallnode_size = 3;
        int door_width = 4;
        private void BuildCity() {
            DateTime start_time = DateTime.Now;

            List<SpaceData> tmp_shops = new List<SpaceData>();
            int half_wall_width = (int)(wall_width * 0.5f);

            // generate_progress = 2 / 3f + i / max / 3f;
            float all_count = grounds.Count;
            float local_progress = 1 / all_count;
            for (int j = 0; j < all_count; j++) {
                float progress = j / all_count;
                SpaceData item = grounds[j];

                if (item.type == SpaceType.City) {
                    SpaceData city = item;

                    Vector3 pos = item.pos;
                    float width = item.scale.x;
                    float length = item.scale.z;
                    float min_x = item.min_x;
                    float max_x = item.max_x;
                    float min_y = item.min_z;
                    float max_y = item.max_z;

                    // 城门统一坐北朝南
                    // 随机道路  
                    // 先随机一个点，然后随机一个方向建立道路，再向两边建立道路
                    int way_node_min_x = (int)(min_x + space_size + space_edge);
                    int way_node_min_y = (int)(min_y + space_size + space_edge);
                    int way_node_max_x = (int)(max_x - space_size - space_edge);
                    int way_node_max_y = (int)(max_y - space_size - space_edge);
                    // 创建城市中心点
                    Vector3 city_center;
                    if (width > ((space_size + space_edge) * 0.5f) && length > ((space_size + space_edge) * 0.5f)) {
                        city_center = new Vector3(MapTools.RandomRange(way_node_min_x, way_node_max_x), 0, MapTools.RandomRange(way_node_min_y, way_node_max_y));
                        Debug.Log(city_center);
                    } else {
                        city_center = new Vector3(min_x + (min_y - min_x) * 0.5f, 0, max_x + (max_y - max_x) * 0.5f);
                    }

                    // 东墙
                    Vector3 east_wall_pos = new Vector3(max_x - half_wall_width, 1, pos.z);
                    float east_wall_width = wall_width;
                    float east_wall_length = length;
                    SpaceData east_wall = new SpaceData(east_wall_pos, new Vector3(east_wall_width, 3, east_wall_length), SpaceType.Wall, useMeshScale: true);
                    // 西墙
                    Vector3 west_wall_pos = new Vector3(min_x + half_wall_width, 1, pos.z);
                    float west_wall_width = wall_width;
                    float west_wall_length = length;
                    SpaceData west_wall = new SpaceData(west_wall_pos, new Vector3(west_wall_width, 3, west_wall_length), SpaceType.Wall, useMeshScale: true);
                    //北墙
                    Vector3 north_wall_pos = new Vector3(pos.x, 1, max_y - half_wall_width);
                    float north_wall_width = width;
                    float north_wall_length = wall_width;
                    SpaceData north_wall = new SpaceData(north_wall_pos, new Vector3(north_wall_width, 3, north_wall_length), SpaceType.Wall, useMeshScale: true);
                    // 南墙1
                    float south1_wall_width = (int)(max_x - city_center.x - door_width);
                    float south1_wall_length = wall_width;
                    Vector3 south1_wall_pos = new Vector3(max_x - south1_wall_width * 0.5f, 1, min_y + half_wall_width);
                    SpaceData south1_wall = new SpaceData(south1_wall_pos, new Vector3(south1_wall_width, 3, south1_wall_length), SpaceType.Wall, useMeshScale: true);
                    // 南墙2
                    float south2_wall_width = (int)(city_center.x - min_x - door_width);
                    float south2_wall_length = wall_width;
                    Vector3 south2_wall_pos = new Vector3(min_x + south2_wall_width * 0.5f, 1, min_y + half_wall_width);
                    SpaceData south2_wall = new SpaceData(south2_wall_pos, new Vector3(south2_wall_width, 3, south2_wall_length), SpaceType.Wall, useMeshScale: true);

                    walls.Add(east_wall);
                    walls.Add(west_wall);
                    walls.Add(north_wall);
                    walls.Add(south1_wall);
                    walls.Add(south2_wall);

                    // 围墙柱子
                    walls.Add(new SpaceData(new Vector3(min_x + half_wall_width, 1, min_y + half_wall_width), new Vector3(wallnode_size, 5, wallnode_size), SpaceType.WallNode, useMeshScale: true));
                    walls.Add(new SpaceData(new Vector3(min_x + half_wall_width, 1, max_y - half_wall_width), new Vector3(wallnode_size, 5, wallnode_size), SpaceType.WallNode, useMeshScale: true));
                    walls.Add(new SpaceData(new Vector3(max_x - half_wall_width, 1, min_y + half_wall_width), new Vector3(wallnode_size, 5, wallnode_size), SpaceType.WallNode, useMeshScale: true));
                    walls.Add(new SpaceData(new Vector3(max_x - half_wall_width, 1, max_y - half_wall_width), new Vector3(wallnode_size, 5, wallnode_size), SpaceType.WallNode, useMeshScale: true));
                    walls.Add(new SpaceData(new Vector3(min_x + south2_wall_width - half_wall_width, 1, min_y + half_wall_width), new Vector3(wallnode_size * 2, 5, wallnode_size * 2), SpaceType.WallNode, useMeshScale: true));
                    walls.Add(new SpaceData(new Vector3(max_x - south1_wall_width + half_wall_width, 1, min_y + half_wall_width), new Vector3(wallnode_size * 2, 5, wallnode_size * 2), SpaceType.WallNode, useMeshScale: true));

                    var door = new SpaceData(new Vector3(city_center.x, 0, min_y), new Vector3(door_width, 1, 1), SpaceType.Door);
                    // 门
                    doors.Add(door);

                    //主干道
                    List<SpaceData> ways = new List<SpaceData>();
                    int main_way_vertical_width = door_width;
                    int main_way_vertical_length = (int)(max_y - min_y - space_edge);

                    int main_way_horizontal_width = (int)(max_x - min_x - space_edge * 2);
                    int main_way_horizontal_length = door_width;

                    Vector3 main_vertical_way_pos = new Vector3(city_center.x, 1, min_y + main_way_vertical_length * 0.5f);
                    Vector3 main_horizontal_way_pos = new Vector3(min_x + main_way_horizontal_width * 0.5f + space_edge, 1, city_center.z);

                    SpaceData main_vertical_way = new SpaceData(main_vertical_way_pos, new Vector3(main_way_vertical_width, 0.08f, main_way_vertical_length), SpaceType.Way, useMeshScale: true);
                    SpaceData main_horizontal_way = new SpaceData(main_horizontal_way_pos, new Vector3(main_way_horizontal_width, 0.08f, main_way_horizontal_length), SpaceType.Way, useMeshScale: true);
                    ways.Add(main_vertical_way);
                    ways.Add(main_horizontal_way);
                    // 添加本城市道路
                    this.ways.AddRange(ways);
                    step_progress = progress + 0.1f * local_progress;

                    // 中心点向主干道两边创建商店
                    int shop_idx = house_width;
                    float house_offset = house_width * 0.5f + way_width;
                    float main_way_right_x = city_center.x + house_offset;
                    float main_way_left_x = city_center.x - house_offset;
                    float main_way_up_y = city_center.z + house_offset;
                    float main_way_down_y = city_center.z - house_offset;

                    float max_count = Mathf.Max(main_way_vertical_width, main_way_vertical_length) * 1f;
                    while (true) {
                        int up_y = (int)(city_center.z + shop_idx);
                        int down_y = (int)(city_center.z - shop_idx);
                        int right_x = (int)(city_center.x + shop_idx);
                        int left_x = (int)(city_center.x - shop_idx);

                        step_progress = progress + (0.1f + 0.2f * Mathf.Min(shop_idx / max_count, 1)) * local_progress;

                        if (up_y > (main_vertical_way.max_z) && down_y < (main_vertical_way.min_z) && right_x > (main_horizontal_way.max_x) && left_x < (main_horizontal_way.min_x)) {
                            break;
                        }
                        //上面的
                        if (up_y < (main_vertical_way.max_z) && Vector3.Distance(door.pos, new Vector3(main_way_right_x, 1, up_y)) > space_edge) {
                            tmp_shops.Add(BuildHouse(new Vector3(main_way_right_x, 1, up_y), Direction.West, SpaceType.Shop));
                            tmp_shops.Add(BuildHouse(new Vector3(main_way_left_x, 1, up_y), Direction.East, SpaceType.Shop));
                        }
                        //下面的
                        if (down_y > (main_vertical_way.min_z) && Vector3.Distance(door.pos, new Vector3(main_way_right_x, 1, down_y)) > space_edge) {
                            tmp_shops.Add(BuildHouse(new Vector3(main_way_right_x, 1, down_y), Direction.West, SpaceType.Shop));
                            tmp_shops.Add(BuildHouse(new Vector3(main_way_left_x, 1, down_y), Direction.East, SpaceType.Shop));
                        }


                        right_x += house_width;
                        left_x -= house_width;
                        // 右边的
                        if (right_x < (main_horizontal_way.max_x) && Vector3.Distance(door.pos, new Vector3(right_x, 1, main_way_up_y)) > space_edge) {
                            tmp_shops.Add(BuildHouse(new Vector3(right_x, 1, main_way_up_y), Direction.South, SpaceType.Shop));
                            tmp_shops.Add(BuildHouse(new Vector3(right_x, 1, main_way_down_y), Direction.North, SpaceType.Shop));
                        }
                        // 左边的
                        if (left_x > (main_horizontal_way.min_x) && Vector3.Distance(door.pos, new Vector3(left_x, 1, main_way_up_y)) > space_edge) {
                            tmp_shops.Add(BuildHouse(new Vector3(left_x, 1, main_way_up_y), Direction.South, SpaceType.Shop));
                            tmp_shops.Add(BuildHouse(new Vector3(left_x, 1, main_way_down_y), Direction.North, SpaceType.Shop));
                        }
                        shop_idx += house_width;
                    }

                    // 创建民房
                    float try_count = city.scale.x * city.scale.z / 50;
                    for (int i = 0; i < try_count; i++) {

                        step_progress = progress + (0.3f + 0.7f * i / try_count) * local_progress;

                        int x = (int)MapTools.RandomRange(city.min_x + space_edge, city.max_x - space_edge);
                        int y = (int)MapTools.RandomRange(city.min_z + space_edge, city.max_z - space_edge);
                        bool can_build = true;
                        SpaceData h = BuildHouse(new Vector3(x, 1, y), x < city_center.x ? Direction.East : Direction.West, SpaceType.House);
                        foreach (SpaceData shop in tmp_shops) {
                            if (shop.IsOverlap(h, 8)) {
                                can_build = false;
                            }
                        }
                        if (can_build) {
                            foreach (SpaceData house in houses) {
                                if (house.IsOverlap(h, 7)) {
                                    can_build = false;
                                }
                            }
                        }
                        if (can_build && Vector3.Distance(door.pos, h.pos) > space_edge * 2 && Vector3.Distance(city_center, h.pos) > space_edge * 2) {
                            houses.Add(h);
                        }
                    };

                    Debug.Log("创建民房 " + houses.Count + "/" + try_count);
                }
            }
            houses.AddRange(tmp_shops);

            DateTime end_time = DateTime.Now;
            Debug.Log("生成城市花费时间：" + (end_time - start_time).TotalMilliseconds);
        }

        /// <summary>
        /// 生成房子
        /// </summary>
        /// <param name="pos">位置</param>
        /// <param name="dir">方向</param>
        private SpaceData BuildHouse(Vector3 pos, Direction dir, SpaceType typ) {
            StaticObjsData[] objs;
            switch (typ) {
                case SpaceType.House:
                    objs = houseObjs;
                    break;
                case SpaceType.Shop:
                    objs = shopObjs;
                    break;
                default:
                    objs = null;
                    break;
            }
            int id = objs == null ? 0 : MapTools.RandomRange(0, objs.Length);
            int idx = objs == null ? 0 : MapTools.RandomRange(0, objs[id].objs.Length);

            var size = MapTools.RandomRange(0.9f, 1.1f);
            float angle = MapTools.RandomRange(-5f, 5f);
            switch (dir) {
                case Direction.East:
                    angle += 90;
                    break;
                case Direction.West:
                    angle += 270;
                    break;
                case Direction.South:
                    angle += 180;
                    break;
            }
            return (new SpaceData(pos, new Vector3(size, size, size), typ, angle: angle, id: id, idx: idx));
        }

        private IEnumerator CreateWorldGameObject(SpaceData[] all_data) {
            DateTime start_time = DateTime.Now;
            if (all_obj != null) {
                foreach (GameObject item in all_obj) {
                    Destroy(item);
                }
            }
            all_obj = new List<GameObject>();

            int max = all_data.Length;
            int progress = 0;
            for (int i = 0; i < max; i++) {
                progress = i / max;
                if (progress != step_progress) {
                    step_progress = progress;
                    yield return 0;
                }
                SpaceData space_data = all_data[i];

                StaticObj static_obj = null;
                switch (space_data.type) {
                    case SpaceType.Forest:
                        break;
                    case SpaceType.Ground:
                        static_obj = groundObj.obj;
                        break;
                    case SpaceType.City:
                        static_obj = city_groundObj.obj;
                        break;
                    case SpaceType.House:
                        static_obj = houseObjs[space_data.id].objs[space_data.idx];
                        break;
                    case SpaceType.Shop:
                        static_obj = shopObjs[space_data.id].objs[space_data.idx];
                        break;
                    case SpaceType.Way:
                        static_obj = wayObj.obj;
                        break;
                    case SpaceType.Wall:
                        static_obj = wallObj.obj;
                        break;
                    case SpaceType.WallNode:
                        static_obj = wallNodeObj.obj;
                        break;
                    case SpaceType.Tree:
                        static_obj = treeObjs[space_data.id].objs[space_data.idx];
                        break;
                    case SpaceType.Decorate:
                        static_obj = decorateObjs[space_data.id].objs[space_data.idx];
                        break;
                    case SpaceType.Sea:
                        static_obj = seaObj.obj;
                        break;
                    case SpaceType.Water:
                        static_obj = waterObj.obj;
                        break;
                    default:
                        break;
                }
                if (static_obj != null) {
                    GameObject obj = Instantiate(static_obj.prefab, new Vector3(space_data.pos.x, space_data.pos.y, space_data.pos.z), Quaternion.Euler(0, space_data.angle, 0));
                    if (space_data.useMeshScale) {
#if UNITY_EDITOR
                        if (static_obj.scale == default) {
                            Debug.LogError("检查是obj否已经调用Init函数初始化:" + space_data.type);
                        }
#endif
                        obj.transform.localScale = new Vector3(space_data.scale.x * static_obj.scale.x, space_data.scale.y * static_obj.scale.y, space_data.scale.z * static_obj.scale.z);
                    } else {
                        obj.transform.localScale = space_data.scale;
                    }
                    all_obj.Add(obj);
                }
            }

            DateTime end_time = DateTime.Now;
            Debug.Log("创造地表花费时间：" + (end_time - start_time).TotalMilliseconds);

            yield return 0;
        }

        private SpaceData[] CreateGround(SpaceData[] grounds) {
            List<SpaceData> result = new List<SpaceData>();
            float max = grounds.Length;
            for (int i = 0; i < max; i++) {
                SpaceData item = grounds[i];
                SpaceData data = new SpaceData(item.pos - new Vector3(0, 0.05f, 0), new Vector3(item.scale.x + ground_size, 1, item.scale.z + ground_size), SpaceType.Ground, useMeshScale: true);
                result.Add(data);
                step_progress = 2 / 3f + i / max / 3f;
            }
            return result.ToArray();
        }

        private SpaceData[] CreateSpacePos(int count, int size, int rand, int dis, SpaceType typ) {
            List<SpaceData> rand_pos = new List<SpaceData>();
            int idx = 0;
            // 最多随机多100次，避免地图太小无法创建足够多的坐标
            float max = count + 100f;
            // 最小随机位置
            int min_pos = size / 2 + map_edge;
            // 最大随机位置
            int max_pos = map_size - size / 2 + map_edge;
            // 最小距离
            int min_dis = size + dis;
            switch (typ) {
                case SpaceType.Forest:
                    step_progress = idx / max / 3;
                    break;
                case SpaceType.City:
                    step_progress = 1 / 3f + idx / max / 3;
                    break;
            }
            while (idx < max) {
                idx++;
                int pos_x = MapTools.RandomRange(min_pos, max_pos);
                int pos_y = MapTools.RandomRange(min_pos, max_pos);
                Vector2 pos = new Vector2(pos_x, pos_y);
                int width;
                int height;
                if (idx > max / 10) {
                    width = size - rand;
                    height = size - rand;
                } else if (idx > max / 2) {
                    width = MapTools.RandomRange(size - rand, size);
                    height = MapTools.RandomRange(size - rand, size);
                } else {
                    width = MapTools.RandomRange(size, size + rand);
                    height = MapTools.RandomRange(size, size + rand);
                }
                SpaceData data = new SpaceData(new Vector3(pos_x, 0.05f, pos_y), new Vector3(MapTools.RandomRange(size - rand, size + rand), 1, MapTools.RandomRange(size - rand, size + rand)), typ, useMeshScale: true);
                bool can_pos = true;
                foreach (SpaceData p in rand_pos) {
                    if (p.IsOverlap(data, dis)) {
                        // 距离太近，需要重新随机
                        can_pos = false;
                        break;
                    }
                }

                if (!can_pos) {
                    continue;
                }

                rand_pos.Add(data);
                if (rand_pos.Count >= count) {
                    // 已经随机创建足够多的城市坐标
                    break;
                }
            }
            return rand_pos.ToArray();
        }

        private int generate_size = 0;
        private void SetGenerateSize() {
            switch (generate_size) {
                case 1:
                    map_size = 2000;
                    field_count = 300;
                    break;
                case 2:
                    map_size = 7500;
                    field_count = 1000;
                    break;
                default:
                    map_size = 750;
                    field_count = 100;
                    break;
            }
        }
#if UNITY_EDITOR

        private void OnGUI() {
            if (seed > 0) {
                if (GUI.Button(new Rect(10, 10, 30, 30), "<")) {
                    seed--;
                    NewWorld();
                }
            }
            if (seed < int.MaxValue) {
                if (GUI.Button(new Rect(40, 10, 30, 30), ">")) {
                    seed++;
                    NewWorld();
                }
            }
            if (GUI.Button(new Rect(70, 10, 30, 30), "小")) {
                generate_size = 0;
                SetGenerateSize();
                NewWorld();
            }
            if (GUI.Button(new Rect(100, 10, 30, 30), "中")) {
                generate_size = 1;
                SetGenerateSize();
                NewWorld();
            }
            if (GUI.Button(new Rect(130, 10, 30, 30), "大")) {
                generate_size = 2;
                SetGenerateSize();
                NewWorld();
            }
            if (GUI.Button(new Rect(160, 10, 30, 30), "☢")) {
                NewWorld();
            }

            if (allData != null) {
                GUI.Label(new Rect(10, 40, 200, 30), "count:" + allData.Count);
            }
            if (onGenerateMap) {

                string state_name = MapTools.GetEnumName(generate_state);
                GUI.Label(new Rect(10, 70, 100, 30), string.Format("{0}:{1:F}", state_name, +step_progress * 100));
            }
        }
#endif
    }
}