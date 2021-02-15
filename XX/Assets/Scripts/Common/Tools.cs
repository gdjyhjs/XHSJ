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
        string dir = "SaveData_" + GameData.save_id;
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



    //    function segs = calLength(P1, P2)

    //segs.length = [];
    //segs.index_x = [];
    //segs.index_y = [];
    //segs.index = [];

    //P1_x = P1(1);
    //    P1_y = P1(2);
    //    P2_x = P2(1);
    //    P2_y = P2(2);

    //    xmin = min(P1_x, P2_x);
    //    ymin = min(P1_y, P2_y);
    //    xmax = max(P1_x, P2_x);
    //    ymax = max(P1_y, P2_y);

    //if (P1_x == P2_x) && (round(P1_x) == P1_x)...
    //        || (P1_y == P2_y) && (round(P1_y) == P1_y)
    //    return;
    //end

    //pos = reshape(1:100, 10, 10);

    //if (P1_x == P2_x) && (round(P1_x) ~= P1_x)
    //    SP = unique([ymin, ymax, ceil(ymin):floor(ymax)]);
    //    for t = 1 : size(SP,2)-1
    //        segs(t).length = SP(t+1)-SP(t);
    //    segs(t).index_x = ceil(P1_x);
    //    segs(t).index_y = max(ceil(SP(t+1)),ceil(SP(t)));
    //        segs(t).index = pos(segs(t).index_x, segs(t).index_y);
    //    end
    //end

    //if (P1_x ~= P2_x)
    //    K = polyfit([P1_x, P2_x], [P1_y, P2_y],1);
    //    xpx = []; xpy = [];
    //    for i = ceil(xmin) :floor(xmax)
    //        xpx(i-ceil(xmin)+1) = i;
    //        xpy(i-ceil(xmin)+1) = K(1)*i+K(2);
    //    end

    //    ypx = []; ypy = [];
    //    for j = ceil(ymin) :floor(ymax)
    //        ypy(j-ceil(ymin)+1) = j;
    //        syms x;
    //    ypx(j-ceil(ymin)+1) = double (solve(K(1)*x + K(2) - j, x));
    //    end

    //    SP = unique([P1_x, P2_x, xpx, ypx; P1_y,P2_y,xpy,ypy]','rows');

    //    L = @(x) sqrt((SP(x+1,1) - SP(x,1)).^2 + (SP(x+1,2) - SP(x,2)).^2);

    //    for t = 1 : size(SP,1)-1
    //        segs(t).length = L(t);
    //    segs(t).index_x = max(ceil(SP(t+1,1)),ceil(SP(t,1)));
    //        segs(t).index_y = max(ceil(SP(t+1,2)),ceil(SP(t,2)));
    //        segs(t).index = pos(segs(t).index_x, segs(t).index_y);
    //    end
    //end

    //n = [];
    //for i = 1 : size(segs,2)
    //    if segs(i).length<eps
    //        n = [n i];
    //    end
    //end
    //segs(n) = [];
    //1
    //2
    //3
    //4
    //5
    //6
    //7
    //8
    //9
    //10
    //11
    //12
    //13
    //14
    //15
    //16
    //17
    //18
    //19
    //20
    //21
    //22
    //23
    //24
    //25
    //26
    //27
    //28
    //29
    //30
    //31
    //32
    //33
    //34
    //35
    //36
    //37
    //38
    //39
    //40
    //41
    //42
    //43
    //44
    //45
    //46
    //47
    //48
    //49
    //50
    //51
    //52
    //53
    //54
    //55
    //56
    //57
    //58
    //59
    //60
    //61
    //62
    //63
    //64
    //65
    //66
    //67
    //68
    //clear;clc;clf;
    //x = linspace(0,10,11);
    //    y = linspace(0,10,11);
    //    [X, Y] = meshgrid(x, y);
    //    line(X, Y,'color','b');
    //    line(X',Y','color','b');
    //    axis equal;
    //    axis([0 10 0 10]);
    //    set(gca,'xtick',0:10);

    //    gridindex = reshape(1:100,10,10)';
    //numposx = 0.5*(X(1:end-1,2:end)+X(1:end-1,1:end-1))-0.1;
    //numposy = 0.5*(Y(2:end,1:end-1)+Y(1:end-1,1:end-1));
    //for i = 1 : 10
    //    for j = 1 : 10
    //        text(numposx(i, j), numposy(i, j), num2str(gridindex(i, j)));
    //    end
    //end

    //P1 = input('P1=');
    //    P2 = input('P2=');
    //    segs = calLength(P1, P2);
    //    line([P1(1) P2(1)], [P1(2) P2(2)],'color','r');

    //    display('所经过的网格序号\长度分别为:');
    //for i = 1 : size(segs,2)
    //    display(['序号: ' num2str(segs(i).index)]);
    //    display(['长度: ' num2str(segs(i).length)]);
    //    end

}
