using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

/// <summary>
/// 角色属性配置数据
/// </summary>
public static class GongfaAttrConfig {
    public static Dictionary<int, GongfaAttrData> dataList;
    public static Dictionary<GongfaType, GongfaAttrData[]> typeList;
    static GongfaAttrConfig() {
        Dictionary<GongfaType, List<GongfaAttrData>> all = new Dictionary<GongfaType, List<GongfaAttrData>>();
        dataList = new Dictionary<int, GongfaAttrData>();
        string[] data = Tools.ReadAllText("Config/gongfaAttrConfig.txt").Split('\n');
        foreach (string line in data) {
            if (string.IsNullOrWhiteSpace(line)) {
                break;
            }
            if (line.StartsWith("#")) {
                continue;
            }
            string[] configs = line.Split(',');
            int id = int.Parse(configs[0]);
            string[] types = configs[01].Split('|'); // 哪些功法可以有这个词条
            GongfaType type = GongfaType.none;
            foreach (string typ_str in types) {
                type |= (GongfaType)Enum.Parse(typeof(GongfaType), typ_str);
            }

            string[] strs = configs[2].Split('|');
            string name = strs[2];
            string des = strs[1];

            RoleAttribute attr = (RoleAttribute)Enum.Parse(typeof(RoleAttribute), configs[3]);

            List<int[]> all_min_attr = new List<int[]>();
            List<int[]> all_max_attr = new List<int[]>();
            string[] allattr = configs[4].Split(';');
            for (int x = 0; x < allattr.Length; x++) {
                List<int> min_attr = new List<int>();
                List<int> max_attr = new List<int>();
                string[] attrs = allattr[x].Split('|');
                for (int i = 0; i < attrs.Length; i++) {
                    string[] minmax = attrs[i].Split('-');
                    min_attr.Add(int.Parse(minmax[0]));
                    max_attr.Add(int.Parse(minmax[1]));
                }
                all_min_attr.Add(min_attr.ToArray());
                all_max_attr.Add(max_attr.ToArray());
            }

            if (!all.ContainsKey(type)) {
                all.Add(type, new List<GongfaAttrData>());
            }
            var attr_data = new GongfaAttrData() {
                id = id, type = type, name = name, des = des, attr = attr,
                min_attr = all_min_attr.ToArray(), max_attr = all_max_attr.ToArray()
            };
            all[type].Add(attr_data);
            dataList.Add(id, attr_data);
        }

        typeList = new Dictionary<GongfaType, GongfaAttrData[]>();
        foreach (KeyValuePair<GongfaType, List<GongfaAttrData>> item in all) {
            typeList.Add(item.Key, item.Value.ToArray());
        }
    }

    /// <summary>
    /// 获取随机词条
    /// </summary>
    public static GongfaAttrData GetRandomExAttr(GongfaType gongfa_typ) {
        GongfaAttrData[] list = GongfaAttrConfig.typeList[gongfa_typ];
        GongfaAttrData congfa_attr_data = list[Random.Range(0, list.Length)];
        return congfa_attr_data;
    }
}