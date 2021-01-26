using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;

namespace GenerateWorld {

    /// <summary>
    /// 生成一个区域
    /// </summary>
    public class GenerateArea {
        public int area_id;
        GenerateMap generate;
        /// <summary>
        /// 区域
        /// </summary>
        SpaceData groundData;
        /// <summary>
        /// 城市或森林
        /// </summary>
        SpaceData spaceData;
        SpaceData waterData;
        public SpaceData[] tree_datas; // 树木
        public SpaceData[] decorate_datas; // 装饰物
        public SpaceData[] wall_datas; // 围墙和道路
        public SpaceData[] house_datas; // 住宅和商店

        SpaceData[] citys; // 树木

        List<GameObject> all_objs = new List<GameObject>();

        Thread thread;
        Dictionary<GenerateState, Coroutine> coroutines = new Dictionary<GenerateState, Coroutine>();

        int house_size = 10;
        // 每个区域大概50*50  边界留10米  道路3米宽 围墙宽3米 城门宽5米
        int space_size = 50;
        int space_edge = 10;
        int way_width = 2;
        int wall_width = 2;
        int wallnode_size = 3;
        int door_width = 4;
        float city_height;
        float ground_height;

        public GenerateArea(int area_id, GenerateMap generate, SpaceData groundData, SpaceData spaceData, SpaceData waterData) {
            this.area_id = area_id;
            this.generate = generate;
            this.groundData = groundData;
            this.spaceData = spaceData;
            citys = new SpaceData[generate.citys.Length];
            System.Array.Copy(generate.citys, citys, citys.Length);
            city_height = generate.city_height + 1;
            ground_height = generate.ground_height + 1;
            thread = new Thread(Generate);
            thread.Start();

            CreateAreaGameObject(groundData);
            CreateAreaGameObject(spaceData);
            CreateAreaGameObject(waterData);

            //BuildOperate decorate_operate = new BuildOperate() { area_id = area_id, state = GenerateState.Ground };
        }

        void Generate() {
            if (spaceData.type == SpaceType.City) {
                // 创建城市
                GenerateCity(spaceData);
                Debug.Log("围墙 房子 生成完毕 " + wall_datas + " - " + house_datas + "\tid=" + area_id);
                Debug.Log("围墙 房子 数量 " + wall_datas.Length + " - " + house_datas.Length + "\tid=" + area_id);
                BuildOperate wall_operate = new BuildOperate() { area_id = area_id, state = GenerateState.Wall};
                generate.EnqueueOperate(wall_operate); // 增加创建围墙的操作
                BuildOperate decorate_operate = new BuildOperate() { area_id = area_id, state = GenerateState.House};
                generate.EnqueueOperate(decorate_operate); // 增加创建房子的操作
            }

            GenerateOther();
            citys = null;
            Debug.Log("树 草 生成完毕 " + tree_datas + " - " + decorate_datas + "\tid=" + area_id);
            Debug.Log("树 草 数量 " + tree_datas.Length + " - " + decorate_datas.Length + "\tid=" + area_id);
            if (tree_datas.Length > 0) {
                BuildOperate tree_operate = new BuildOperate() { area_id = area_id, state = GenerateState.Tree };
                generate.EnqueueOperate(tree_operate); // 增加创建树的操作
            }
            BuildOperate house_operate = new BuildOperate() { area_id = area_id, state = GenerateState.Decorate };
            generate.EnqueueOperate(house_operate); // 增加创建植物的操作
        }

