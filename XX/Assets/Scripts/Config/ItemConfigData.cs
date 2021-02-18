using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 物品配置
/// </summary>
public static class ItemConfigData {
    public static ItemStaticData[] dataList;
    static ItemConfigData() {
        List<ItemStaticData> item_list = new List<ItemStaticData>(GameData.instance.item_static_data);
        int item_id = item_list.Count;
        string[] list = Tools.ReadAllText("Config/itemConfig.txt").Split('\n');
        foreach (string line in list) {
            if (string.IsNullOrWhiteSpace(line)) {
                break;
            }
            if (line.StartsWith("#")) {
                continue;
            }
                string[] configs = line.Split('\t');
                int idx = 0;
                ItemType type = (ItemType)Enum.Parse(typeof(ItemType), configs[idx++]);
                ItemSubType subType = (ItemSubType)Enum.Parse(typeof(ItemSubType), configs[idx++]);

                int price = int.Parse(configs[idx++]);
                int maxcount = int.Parse(configs[idx++]);
                string str_param = configs[idx++];
                int[] param;
                if (string.IsNullOrWhiteSpace(str_param)) {
                    param = new int[0];
                } else {
                    string[] list_param = str_param.Split('|');
                    param = new int[list_param.Length];
                    for (int i = 0; i < list_param.Length; i++) {
                        param[i] = int.Parse(list_param[i]);
                    }
                }
                string name = configs[idx++];
                int icon = int.Parse(configs[idx++]);
                int color = int.Parse(configs[idx++]);
                int level = int.Parse(configs[idx++]);
                string des = string.Join("\n", configs[idx++].Split('|'));
                string attr_str = configs[idx++];
                if (string.IsNullOrWhiteSpace(attr_str)) {
                    RoleAttribute[] attributes = new RoleAttribute[0];
                    int[] attr_values = new int[0];
                } else {
                    string[] attrs = attr_str.Split('|');
                    int attr_count = attrs.Length;
                    RoleAttribute[] attributes = new RoleAttribute[attr_count];
                    int[] attr_values = new int[attr_count];
                    for (int i = 0; i < attr_count; i++) {
                        string[] tmp = attrs[i].Split('*');
                        attributes[i] = (RoleAttribute)Enum.Parse(typeof(RoleAttribute), tmp[0]);
                        attr_values[i] = int.Parse(tmp[1]);
                    }
                }
                item_list.Add(new ItemStaticData() {
                    id = item_id, param = param, type = type, sub_ype = subType, maxcount= maxcount,
                    name = name, icon = icon, color = color, level = level, des = des, price = price
                });
        }
        dataList = item_list.ToArray();
    }
}