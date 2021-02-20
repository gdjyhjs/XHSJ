using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

/// <summary>
/// 角色属性配置数据
/// </summary>
public static class GongfaAttrConfig {
    public static Dictionary<int, GongfaAttrData> dataList; // 键是词条ID 值是对应的词条数据
    public static Dictionary<GongfaType, GongfaAttrData[]> typeList; // 键是功法类型 值是该类型对应可以有哪些词条
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

#if UNITY_EDITOR
            Debug.Log(line);
#endif

            string[] configs = line.Split('\t');
            int id = int.Parse(configs[0]);

            // 计算词条对应的功法
            GongfaType type = GongfaType.none;
            string[] types = configs[1].Split('|');
            foreach (string typ_str in types) {
                type |= (GongfaType)Enum.Parse(typeof(GongfaType), typ_str);
            }

            string des = configs[3];
            string name = configs[4];
            float cool = float.Parse(configs[5]);
            int cost = int.Parse(configs[6]);

            bool isSkill = false;
            // 词条赋予的属性
            RoleAttribute attr;
            GongfaSkill skill = GongfaSkill.None;
            if (!Enum.TryParse(configs[7], out attr)) {
                isSkill = true;
                skill = (GongfaSkill)Enum.Parse(typeof(GongfaSkill), configs[7]);
            }

            // 第一个索引是保存不同境界的最小随机范围 第二个索引是有些词条会有多个属性变量
            int[][] min_attr;
            int[][] max_attr;
            string attr_str = configs[8];
            if (!(string.IsNullOrWhiteSpace(attr_str) || attr_str == "-")) {
                List<int[]> all_min_attr = new List<int[]>();
                List<int[]> all_max_attr = new List<int[]>();
                string[] allattr = attr_str.Split(';');
                for (int attr_idx = 0; attr_idx < allattr.Length; attr_idx++) {
                    int[] minAttr = new int[GameConst.max_item_level];
                    int[] maxAttr = new int[GameConst.max_item_level];
                    string[] attrs = allattr[attr_idx].Split('|');
                    for (int lv = 0; lv < attrs.Length; lv++) {
                        string[] minmax = attrs[lv].Split('-');
                        minAttr[lv] = (int.Parse(minmax[0]));
                        maxAttr[lv] = (int.Parse(minmax[1]));
                    }
                    all_min_attr.Add(minAttr);
                    all_max_attr.Add(maxAttr);
                }
                min_attr = all_min_attr.ToArray();
                max_attr = all_max_attr.ToArray();
            } else {
                min_attr = new int[0][];
                max_attr = new int[0][];
            }

            if (!all.ContainsKey(type)) {
                all.Add(type, new List<GongfaAttrData>());
            }
            GongfaAttrData attr_data = new GongfaAttrData() {
                id = id, type = type, name = name, des = des, isSkill = isSkill, attr = attr, skill = skill,
                min_attr = min_attr, max_attr = max_attr, cost = cost, cool = cool,
            };

            all[type].Add(attr_data);
            dataList.Add(id, attr_data);
        }

        typeList = new Dictionary<GongfaType, GongfaAttrData[]>();
        foreach (KeyValuePair<GongfaType, List<GongfaAttrData>> item in all) {
            typeList.Add(item.Key, item.Value.ToArray());
        }
    }

    public static GongfaAttrData GetAttrConfig(int attr_id) {
        return dataList[attr_id];
    }

    /// <summary>
    /// 获取随机词条
    /// </summary>
    public static GongfaAttrData GetRandomExAttr(GongfaType gongfa_typ) {
        List<GongfaAttrData> list = new List<GongfaAttrData>();
        foreach (KeyValuePair<GongfaType, GongfaAttrData[]> item in typeList) {
            if ((item.Key & gongfa_typ) == item.Key) {
                list.AddRange(item.Value);
            }
        }

#if UNITY_EDITOR
        List<GongfaType> typs = new List<GongfaType>();
        for (int i = 1; i != 1 << 31; i = i << 1) {
            if (((int)gongfa_typ & i) == i) {
                typs.Add((GongfaType)i);
            }
        }
        if (list.Count < 1) {
            Debug.LogError("ex_attr can't find : " + string.Join(", ", typs));
        }
#endif
        GongfaAttrData congfa_attr_data = list[Random.Range(0, list.Count)];
#if UNITY_EDITOR
        Debug.Log("随机词条 : " + congfa_attr_data.name + " >> " + string.Join(", ", typs));
#endif
        return congfa_attr_data;
    }

    /// <summary>
    /// 获取主词条
    /// </summary>
    public static GongfaAttrData[] GetMainAttr(GongfaType gongfa_typ) {
        Debug.LogError("GongfaAttrData GetMainAttr gongfa_typ = "+ LogList(gongfa_typ));
        List<GongfaAttrData> list = new List<GongfaAttrData>();
        foreach (KeyValuePair<GongfaType, GongfaAttrData[]> item in typeList) {
            if ((gongfa_typ & item.Key) == item.Key) {
                if ((item.Key & GongfaType.main) == GongfaType.main) {
                    list.AddRange(item.Value);
                }
            }
        }

#if UNITY_EDITOR
        List<GongfaType> typs = new List<GongfaType>();
        for (int i = 1; i != 1 << 31; i = i << 1) {
            if (((int)gongfa_typ & i) == i) {
                typs.Add((GongfaType)i);
            }
        }
        if (list.Count < 1) {
            Debug.LogError("ex_attr can't find : " + string.Join(", ", typs));
        }
        
#endif
        List<GongfaAttrData> result = new List<GongfaAttrData>();
        for (int i = list.Count - 1; i >= 0; i--) {
            GongfaAttrData item = list[i];
            Debug.Log(i + " " + item.des + " " + item.name + " " + item.isSkill);
            if (item.isSkill) {
                result.Add(item);
                list.RemoveAt(i);
            }
        }
        if (result.Count > 0) {
            // 如果有技能属性，排到第一，多条只随机取一条
            var main_attr = result[Random.Range(0, result.Count - 1)]; // 随机一条技能主属性
            result = new List<GongfaAttrData>();
            Debug.Log("主属性技能 " + main_attr.des + " " + main_attr.name);
            Debug.Log("主属性词条数量" + list.Count);
            for (int i = 0; i < result.Count; i++) {
                Debug.Log(i + "主属性词条 " + result[i].des + " " + result[i].name);
            }
            result.Add(main_attr);
            result.AddRange(list);
        } else {
            result = list;
        }
        Debug.Log("排序主词条数量" + list.Count);
        for (int i = 0; i < result.Count; i++) {
            Debug.Log(i+"排序主词条 " + result[i].des + " " + result[i].name);
        }
#if UNITY_EDITOR
        for (int i = 0; i < result.Count; i++) {
            Debug.Log(i + " 主词条 : " + result[i].name + " >> " + string.Join(", ", typs));
        }
#endif
        return result.ToArray();
    }


#if UNITY_EDITOR
    static string LogList(GongfaType gongfa_typ) {
        List<GongfaType> typs = new List<GongfaType>();
        for (int i = 1; i != 1 << 31; i = i << 1) {
            if (((int)gongfa_typ & i) == i) {
                typs.Add((GongfaType)i);
            }
        }
        return string.Join(", ", typs);
    }
#endif
}