        void GenerateOther() {
            float min_x = groundData.min_x + 2;
            float max_x = groundData.max_x - 2;
            float min_z = groundData.min_z + 2;
            float max_z = groundData.max_z - 2;

            Debug.Log("min_x = " + min_x + "\tmax_x = " + max_x + "\tmin_z = " + min_z + "\tmax_z = " + max_z);

            List<SpaceData> tmp_trees = new List<SpaceData>();
            List<SpaceData> tmp_decorates = new List<SpaceData>();
            int min_map_pos = generate.map_edge - generate.ground_max;
            float max_map_pos = generate.map_size + generate.map_edge + generate.ground_max;

            for (float i = min_x; i <= max_x; i++) {
                for (float j = min_z; j <= max_z; j++) {
                    float x = i + MapTools.RandomRange(-0.38f, 0.38f);
                    float z = j + MapTools.RandomRange(-0.38f, 0.38f);
                    CreateType create = CreateType.Decorate;
                    Vector3 pos = new Vector3(x, ground_height, z);
                    if (spaceData.IsTherein(pos)) {
                        if (spaceData.type == SpaceType.City) {
                            continue;
                        } else if (spaceData.type == SpaceType.Forest) {
                            create = CreateType.Tree;
                        }
                    }

                    // todo需要处理异步判断问题
                    //bool onCity = false;
                    //for (int k = 0; k < citys.Length;) {
                    //    if (citys[k].IsTherein(pos)) {
                    //        onCity = true;
                    //        break;
                    //    }
                    //}
                    //if (onCity)
                    //    continue;

                    int ran_create_id = MapTools.RandomRange(0, 100);
                    if (create != CreateType.City) {
                        if (ran_create_id < generate.tree_density && create == CreateType.Tree) {
                            float max_dis = Mathf.Max(spaceData.scale.x, spaceData.scale.z) / 2.5f;
                            Vector3 center = spaceData.pos;
                            float center_dis = Vector3.Distance(pos, center);
                            bool can_create = center_dis < max_dis;
                            //// 城门周围50米不创建树
                            //if (can_create) {
                            //    foreach (var item in doors) {
                            //        if (Vector3.Distance(item.pos, pos) < space_size) {
                            //            can_create = false;
                            //            break;
                            //        }
                            //    }
                            //}
                            if (can_create) {
                                float tree_size = MapTools.RandomRange(0.75f, 1.25f);
                                if (center_dis < max_dis * 0.5f) {
                                    tree_size *= MapTools.RandomRange(1f, 1.25f);
                                } else if (center_dis < max_dis * 0.25f) {
                                    tree_size *= MapTools.RandomRange(1.25f, 1.5f);
                                } else if (center_dis < max_dis * 0.1f) {
                                    tree_size *= MapTools.RandomRange(1.5f, 2f);
                                }
                                int ran = MapTools.RandomRange(0, generate.treeObjs[0].objs.Length);
                                SpaceData tree = new SpaceData(pos, new Vector3(tree_size, tree_size, tree_size), SpaceType.Tree, angle: MapTools.RandomRange(0f, 360f), id: 0, idx: (short)ran);
                                foreach (var item in tmp_trees) {
                                    if (item.IsOverlap(tree, 1)) {
                                        can_create = false;
                                    }
                                }
                                if (can_create) {
                                    tmp_trees.Add(tree);
                                }
                            }
                        } else if (ran_create_id < generate.decorate_density) {
                            bool can_create = true;
                            if (create == CreateType.City) {
                                can_create = false;
                            }
                            if (can_create) {
                                int ran = MapTools.RandomRange(0, generate.decorateObjs[0].objs.Length);
                                float decorate_size = MapTools.RandomRange(0.2f, 0.5f);
                                SpaceData decorate = new SpaceData(pos, new Vector3(decorate_size, decorate_size, decorate_size), SpaceType.Decorate, angle: MapTools.RandomRange(0f, 360f), id: 0, idx: (short)ran);
                                tmp_decorates.Add(decorate);
                            }
                        }
                    }
                }
            }
            tree_datas = tmp_trees.ToArray();
            decorate_datas = tmp_decorates.ToArray();
        }

        void GenerateCity(SpaceData city) {
            List<SpaceData> walls = new List<SpaceData>();
            List<SpaceData> doors = new List<SpaceData>();
            List<SpaceData> ways = new List<SpaceData>();
            List<SpaceData> shops = new List<SpaceData>();
            List<SpaceData> houses = new List<SpaceData>();

            int half_wall_width = (int)(wall_width * 0.5f);

            Vector3 pos = city.pos;
            float width = city.scale.x;
            float length = city.scale.z;
            float min_x = city.min_x;
            float max_x = city.max_x;
            float min_y = city.min_z;
            float max_y = city.max_z;

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
            } else {
                city_center = new Vector3(min_x + (min_y - min_x) * 0.5f, 0, max_x + (max_y - max_x) * 0.5f);
            }

