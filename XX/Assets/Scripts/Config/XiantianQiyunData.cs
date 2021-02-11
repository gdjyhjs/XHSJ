using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 先天气运数据
/// </summary>
public static class XiantianQiyunData {
    public static XiantianQiyun[] dataList;
    static XiantianQiyunData() {
        var data = Tools.ReadAllText("Config/xiantianqiyun.txt").Split('\n');
        int color = 0;
        List<XiantianQiyun> all = new List<XiantianQiyun>();
        int id = 0;
        foreach (var item in data) {
            if (string.IsNullOrWhiteSpace(item)) {
                continue;
            }
            var line = item.Trim();
            var tmp = line.Split(':');


            switch (tmp[0]) {
                case "color":
                    color = int.Parse(tmp[1]);
                    break;
                default:
                    string[] attr = tmp[2].Split(',');
                    int count = attr.Length;
                    int[] attr_id = new int[count];
                    int[] attr_value = new int[count];
                    for (int i = 0; i < count; i++) {
                        var atr = attr[i].Split('*');
                        // 配置的id是从1开始的，这里要-1才和枚举匹配
                        attr_id[i] = int.Parse(atr[0]) - 1;
                        attr_value[i] = int.Parse(atr[1]);
                    }

                    all.Add(new XiantianQiyun() { name = tmp[0], des = tmp[1], color = color, id = id, attr_id = attr_id,
                        attr_value = attr_value });

                    id++;
                    break;
            }
        }
        dataList = all.ToArray();
    }

    public static void AddXiantianQiyun(int id, int[] attribute, int[] max_attribute) {
        XiantianQiyun data = XiantianQiyunData.dataList[id];
        int count = data.attr_id.Length;
        for (int i = 0; i < count; i++) {
            int attr_id = data.attr_id[i];
            int attr_value = data.attr_value[i];
            max_attribute[attr_id] += attr_value;
            if (attr_id != (int)Attribute.life) {
                attribute[attr_id] += attr_value;
            }
        }
    }
    public static void RemoveXiantianQiyun(int id, int[] attribute, int[] max_attribute) {
        XiantianQiyun data = XiantianQiyunData.dataList[id];
        int count = data.attr_id.Length;
        for (int i = 0; i < count; i++) {
            int attr_id = data.attr_id[i];
            int attr_value = data.attr_value[i];
            max_attribute[attr_id] -= attr_value;
            if (attr_id != (int)Attribute.life) {
                attribute[attr_id] -= attr_value;
            }
        }
    }
}

/// <summary>
/// 先天气运结构
/// </summary>
public struct XiantianQiyun {
    public string name;
    public string des;
    public int color;
    public int id;
    public int[] attr_id;
    public int[] attr_value;
}