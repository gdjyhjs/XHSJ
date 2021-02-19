using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine;

public static class Tools {
    public static bool FileExists(string path) {
        return File.Exists(AssetCachesDir + path);
    }
    public static string ReadAllText(string path) {
        return File.ReadAllText(AssetCachesDir + path);
    }
    public static void WriteAllText(string path, string str) {
        AutoDir(path);
        File.WriteAllText(AssetCachesDir + path, str);
    }
    public static byte[] ReadAllBytes(string path) {
        return File.ReadAllBytes(AssetCachesDir + path);
    }
    public static void WriteAllBytes(string path, byte[] byt) {
        AutoDir(path);
        File.WriteAllBytes(AssetCachesDir + path, byt);
    }
    public static void AutoDir(string path) {
        string dir = Path.GetDirectoryName(AssetCachesDir + path);
        if (!System.IO.Directory.Exists(dir)) {
            Directory.CreateDirectory(dir);
        }
    }



    public static string AssetCachesDir
    {
        get
        {
            string dir = "";
#if UNITY_EDITOR
            // dir = Application.dataPath + "Caches/";//路径：/AssetsCaches/
            //dir = Application.streamingAssetsPath + "/";//路径：/xxx_Data/StreamingAssets/
            dir = Application.persistentDataPath + "/";//路径：/xxx_Data/StreamingAssets/
#elif UNITY_IOS
            dir = Application.temporaryCachePath + "/";//路径：Application/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/Library/Caches/
#elif UNITY_ANDROID
            dir = Application.persistentDataPath + "/";//路径：/data/data/xxx.xxx.xxx/files/
#else
            dir = Application.persistentDataPath + "/";//路径：/xxx_Data/StreamingAssets/
#endif
            return dir;
        }
    }



    //将Object类型对象(注：必须是可序列化的对象)转换为二进制序列字符串
    public static byte[] SerializeObject(object obj) {
        byte[] byt;
        using (MemoryStream ms = new MemoryStream()) {
            IFormatter formatter = new BinaryFormatter();
            formatter.Serialize(ms, obj);
            byt = ms.GetBuffer();
        }
        return byt;
    }
    //将二进制序列字符串转换为Object类型对象
    public static object DeserializeObject(byte[] byt) {
        object obj;
        using (MemoryStream ms = new MemoryStream(byt)) {
            // //以二进制格式将对象或整个连接对象图形序列化和反序列化。
            IFormatter formatter = new BinaryFormatter();
            //把字符串以二进制放进memStream中
            obj = formatter.Deserialize(ms);
        }
        return obj;
    }
    public static T DeserializeObject<T>(byte[] byt) {
        object obj;
        using (MemoryStream ms = new MemoryStream(byt)) {
            // //以二进制格式将对象或整个连接对象图形序列化和反序列化。
            IFormatter formatter = new BinaryFormatter();
            //把字符串以二进制放进memStream中
            obj = formatter.Deserialize(ms);
        }
        return (T)obj;
    }

    public static string[] CheckSame(string[] list) {
        bool modify = false;
        HashSet<string> data = new HashSet<string>();
        foreach (var item in list) {
            if (data.Contains(item)) {
                Debug.LogError("重复 "+ item);
                modify = true;
                continue;
            }
            data.Add(item);
        }
        if (modify) {
            list = new  List<string>(data).ToArray();
        }
        return list;
    }


    /// <summary>
    /// 是否有存档
    /// </summary>
    public static bool HasSave(int id) {
        string dir = "SaveData_" + id;

        return File.Exists(AssetCachesDir + dir + "/" + "game.data");
    }

    /// <summary>
    /// 存档路径
    /// </summary>
    public static string SavePath(string path) {
        string dir = "SaveData_" + GameData.instance.save_id;
        if (!Directory.Exists(AssetCachesDir + dir)){
            Directory.CreateDirectory(AssetCachesDir + dir);
        }
        return dir + "/" + path;
    }

    /// <summary>
    /// 删除存档
    /// </summary>
    public static void DeleteSave(int id) {
        string dir = "SaveData_" + id;
        Directory.Delete(AssetCachesDir + dir, true);
    }


    public static string ShowTime(System.DateTime dateTime) {
        return dateTime.ToLongDateString();
    }






















    public static Vector3[] CalLength(Vector3 p0, Vector3 p1) {
        List<Vector3> touched = new List<Vector3>();

        float x0 = p0.x;
        float y0 = p0.z;
        float x1 = p1.x;
        float y1 = p1.z;

        bool steep = Math.Abs(y1 - y0) > Math.Abs(x1 - x0);
        if (steep) {
            x0 = p0.z;
            y0 = p0.x;
            x1 = p1.z;
            y1 = p1.x;
        }

        if (x0 > x1) {
            float x0_old = x0;
            float y0_old = y0;
            x0 = x1;
            x1 = x0_old;
            y0 = y1;
            y1 = y0_old;
        }

        float ratio = Math.Abs((y1 - y0) / (x1 - x0));
        int mirro = y1 > y0 ? 1 : -1;

        for (int col = (int)Math.Floor(x0); col < Math.Ceiling(x1); col++) {
            float currY = y0 + mirro * ratio * (col - x0);

            //第一个不进行延边计算
            bool skip = false;
            if (col == Math.Floor(x0)) {
                skip = (int)currY != (int)y0;
            }

            if (!skip) {
                if (!steep) {
                    touched.Add(new Vector3(col, 0, (int)Math.Floor(currY)));
                } else {
                    touched.Add(new Vector3((int)Math.Floor(currY), 0, col));
                }
            }

            // 根据斜率计算是否有跨格
            if ((mirro > 0 ? (Math.Ceiling(currY) - currY) : (currY - Math.Floor(currY))) < ratio) {
                int crossY = (int)(Math.Floor(currY) + mirro);

                //// 判断是否超出范围
                //if (crossY > Math.Max((int)y0, (int)y1) || crossY >= 0) {
                //}

                // 跨线格子
                if (!steep) {
                    touched.Add(new Vector3(col, 0, crossY));
                } else {
                    touched.Add(new Vector3(crossY, 0, col));
                }
            }
        }
        return touched.ToArray();
    }

    public static void SetCameraPos(Transform  cam, Vector3 pos) {
        cam.position = new Vector3(pos.x, 500, pos.z);
    }

    public static Vector2Int WorldPointToUnitPos(Vector3 pos) {
        int x = (int)Math.Floor(pos.x / WorldCreate.instance.scale);
        int z = (int)Math.Floor(pos.z / WorldCreate.instance.scale);
        return new Vector2Int(x, z);
    }

    public static Vector3 UnitPosToWorldPoint(Vector2Int pos) {
        float x = pos.x * WorldCreate.instance.scale + WorldCreate.instance.scale * 0.5f;
        float z = pos.y * WorldCreate.instance.scale + WorldCreate.instance.scale * 0.5f;
        return new Vector3(x, 0, z);
    }

    public static void SetActive(GameObject obj, bool active) {
        if (!obj)
            return;
        if (obj.activeSelf != active)
            obj.SetActive(active);
    }
}
