
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 角色数据
/// </summary>
[System.Serializable]
public class RoleData
{
    public static RoleData mainRole;

    /// <summary>
    /// 角色外观
    /// </summary>
    public RoleAppearance appearance;

    /// <summary>
    /// 角色技能
    /// </summary>
    private int[] save_skills;

    /// <summary>
    /// 装备的技能 
    /// </summary>
    private int[] save_equip_skills;

    /// <summary>
    /// 背包物品
    /// </summary>
    private int[] save_bag_items;

    /// <summary>
    /// 种族
    /// </summary>
    public int race;

    /// <summary>
    /// 内在性格
    /// </summary>
    public int[] intrinsic_disposition;

    /// <summary>
    /// 外在性格
    /// </summary>
    public int[] external_disposition;

    /// <summary>
    /// 先天气运
    /// </summary>
    public int[] xiantianqiyun;

    /// <summary>
    /// 性别
    /// </summary>
    public Sex sex;

    /// <summary>
    /// 名字
    /// </summary>
    public string name;

    /// <summary>
    /// 属性
    /// </summary>
    public int[] attribute;

    /// <summary>
    /// 最大属性
    /// </summary>
    public int[] max_attribute;

    /// <summary>
    /// 临时属性
    /// </summary>
    [System.NonSerialized]
    public int[] tmp_attribute;

    /// <summary>
    /// 最大临时属性
    /// </summary>
    [System.NonSerialized]
    public int[] tmp_max_attribute;

    /// <summary>
    /// 背包数据
    /// </summary>
    [System.NonSerialized]
    public List<int> bag_items;


    public void SaveGame() {
        save_bag_items = bag_items.ToArray();
    }
    public void ReadGame() {
        bag_items = new List<int>(save_bag_items);

        UpdateAttr();
    }

    /// <summary>
    /// 更新属性 重新计算装备增加的属性
    /// </summary>
    public void UpdateAttr() {
        int count = attribute.Length;
        tmp_attribute = new int[count];
        tmp_max_attribute = new int[count];
        for (int i = 0; i < count; i++) {
            tmp_attribute[i] = attribute[i];
            tmp_max_attribute[i] = max_attribute[i];
        }
    }

    public int GetAttr(RoleAttribute attr) {
        return tmp_attribute[(int)attr];
    }

    public int GetMaxAttr(RoleAttribute attr) {
        return tmp_max_attribute[(int)attr];
    }

    public bool AddNewItem(int static_id) {
        if (bag_items.Count >= GetAttr(RoleAttribute.max_item)) {
            MessageTips.Message(21);
            return false;
        }
        int item_id = GameData.instance.NewItem(static_id);
        AddItem(item_id);
        return true;
    }

    public bool AddItem(int item_id) {
        if (bag_items.Count >= GetAttr(RoleAttribute.max_item)) {
            MessageTips.Message(21);
            return false;
        }
        bag_items.Add(item_id);
        return true;
    }

    public void RemoveItem(int item_id) {
        // Todo
    }
}
