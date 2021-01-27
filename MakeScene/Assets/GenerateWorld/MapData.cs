using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Threading;
using UnityEngine;

namespace GenerateWorld {
    /// <summary>
    /// 地图数据
    /// </summary>
    public class MapData {
        GenerateMap generate; // 生成地图数据
        public string data_dir;
        SpaceData[] city_data; // 所有城市占地
        SpaceData[] forest_data; // 所有森林占地
        SpaceData[] ground_data; // 所有区域占地
        SpaceData[] trigger_data; // 所有区域占地



        List<Thread> threads = new List<Thread>();
        List<FileTools> fileTools = new List<FileTools>();
        public float progress;

        public MapData(GenerateMap generate, int seed, int size) {
            data_dir = string.Format("map_{0}_{1}", seed, size);
            if (!Directory.Exists(data_dir)) {
                Directory.CreateDirectory(data_dir);
            }
            this.generate = generate;
        }


        public bool GetCityData(out SpaceData[] result) {
            return GetData(ref city_data, "city_data", out result);
        }
        public void SetCityData(SpaceData[] data) {
            city_data = data;
            SetData(data, "city_data");
        }

        public bool GetForestData(out SpaceData[] result) {
            return GetData(ref forest_data, "forest_data", out result);
        }
        public void SetForestData(SpaceData[] data) {
            forest_data = data;
            SetData(data, "forest_data");
        }

        public bool GetGroundData(out SpaceData[] result, out SpaceData[] triggers) {
            bool a = GetData(ref ground_data, "ground_data", out result);
            bool b = GetData(ref trigger_data, "trigger_data", out triggers);
            return a && b;
        }
        public void SetGroundData(SpaceData[] data, SpaceData[] triggers) {
            ground_data = data;
            SetData(data, "ground_data");
            SetData(triggers, "trigger_data");
        }

        Dictionary<int, SpaceData[]> wall_datas = new Dictionary<int, SpaceData[]>();
        Dictionary<int, SpaceData[]> house_datas = new Dictionary<int, SpaceData[]>();
        public bool GetHouseData(out SpaceData[] wall_data, out SpaceData[] house_data, int area_id) {
            if (wall_datas.ContainsKey(area_id) && house_datas.ContainsKey(area_id)) {
                wall_data = wall_datas[area_id];
                house_data = house_datas[area_id];
                return true;
            } else {
                SpaceData[] wall = null;
                SpaceData[] house = null;
                bool a = GetData(ref wall, "wall_data_" + area_id, out wall_data);
                bool b = GetData(ref house, "house_data_" + area_id, out house_data);
                if (a && b) {
                    SetHouseData(wall, house, area_id);
                    return true;
                } else {
                    return false;
                }
            }
        }
        public void SetHouseData(SpaceData[] wall_data, SpaceData[] house_data, int area_id) {
            if (wall_datas.ContainsKey(area_id)) {
                wall_datas[area_id] = wall_data;
            } else {
                wall_datas.Add(area_id, wall_data);
            }
            if (house_datas.ContainsKey(area_id)) {
                house_datas[area_id] = house_data;
            } else {
                house_datas.Add(area_id, house_data);
            }
            SetData(wall_data, "wall_data_" + area_id);
            SetData(house_data, "house_data_" + area_id);
        }

