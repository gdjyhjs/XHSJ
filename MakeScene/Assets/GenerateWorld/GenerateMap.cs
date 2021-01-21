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

        public List<SpaceData> all_pos;

        private List<GameObject> all_obj;

        private void Awake() {
            seaObj.Init();
            groundObj.Init();
            city_groundObj.Init();
            forestObj.Init();
        }

        public void GenerateWorld() {
            DateTime start_time = DateTime.Now;
            if (seed < 0) {
                seed = (int)start_time.Second;
            }
            Random.InitState(seed);
            all_pos = new List<SpaceData>();
            all_pos.AddRange(CreateSpacePos(city_count, city_size, city_random, city_dis, SpaceType.City));
            all_pos.AddRange(CreateSpacePos(field_count, field_size, field_random, field_dis, SpaceType.Forest));

            BuildCity();
            CreateWorldGameObject();



            DateTime end_time = DateTime.Now;
            Debug.Log("创造世界总花费时间：" + (end_time - start_time).TotalMilliseconds);
        }



        List<SpaceData> wall = new List<SpaceData>();
        List<SpaceData> ways = new List<SpaceData>();
        List<SpaceData> house = new List<SpaceData>();
        List<SpaceData> shops = new List<SpaceData>();
        private void BuildCity() {
            // 每个区域大概50*50  边界留10米  道路3米宽 围墙宽3米 城门宽5米
            int space_size = 50;
            int space_edge = 10;
            int way_width = 4;
            int wall_width = 4;
            int door_width = 4;

            DateTime start_time = DateTime.Now;

            foreach (SpaceData item in all_pos) {
                
                if (item.type == SpaceType.City) {

                    Vector2 pos = item.pos;
                    int width = item.width;
                    int length = item.length;
                    Rect rect = item.rect;
                    // 城门统一坐北朝南
                    // 随机道路  
                    // 先随机一个点，然后随机一个方向建立道路，再向两边建立道路
                    float way_node_min_x = rect.x + space_size + space_edge;
                    float way_node_min_y = rect.width + space_size + space_edge;
                    float way_node_max_x = rect.y - space_size - space_edge;
                    float way_node_max_y = rect.height - space_size - space_edge;
                    // 创建城市中心点
                    Vector2 city_center;
                    if (width > ((space_size + space_edge) * 0.5f) && length > ((space_size + space_edge) * 0.5f)) {
                        city_center = new Vector2(Random.Range(way_node_min_x, way_node_max_x), Random.Range(way_node_min_y, way_node_max_y));
                    } else {
                        city_center = new Vector2(rect.x + (rect.y - rect.x) * 0.5f, rect.width + (rect.height - rect.width) * 0.5f);
                    }
                    // 东墙
                    Vector2 east_wall_pos = new Vector2(rect.y - 1.5f, pos.y);
                    int east_wall_width = wall_width;
                    int east_wall_length = length;
                    SpaceData east_wall = new SpaceData(east_wall_pos, east_wall_width, east_wall_length, SpaceType.Wall);
                    // 西墙
                    Vector2 west_wall_pos = new Vector2(rect.x + 1.5f, pos.y);
                    int west_wall_width = wall_width;
                    int west_wall_length = length;
                    SpaceData west_wall = new SpaceData(west_wall_pos, west_wall_width, west_wall_length, SpaceType.Wall);
                    //北墙
                    Vector2 north_wall_pos = new Vector2(pos.x, rect.height - 1.5f);
                    int north_wall_width = width;
                    int north_wall_length = wall_width;
                    SpaceData north_wall = new SpaceData(north_wall_pos, north_wall_width, north_wall_length, SpaceType.Wall);
                    // 南墙1
                    int south1_wall_width = (int)(pos.y - city_center.x - door_width * 0.5f);
                    int south1_wall_length = wall_width;
                    Vector2 south1_wall_pos = new Vector2(pos.y - south1_wall_width * 0.5f, rect.height - 1.5f);
                    SpaceData south1_wall = new SpaceData(south1_wall_pos, south1_wall_width, south1_wall_length, SpaceType.Wall);
                    // 南墙2
                    int south2_wall_width = (int)(city_center.x - pos.x - door_width * 0.5f);
                    int south2_wall_length = wall_width;
                    Vector2 south2_wall_pos = new Vector2(rect.x + south2_wall_width * 0.5f, rect.height - 1.5f);
                    SpaceData south2_wall = new SpaceData(south2_wall_pos, south2_wall_width, south2_wall_length, SpaceType.Wall);

                    wall.Add(east_wall);
                    wall.Add(west_wall);
                    wall.Add(north_wall);
                    wall.Add(south1_wall);
                    wall.Add(south2_wall);

                    // 从道路最里头往外创建交叉道路
                }
            }


            DateTime end_time = DateTime.Now;
            Debug.Log("生成城市花费时间：" + (end_time - start_time).TotalMilliseconds);
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

            foreach (SpaceData item in all_pos) {
                GameObject obj;
                int width = item.width;
                int height = item.length;
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

            foreach (SpaceData item in wall) {
                GameObject obj = Instantiate(wallObj.obj.prefab);
                Transform obj_tf = obj.transform;
                obj_tf.localScale = new Vector3(item.width * wallObj.obj.scale.x, wallObj.obj.scale.y, item.length * wallObj.obj.scale.z);
                obj_tf.position = new Vector3(item.pos.x, 2, item.pos.y);
                all_obj.Add(obj);
            }

            int min_map_pos = map_edge - ground_size;
            int max_map_pos = map_size + map_edge + ground_size;
            for (int x1 = min_map_pos; x1 < max_map_pos; x1++) {
                for (int y1 = min_map_pos; y1 < max_map_pos; y1++) {
                    float x = x1 + Random.Range(-0.38f, 0.38f);
                    float y = y1 + Random.Range(-0.38f, 0.38f);
                    CreateType create = CreateType.Node;
                    foreach (SpaceData item in all_pos) {
                        if (item.IsTherein(new Vector2(x, y))) {
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
                        foreach (SpaceData item in all_pos) {
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
                                int ran = Random.Range(0, treeObjs[0].objs.Length);
                                GameObject prefab = treeObjs[0].objs[ran].prefab;
                                Vector3 size = treeObjs[0].objs[ran].scale;
                                GameObject obj = Instantiate(prefab);
                                Transform obj_tf = obj.transform;
                                float tree_size = Random.Range(0.5f, 1.5f);
                                obj_tf.localScale = new Vector3(tree_size, tree_size + Random.Range(-0.2f, 0.2f), tree_size);
                                obj_tf.position = new Vector3(x, 1, y);
                                obj_tf.eulerAngles = new Vector3(0, Random.Range(0, 360), 0);
                                all_obj.Add(obj);
                            }
                        } else if (ran_create_id < 15) {
                            int ran = Random.Range(0, decorateObjs[0].objs.Length);
                            GameObject prefab = decorateObjs[0].objs[ran].prefab;
                            Vector3 size = decorateObjs[0].objs[ran].scale;
                            GameObject obj = Instantiate(prefab);
                            Transform obj_tf = obj.transform;
                            float tree_size = Random.Range(0.05f, 0.2f);
                            obj_tf.localScale = new Vector3(tree_size, tree_size + Random.Range(-0.02f, 0.02f), tree_size);
                            obj_tf.position = new Vector3(x, 1, y);
                            obj_tf.eulerAngles = new Vector3(0, Random.Range(0, 360), 0);
                            all_obj.Add(obj);
                        } else {

                        }
                    }
                }
            }
            DateTime end_time = DateTime.Now;
            Debug.Log("创造地表花费时间：" + (end_time - start_time).TotalMilliseconds);
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
            GUI.Label(new Rect(10, 40, 100, 30), "count:"+ all_pos.Count);
        }
#endif
    }
}