            // 东墙
            Vector3 east_wall_pos = new Vector3(max_x - half_wall_width, city_height, pos.z);
            float east_wall_width = wall_width;
            float east_wall_length = length;
            SpaceData east_wall = new SpaceData(east_wall_pos, new Vector3(east_wall_width, 3, east_wall_length), SpaceType.Wall, useMeshScale: true);
            // 西墙
            Vector3 west_wall_pos = new Vector3(min_x + half_wall_width, city_height, pos.z);
            float west_wall_width = wall_width;
            float west_wall_length = length;
            SpaceData west_wall = new SpaceData(west_wall_pos, new Vector3(west_wall_width, 3, west_wall_length), SpaceType.Wall, useMeshScale: true);
            //北墙
            Vector3 north_wall_pos = new Vector3(pos.x, city_height, max_y - half_wall_width);
            float north_wall_width = width;
            float north_wall_length = wall_width;
            SpaceData north_wall = new SpaceData(north_wall_pos, new Vector3(north_wall_width, 3, north_wall_length), SpaceType.Wall, useMeshScale: true);
            // 南墙1
            float south1_wall_width = (int)(max_x - city_center.x - door_width);
            float south1_wall_length = wall_width;
            Vector3 south1_wall_pos = new Vector3(max_x - south1_wall_width * 0.5f, city_height, min_y + half_wall_width);
            SpaceData south1_wall = new SpaceData(south1_wall_pos, new Vector3(south1_wall_width, 3, south1_wall_length), SpaceType.Wall, useMeshScale: true);
            // 南墙2
            float south2_wall_width = (int)(city_center.x - min_x - door_width);
            float south2_wall_length = wall_width;
            Vector3 south2_wall_pos = new Vector3(min_x + south2_wall_width * 0.5f, city_height, min_y + half_wall_width);
            SpaceData south2_wall = new SpaceData(south2_wall_pos, new Vector3(south2_wall_width, 3, south2_wall_length), SpaceType.Wall, useMeshScale: true);

            walls.Add(east_wall);
            walls.Add(west_wall);
            walls.Add(north_wall);
            walls.Add(south1_wall);
            walls.Add(south2_wall);

            // 围墙柱子
            walls.Add(new SpaceData(new Vector3(min_x + half_wall_width, city_height, min_y + half_wall_width), new Vector3(wallnode_size, 5, wallnode_size), SpaceType.WallNode, useMeshScale: true));
            walls.Add(new SpaceData(new Vector3(min_x + half_wall_width, city_height, max_y - half_wall_width), new Vector3(wallnode_size, 5, wallnode_size), SpaceType.WallNode, useMeshScale: true));
            walls.Add(new SpaceData(new Vector3(max_x - half_wall_width, city_height, min_y + half_wall_width), new Vector3(wallnode_size, 5, wallnode_size), SpaceType.WallNode, useMeshScale: true));
            walls.Add(new SpaceData(new Vector3(max_x - half_wall_width, city_height, max_y - half_wall_width), new Vector3(wallnode_size, 5, wallnode_size), SpaceType.WallNode, useMeshScale: true));
            walls.Add(new SpaceData(new Vector3(min_x + south2_wall_width - half_wall_width, city_height, min_y + half_wall_width), new Vector3(wallnode_size * 2, 5, wallnode_size * 2), SpaceType.WallNode, useMeshScale: true));
            walls.Add(new SpaceData(new Vector3(max_x - south1_wall_width + half_wall_width, city_height, min_y + half_wall_width), new Vector3(wallnode_size * 2, 5, wallnode_size * 2), SpaceType.WallNode, useMeshScale: true));

            var door = new SpaceData(new Vector3(city_center.x, city_height, min_y), new Vector3(door_width, 1, 1), SpaceType.Door);
            // 门
            doors.Add(door);

            //主干道
            int main_way_vertical_width = door_width;
            int main_way_vertical_length = (int)(max_y - min_y - space_edge);

            int main_way_horizontal_width = (int)(max_x - min_x - space_edge * 2);
            int main_way_horizontal_length = door_width;

            Vector3 main_vertical_way_pos = new Vector3(city_center.x, city_height, min_y + main_way_vertical_length * 0.5f);
            Vector3 main_horizontal_way_pos = new Vector3(min_x + main_way_horizontal_width * 0.5f + space_edge, city_height, city_center.z);