        Dictionary<int, SpaceData[]> tree_datas = new Dictionary<int, SpaceData[]>();
        Dictionary<int, SpaceData[]> decorate_datas = new Dictionary<int, SpaceData[]>();
        public bool GetDecorateData(out SpaceData[] tree_data, out SpaceData[] decorate_data, int area_id) {
            if (tree_datas.ContainsKey(area_id) && decorate_datas.ContainsKey(area_id)) {
                tree_data = tree_datas[area_id];
                decorate_data = decorate_datas[area_id];
                return true;
            } else {
                SpaceData[] tree = null;
                SpaceData[] decorate = null;
                bool a = GetData(ref tree, "tree_data_" + area_id, out tree_data);
                bool b = GetData(ref decorate, "decorate_data_" + area_id, out decorate_data);
                if (a && b) {
                    SetDecorateData(tree, decorate, area_id);
                    return true;
                } else {
                    return false;
                }
            }
        }
        public void SetDecorateData(SpaceData[] tree_data, SpaceData[] decorate_data, int area_id) {
            if (tree_datas.ContainsKey(area_id)) {
                tree_datas[area_id] = tree_data;
            } else {
                tree_datas.Add(area_id, tree_data);
            }
            if (decorate_datas.ContainsKey(area_id)) {
                decorate_datas[area_id] = decorate_data;
            } else {
                decorate_datas.Add(area_id, decorate_data);
            }
            SetData(tree_data, "tree_data_" + area_id);
            SetData(decorate_data, "decorate_data_" + area_id);
        }




        private bool GetData(ref SpaceData[] data, string file_name, out SpaceData[] result) {
            try {
                if (data != null) {
                    result = data;
                    return true;
                } else {
                    // 读取文件
                    string path = Path.Combine(data_dir, file_name);
                    if (File.Exists(path)) {
                        FileTools file_tool = new FileReadTools(path);
                        lock (fileTools) {
                            fileTools.Add(file_tool);
                        }
                        byte[] bytes = null;
                        try {
                            while (true) {
                                Thread.Sleep(10);
                                if (file_tool == null) {
                                    result = null;
                                    return false;
                                }
                                lock (file_tool) {
                                    progress = file_tool.progress;
                                    if (file_tool.isdone) {
                                        bytes = file_tool.result;
                                        lock (fileTools) {
                                            if (fileTools.Contains(file_tool)) {
                                                fileTools.Remove(file_tool);
                                            }
                                        }
                                        break;
                                    }
                                }
                            }
                            using (MemoryStream ms = new MemoryStream(bytes)) {
                                // //以二进制格式将对象或整个连接对象图形序列化和反序列化。
                                IFormatter formatter = new BinaryFormatter();
                                //把字符串以二进制放进memStream中
                                data = (SpaceData[])formatter.Deserialize(ms);
                            }
                            result = data;
                            return true;
                        } catch (System.Exception e) {
                            lock (fileTools) {
                                if (fileTools.Contains(file_tool)) {
                                    fileTools.Remove(file_tool);
                                }
                            }
                            Debug.LogError(e.Message + "\n" + e.StackTrace);
                        }
                    }
                }
            } catch (System.Exception e) {
                Debug.LogError(e.Message + "\n" + e.StackTrace);
            }
            result = null;
            return false;
        }

        private void SetData(SpaceData[] data, string file_name) {
            Thread thread = new Thread(()=> {
                try {
                    byte[] bytes;
                    using (MemoryStream ms = new MemoryStream()) {
                        IFormatter formatter = new BinaryFormatter();
                        formatter.Serialize(ms, data);
                        bytes = ms.GetBuffer();
                    }
                    string path = Path.Combine(data_dir, file_name);
                    if (File.Exists(path)) {
                        File.Delete(path);
                    }
                    // 写入文件
                    FileTools file_tool = new FileWriteTools(path, bytes);
                    lock (fileTools) {
                        fileTools.Add(file_tool);
                    }
                    while (true) {
                        Thread.Sleep(10);
                        if (file_tool == null) {
                            return;
                        }
                        lock (file_tool) {
                            if (file_tool.isdone) {
                                lock (fileTools) {
                                    if (fileTools.Contains(file_tool)) {
                                        fileTools.Remove(file_tool);
                                    }
                                }
                                return;
                            }
                        }
                    }
                } catch (System.Exception) {
                    throw;
                }
            });
            thread.Start();
            lock (threads) {
                threads.Add(thread);
            }
        }

        ~MapData() {
            foreach (var item in threads) {
                item.Abort();
            }
            threads = null;
            foreach (var item in fileTools) {
                item.Close();
            }
            fileTools = null;
        }
    }
}