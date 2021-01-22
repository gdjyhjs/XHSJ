using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

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

        List<SpaceData> grounds;
        List<SpaceData> walls;
        List<SpaceData> ways;
        List<SpaceData> houses;
        List<SpaceData> decorates;
        List<SpaceData> allData;

        private List<GameObject> all_obj;

        private void Awake() {
            seaObj.Init();
            groundObj.Init();
            city_groundObj.Init();
            forestObj.Init();
            wallObj.Init();
            wallNodeObj.Init();
            wayObj.Init();
            foreach (var item in shopObjs) {
                item.Init();
            }
            foreach (var item in houseObjs) {
                item.Init();
            }
        }

        public void GenerateWorld() {
            DateTime start_time = DateTime.Now;
            if (seed < 0) {
                seed = (int)start_time.Second;
            }
            Random.InitState(seed);
            grounds = new List<SpaceData>();
            walls = new List<SpaceData>();
            ways = new List<SpaceData>();
            houses = new List<SpaceData>();
            decorates = new List<SpaceData>();

            grounds.AddRange(CreateSpacePos(city_count, city_size, city_random, city_dis, SpaceType.City));
            grounds.AddRange(CreateSpacePos(field_count, field_size, field_random, field_dis, SpaceType.Forest));
            grounds.AddRange(CreateGround(grounds.ToArray()));
            BuildCity();
            BuildDecorate();
            CreateWorldGameObject();

            allData = new List<SpaceData>(grounds.Count + walls.Count + ways.Count + houses.Count + decorates.Count);
            allData.AddRange(grounds);
            allData.AddRange(walls);
            allData.AddRange(ways);
            allData.AddRange(houses);
            allData.AddRange(decorates);

            DateTime end_time = DateTime.Now;
            Debug.Log("创造世界总花费时间：" + (end_time - start_time).TotalMilliseconds);
        }

        private void BuildDecorate() {

            int min_map_pos = map_edge - ground_size;
            int max_map_pos = map_size + map_edge + ground_size;
            for (int x1 = min_map_pos; x1 < max_map_pos; x1++) {
                for (int y1 = min_map_pos; y1 < max_map_pos; y1++) {
                    float x = x1 + Random.Range(-0.38f, 0.38f);
                    float y = y1 + Random.Range(-0.38f, 0.38f);
                    CreateType create = CreateType.Node;
                    foreach (SpaceData item in grounds) {
                        if (item.IsTherein(new Vector2(x, y), 2)) {
                            if (item.type == SpaceType.City) {
                                create = CreateType.City;
                                break;
                            } else {
                                create = CreateType.Tree;
                                break;
                            }
                        }
                    }

                    if (create == CreateType.Node) {
                        int ground_dege = ground_size / 2 - 2;
                        foreach (SpaceData item in grounds) {
                            if (item.IsTherein(new Vector2(x, y), ground_dege)) {
                                create = CreateType.Decorate;
                                break;
                            }
                        }
                    }

                    if (create != CreateType.City && create != CreateType.Node) {
                        int ran_create_id = Random.Range(0, 100);
                        if (ran_create_id < 5) {
                            if (create == CreateType.Tree) {
                                float tree_size = Random.Range(0.5f, 1.5f);
                                SpaceData tree = new SpaceData(new Vector3(x, 1, y), tree_size, tree_size, SpaceType.Tree, angle: Random.Range(0f, 360f));
                                decorates.Add(tree);
                            }
                        } else if (ran_create_id < 15) {
                            float decorate_size = Random.Range(0.05f, 0.2f);
                            SpaceData tree = new SpaceData(new Vector3(x, 1, y), decorate_size, decorate_size, SpaceType.Decorate, angle: Random.Range(0f, 360f));
                            decorates.Add(tree);
                        }
                    }
                }
            }
        }


        int house_width = 10;
        int house_length = 8;
        private void BuildCity() {
            // 每个区域大概50*50  边界留10米  道路3米宽 围墙宽3米 城门宽5米
            int space_size = 50;
            int space_edge = 10;
            int way_width = 2;
            int wall_width = 2;
            int wallnode_size = 3;
            int door_width = 4;
            int half_wall_width = (int)(wall_width * 0.5f);

            DateTime start_time = DateTime.Now;

            foreach (SpaceData item in grounds) {
                
                if (item.type == SpaceType.City) {
                    SpaceData city = item;

                    Vector2 pos = item.pos;
                    float width = item.width;
                    float length = item.length;
                    float min_x = item.min_x;
                    float max_x = item.max_x;
                    float min_y = item.min_y;
                    float max_y = item.max_y;

                    // 城门统一坐北朝南
                    // 随机道路  
                    // 先随机一个点，然后随机一个方向建立道路，再向两边建立道路
                    int way_node_min_x = (int)(min_x + space_size + space_edge);
                    int way_node_min_y = (int)(min_y + space_size + space_edge);
                    int way_node_max_x = (int)(max_x - space_size - space_edge);
                    int way_node_max_y = (int)(max_y - space_size - space_edge);
                    // 创建城市中心点
                    Vector2 city_center;
                    if (width > ((space_size + space_edge) * 0.5f) && length > ((space_size + space_edge) * 0.5f)) {
                        city_center = new Vector2(Random.Range(way_node_min_x, way_node_max_x), Random.Range(way_node_min_y, way_node_max_y));
                        Debug.Log(city_center);
                    } else {
                        city_center = new Vector2(min_x + (min_y - min_x) * 0.5f, max_x + (max_y - max_x) * 0.5f);
                    }

                    // 东墙
                    Vector2 east_wall_pos = new Vector2(max_x - half_wall_width, pos.y);
                    float east_wall_width = wall_width;
                    float east_wall_length = length;
                    SpaceData east_wall = new SpaceData(east_wall_pos, east_wall_width, east_wall_length, SpaceType.Wall);
                    // 西墙
                    Vector2 west_wall_pos = new Vector2(min_x + half_wall_width, pos.y);
                    float west_wall_width = wall_width;
                    float west_wall_length = length;
                    SpaceData west_wall = new SpaceData(west_wall_pos, west_wall_width, west_wall_length, SpaceType.Wall);
                    //北墙
                    Vector2 north_wall_pos = new Vector2(pos.x, max_y - half_wall_width);
                    float north_wall_width = width;
                    float north_wall_length = wall_width;
                    SpaceData north_wall = new SpaceData(north_wall_pos, north_wall_width, north_wall_length, SpaceType.Wall);
                    // 南墙1
                    float south1_wall_width = (int)(max_x - city_center.x - door_width);
                    float south1_wall_length = wall_width;
                    Vector2 south1_wall_pos = new Vector2(max_x - south1_wall_width * 0.5f, min_y + half_wall_width);
                    SpaceData south1_wall = new SpaceData(south1_wall_pos, south1_wall_width, south1_wall_length, SpaceType.Wall);
                    // 南墙2
                    float south2_wall_width = (int)(city_center.x - min_x - door_width);
                    float south2_wall_length = wall_width;
                    Vector2 south2_wall_pos = new Vector2(min_x + south2_wall_width * 0.5f, min_y + half_wall_width);
                    SpaceData south2_wall = new SpaceData(south2_wall_pos, south2_wall_width, south2_wall_length, SpaceType.Wall);

                    walls.Add(east_wall);
                    walls.Add(west_wall);
                    walls.Add(north_wall);
                    walls.Add(south1_wall);
                    walls.Add(south2_wall);

                    // 从道路最里头往外创建交叉道路
                    walls.Add(new SpaceData(new Vector2(min_x + half_wall_width, min_y + half_wall_width), wallnode_size, wallnode_size, SpaceType.WallNode));
                    walls.Add(new SpaceData(new Vector2(min_x + half_wall_width, max_y - half_wall_width), wallnode_size, wallnode_size, SpaceType.WallNode));
                    walls.Add(new SpaceData(new Vector2(max_x - half_wall_width, min_y + half_wall_width), wallnode_size, wallnode_size, SpaceType.WallNode));
                    walls.Add(new SpaceData(new Vector2(max_x - half_wall_width, max_y - half_wall_width), wallnode_size, wallnode_size, SpaceType.WallNode));
                    walls.Add(new SpaceData(new Vector2(min_x + south2_wall_width - half_wall_width, min_y + half_wall_width), wallnode_size * 2, wallnode_size * 2, SpaceType.WallNode));
                    walls.Add(new SpaceData(new Vector2(max_x - south1_wall_width + half_wall_width, min_y + half_wall_width), wallnode_size * 2, wallnode_size * 2, SpaceType.WallNode));

                    //主干道
                    List<SpaceData> ways = new List<SpaceData>();
                    int main_way_vertical_width = door_width;
                    int main_way_vertical_length = (int)(max_y - min_y - space_edge);

                    int main_way_horizontal_width = (int)(max_x - min_x - space_edge * 2);
                    int main_way_horizontal_length = door_width;

                    Vector2 main_vertical_way_pos = new Vector2(city_center.x, min_y + main_way_vertical_length * 0.5f);
                    Vector2 main_horizontal_way_pos = new Vector2(min_x + main_way_horizontal_width * 0.5f + space_edge, city_center.y);

                    SpaceData main_vertical_way = new SpaceData(main_vertical_way_pos, main_way_vertical_width, main_way_vertical_length, SpaceType.Way, Direction.South);
                    SpaceData main_horizontal_way = new SpaceData(main_horizontal_way_pos, main_way_horizontal_width, main_way_horizontal_length, SpaceType.Way, Direction.East);
                    ways.Add(main_vertical_way);
                    ways.Add(main_horizontal_way);
                    // 添加本城市道路
                    this.ways.AddRange(ways);


                    // 中心点向主干道两边创建商店
                    int shop_idx = house_width / 2 + 1;
                    float house_offset =  house_width * 0.5f+way_width;
                    float main_way_right_x = city_center.x + house_offset;
                    float main_way_left_x = city_center.x - house_offset;
                    float main_way_up_y = city_center.y + house_offset;
                    float main_way_down_y = city_center.y - house_offset;
                    while (true){
                        int up_y = (int)(city_center.y + shop_idx);
                        int down_y = (int)(city_center.y - shop_idx);
                        int right_x = (int)(city_center.x + shop_idx);
                        int left_x = (int)(city_center.x - shop_idx);

                        if (up_y > (main_vertical_way.max_y - space_edge) && down_y < (main_vertical_way.min_y + space_edge) && right_x > (main_horizontal_way.max_x - space_edge) && left_x < (main_horizontal_way.min_x + space_edge)) {
                            break;
                        }
                        //上面的
                        if (up_y < (main_vertical_way.max_y - space_edge)) {
                            houses.Add(BuildHouse( new Vector2(main_way_right_x, up_y), Direction.West, SpaceType.Shop));
                            houses.Add(BuildHouse(new Vector2(main_way_left_x, up_y), Direction.East, SpaceType.Shop));
                        }
                        //下面的
                        if (down_y > (main_vertical_way.min_y + space_edge)) {
                            houses.Add(BuildHouse(new Vector2(main_way_right_x, down_y), Direction.West, SpaceType.Shop));
                            houses.Add(BuildHouse(new Vector2(main_way_left_x, down_y), Direction.East, SpaceType.Shop));
                        }
                        // 右边的
                        if (right_x < (main_horizontal_way.max_x - space_edge)) {
                            houses.Add(BuildHouse(new Vector2(right_x, main_way_up_y), Direction.South, SpaceType.Shop));
                            houses.Add(BuildHouse(new Vector2(right_x, main_way_down_y), Direction.North, SpaceType.Shop));
                        }
                        // 左边的
                        if (left_x > (main_horizontal_way.min_x + space_edge)) {
                            houses.Add(BuildHouse(new Vector2(left_x, main_way_up_y), Direction.South, SpaceType.Shop));
                            houses.Add(BuildHouse(new Vector2(left_x, main_way_down_y), Direction.North, SpaceType.Shop));
                        }

                        shop_idx += house_width;
                    }

                    // 创建民房
                    float try_count = city.width * city.length / 50;
                    for (int i = 0; i < try_count; i++) {
                        int x = (int)Random.Range(city.min_x + space_edge, city.max_x - space_edge);
                        int y = (int)Random.Range(city.min_y + space_edge, city.max_y - space_edge);
                        bool can_build = true;
                        SpaceData h = BuildHouse(new Vector2(x, y), (Direction)Random.Range(0, 5), SpaceType.House);
                        foreach (SpaceData house in houses) {
                            if (house.IsOverlap(h, 0)){
                                can_build = false;
                            }
                        }

                        if (can_build) {
                            houses.Add(h);
                        }
                    }
                    Debug.Log("创建民房 " + houses.Count + "/" + try_count);




                }
            }


            DateTime end_time = DateTime.Now;
            Debug.Log("生成城市花费时间：" + (end_time - start_time).TotalMilliseconds);
        }

        /// <summary>
        /// 生成房子
        /// </summary>
        /// <param name="pos">位置</param>
        /// <param name="dir">方向</param>
        private SpaceData BuildHouse( Vector2 pos, Direction dir, SpaceType typ) {
            return (new SpaceData(pos, house_width, house_length, typ, dir));
        }

        private void CreateWorldGameObject() {
            DateTime start_time = DateTime.Now;
            if (all_obj != null) {
                foreach (GameObject item in all_obj) {
                    Destroy(item);
                }
            }
            all_obj = new List<GameObject>();

            GameObject sea = Instantiate(seaObj.obj.prefab);
            Transform sea_tf = sea.transform;
            sea_tf.localScale = new Vector3(map_size * map_size, seaObj.obj.scale.y, map_size * map_size);
            int map_pos = map_size / 2 + map_edge;
            sea_tf.position = new Vector3(map_pos, sea_altitude, map_pos);
            all_obj.Add(sea);

            foreach (SpaceData item in grounds) {
                GameObject obj;
                float width = item.width;
                float height = item.length;
                if (item.type == SpaceType.City) {
                    obj = Instantiate(city_groundObj.obj.prefab);
                    Transform obj_tf = obj.transform;
                    obj_tf.localScale = new Vector3(width * city_groundObj.obj.scale.x, city_groundObj.obj.scale.y, height * city_groundObj.obj.scale.z);
                    obj_tf.position = new Vector3(item.pos.x, city_altitude, item.pos.y);
                    all_obj.Add(obj);
                }
                GameObject ground = Instantiate(groundObj.obj.prefab);
                Transform ground_tf = ground.transform;
                ground_tf.localScale = new Vector3((item.width + ground_size) * groundObj.obj.scale.x, groundObj.obj.scale.y, (item.length + ground_size) * groundObj.obj.scale.z);
                ground_tf.position = new Vector3(item.pos.x, ground_altitude, item.pos.y);
                all_obj.Add(ground);
            }


            foreach (SpaceData item in walls) {
                GameObject obj;
                int height;
                if (item.type == SpaceType.Wall) {
                    obj = Instantiate(wallObj.obj.prefab);
                    height = 3;
                } else {
                    obj = Instantiate(wallNodeObj.obj.prefab);
                    height = 5;
                }
                Transform obj_tf = obj.transform;
                obj_tf.localScale = new Vector3(item.width * wallObj.obj.scale.x, height * wallObj.obj.scale.y, item.length * wallObj.obj.scale.z);
                obj_tf.position = new Vector3(item.pos.x, 1, item.pos.y);
                all_obj.Add(obj);
            }

            foreach (SpaceData item in ways) {
                GameObject obj;
                float height;
                obj = Instantiate(wayObj.obj.prefab);
                height = 0.08f;
                Transform obj_tf = obj.transform;
                obj_tf.localScale = new Vector3(item.width * wallObj.obj.scale.x, height * wallObj.obj.scale.y, item.length * wallObj.obj.scale.z);
                obj_tf.position = new Vector3(item.pos.x, 1, item.pos.y);
                all_obj.Add(obj);
            }

            foreach (SpaceData item in houses) {
                GameObject obj;
                if (item.type == SpaceType.Shop) {
                    StaticObjsData data = shopObjs[Random.Range(0, shopObjs.Length)];
                    StaticObj[] objs = data.objs;
                    StaticObj o = objs[Random.Range(0, objs.Length)];
                    obj = Instantiate(o.prefab);
                } else {
                    StaticObjsData data = houseObjs[0];
                    StaticObj[] objs = data.objs;
                    StaticObj o = objs[Random.Range(0, objs.Length)];
                    obj = Instantiate(o.prefab);
                }
                Transform obj_tf = obj.transform;
                obj_tf.localScale = new Vector3(1, 1, 1);
                float rand_angle = Random.Range(-1f, 1f);
                obj_tf.position = new Vector3(item.pos.x + rand_angle, 1, item.pos.y + rand_angle);
                rand_angle *= 10;
                switch (item.dir) {
                    case Direction.East:
                        obj_tf.eulerAngles = new Vector3(0, 90 + rand_angle, 0);
                        break;
                    case Direction.West:
                        obj_tf.eulerAngles = new Vector3(0, 270 + rand_angle, 0);
                        break;
                    case Direction.South:
                        obj_tf.eulerAngles = new Vector3(0, 180 + rand_angle, 0);
                        break;
                    case Direction.North:
                        obj_tf.eulerAngles = new Vector3(0, rand_angle, 0);
                        break;
                }
                all_obj.Add(obj);
            }


            DateTime end_time = DateTime.Now;
            Debug.Log("创造地表花费时间：" + (end_time - start_time).TotalMilliseconds);
        }

        private SpaceData[] CreateGround(SpaceData[] grounds) {
            List<SpaceData> result = new List<SpaceData>();
            foreach (var item in grounds) {
                SpaceData data = new SpaceData(item.pos, item.width + ground_size, item.width, SpaceType.Ground);
                result.Add(data);
            }
            return result.ToArray();
        }

        private SpaceData[] CreateSpacePos(int count, int size, int rand, int dis, SpaceType typ) {
            List<SpaceData> rand_pos = new List<SpaceData>();
            int idx = 0;
            // 最多随机多100次，避免地图太小无法创建足够多的坐标
            int max = count + 100;
            // 最小随机位置
            int min_pos = size / 2 + map_edge;
            // 最大随机位置
            int max_pos = map_size - size / 2 + map_edge;
            // 最小距离
            int min_dis = size + dis;
            while (idx < max) {
                idx++;
                int pos_x = Random.Range(min_pos, max_pos);
                int pos_y = Random.Range(min_pos, max_pos);
                Vector2 pos = new Vector2(pos_x, pos_y);
                int width;
                int height;
                if (idx > max / 10) {
                    width = size - rand;
                    height = size - rand;
                } else if (idx > max / 2) {
                    width = Random.Range(size - rand, size);
                    height = Random.Range(size - rand, size);
                } else {
                    width = Random.Range(size, size + rand);
                    height = Random.Range(size, size + rand);
                }
                SpaceData data = new SpaceData(new Vector2(pos_x, pos_y), Random.Range(size - rand, size + rand), Random.Range(size - rand, size + rand), typ);
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

        private void Start() {
            GenerateWorld();
        }

#if UNITY_EDITOR
        private void OnGUI() {
            if (seed > 0) {
                if (GUI.Button(new Rect(10, 10, 30, 30), "<")) {
                    seed--;
                    GenerateWorld();
                }
            }
            if (seed < int.MaxValue) {
                if (GUI.Button(new Rect(40, 10, 30, 30), ">")) {
                    seed++;
                    GenerateWorld();
                }
            }
            GUI.Label(new Rect(10, 40, 100, 30), "count:"+ grounds.Count);
        }
#endif
    }
}