            SpaceData main_vertical_way = new SpaceData(main_vertical_way_pos, new Vector3(main_way_vertical_width, 0.08f, main_way_vertical_length), SpaceType.Way, useMeshScale: true);
            SpaceData main_horizontal_way = new SpaceData(main_horizontal_way_pos, new Vector3(main_way_horizontal_width, 0.08f, main_way_horizontal_length), SpaceType.Way, useMeshScale: true);
            ways.Add(main_vertical_way);
            ways.Add(main_horizontal_way);

            // 中心点向主干道两边创建商店
            int shop_idx = house_size;
            float house_offset = house_size * 0.5f + way_width;
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

                if (up_y > (main_vertical_way.max_z) && down_y < (main_vertical_way.min_z) && right_x > (main_horizontal_way.max_x) && left_x < (main_horizontal_way.min_x)) {
                    break;
                }
                //上面的
                if (up_y < (main_vertical_way.max_z) && Vector3.Distance(door.pos, new Vector3(main_way_right_x, 1, up_y)) > space_edge) {
                    shops.Add(GenerateHouse(new Vector3(main_way_right_x, city_height, up_y), Direction.West, SpaceType.Shop));
                    shops.Add(GenerateHouse(new Vector3(main_way_left_x, city_height, up_y), Direction.East, SpaceType.Shop));
                }
                //下面的
                if (down_y > (main_vertical_way.min_z) && Vector3.Distance(door.pos, new Vector3(main_way_right_x, 1, down_y)) > space_edge) {
                    shops.Add(GenerateHouse(new Vector3(main_way_right_x, city_height, down_y), Direction.West, SpaceType.Shop));
                    shops.Add(GenerateHouse(new Vector3(main_way_left_x, city_height, down_y), Direction.East, SpaceType.Shop));
                }


                right_x += house_size;
                left_x -= house_size;
                // 右边的
                if (right_x < (main_horizontal_way.max_x) && Vector3.Distance(door.pos, new Vector3(right_x, 1, main_way_up_y)) > space_edge) {
                    shops.Add(GenerateHouse(new Vector3(right_x, city_height, main_way_up_y), Direction.South, SpaceType.Shop));
                    shops.Add(GenerateHouse(new Vector3(right_x, city_height, main_way_down_y), Direction.North, SpaceType.Shop));
                }
                // 左边的
                if (left_x > (main_horizontal_way.min_x) && Vector3.Distance(door.pos, new Vector3(left_x, 1, main_way_up_y)) > space_edge) {
                    shops.Add(GenerateHouse(new Vector3(left_x, city_height, main_way_up_y), Direction.South, SpaceType.Shop));
                    shops.Add(GenerateHouse(new Vector3(left_x, city_height, main_way_down_y), Direction.North, SpaceType.Shop));
                }
                shop_idx += house_size;
            }

            // 创建民房
            float try_count = city.scale.x * city.scale.z / 50;
            for (int i = 0; i < try_count; i++) {

                int x = (int)MapTools.RandomRange(city.min_x + space_edge, city.max_x - space_edge);
                int y = (int)MapTools.RandomRange(city.min_z + space_edge, city.max_z - space_edge);
                bool can_build = true;
                SpaceData h = GenerateHouse(new Vector3(x, city_height, y), x < city_center.x ? Direction.East : Direction.West, SpaceType.House);
                foreach (SpaceData shop in shops) {
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

            // 数据归档
            List<SpaceData> wall_datas = new List<SpaceData>(walls.Count + ways.Count);
            wall_datas.AddRange(walls);
            wall_datas.AddRange(ways);
            List<SpaceData> house_datas = new List<SpaceData>(shops.Count + houses.Count);
            house_datas.AddRange(shops);
            house_datas.AddRange(houses);
            this.wall_datas = wall_datas.ToArray();
            this.house_datas = house_datas.ToArray();
        }

        /// <summary>
        /// 生成房子
        /// </summary>
        /// <param name="pos">位置</param>
        /// <param name="dir">方向</param>
        private SpaceData GenerateHouse(Vector3 pos, Direction dir, SpaceType typ) {
            StaticObjsData[] objs;
            switch (typ) {
                case SpaceType.House:
                    objs = generate.houseObjs;
                    break;
                case SpaceType.Shop:
                    objs = generate.shopObjs;
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
            return (new SpaceData(pos, new Vector3(size, size, size), typ, angle: angle, id: (short)id, idx: (short)idx));
        }
        public void BuildGameObject(BuildOperate operate) {
            switch (operate.state) {
                //case GenerateState.Ground:
                //    CreateAreaGameObject(groundData);
                //    CreateAreaGameObject(spaceData);
                //    break;
                case GenerateState.Wall:
                    coroutines.Add(operate.state, generate.StartCoroutine(BuildWorld(operate.state, wall_datas)));
                    break;
                case GenerateState.House:
                    coroutines.Add(operate.state, generate.StartCoroutine(BuildWorld(operate.state, house_datas)));
                    break;
                case GenerateState.Tree:
                    coroutines.Add(operate.state, generate.StartCoroutine(BuildWorld(operate.state, tree_datas)));
                    break;
                case GenerateState.Decorate:
                    coroutines.Add(operate.state, generate.StartCoroutine(BuildWorld(operate.state, decorate_datas)));
                    break;
            }
        }

        private IEnumerator BuildWorld(GenerateState state, SpaceData[] data) {
            Debug.Log(state + "创建 " + data + "\tid=" + area_id);
            if (data == null) {
                yield break;
            }
            Debug.Log(state + "数量 " + data.Length + "\tid=" + area_id);
            if (data.Length < 1) {
                yield break;
            }
            int max = data.Length;
            int progress = 0;
            for (int i = 0; i < max; i++) {
                int p = i * 100 / max;
                if (progress != p) {
                    yield return 0;
                }
                CreateAreaGameObject(data[i], i);
            }
            if (coroutines.ContainsKey(state)) {
                var coroutine = coroutines[state];
                coroutines.Remove(state);
                generate.StopCoroutine(coroutine);
            }
        }

        private void CreateAreaGameObject(SpaceData space_data, int id = 0) {
            StaticObj static_obj = null;
            switch (space_data.type) {
                case SpaceType.AreaTrriger:
                    static_obj = generate.triggerObj.obj;
                    break;
                case SpaceType.Forest:
                    //static_obj = generate.wayObj.obj;
                    break;
                case SpaceType.Ground:
                    static_obj = generate.groundObj.obj;
                    break;
                case SpaceType.City:
                    static_obj = generate.city_groundObj.obj;
                    break;
                case SpaceType.House:
                    static_obj = generate.houseObjs[space_data.id].objs[space_data.idx];
                    break;
                case SpaceType.Shop:
                    static_obj = generate.shopObjs[space_data.id].objs[space_data.idx];
                    break;
                case SpaceType.Way:
                    static_obj = generate.wayObj.obj;
                    break;
                case SpaceType.Wall:
                    static_obj = generate.wallObj.obj;
                    break;
                case SpaceType.WallNode:
                    static_obj = generate.wallNodeObj.obj;
                    break;
                case SpaceType.Tree:
                    static_obj = generate.treeObjs[space_data.id].objs[space_data.idx];
                    break;
                case SpaceType.Decorate:
                    static_obj = generate.decorateObjs[space_data.id].objs[space_data.idx];
                    break;
                case SpaceType.Sea:
                    static_obj = generate.seaObj.obj;
                    break;
                case SpaceType.Water:
                    static_obj = generate.waterObj.obj;
                    break;
                default:
                    break;
            }
            if (static_obj != null) {
                GameObject obj = GameObject.Instantiate(static_obj.prefab, new Vector3(space_data.pos.x, space_data.pos.y, space_data.pos.z), Quaternion.Euler(0, space_data.angle, 0));
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
                obj.name = space_data.type + " " + area_id;
                all_objs.Add(obj);
            }
        }

        public void Close() {
            if (thread != null) {
                thread.Abort();
            }
            foreach (KeyValuePair<GenerateState, Coroutine> item in coroutines) {
                if (item.Value != null) {
                    generate.StopCoroutine(item.Value);
                }
            }
            foreach (var item in all_objs) {
                GameObject.Destroy(item);
            }
        }

    }
}