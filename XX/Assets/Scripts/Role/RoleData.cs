
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
    private int[] attribute;

    /// <summary>
    /// 最大属性
    /// </summary>
    private int[] max_attribute;

    /// <summary>
    /// 最终属性
    /// </summary>
    private int[] definitive_attribute;

    /// <summary>
    /// 最终最大属性
    /// </summary>
    private int[] definitive_max_attribute;

    /// <summary>
    /// 背包数据
    /// </summary>
    [System.NonSerialized]
    public List<int> bag_items = new List<int>();

    /// <summary>
    /// 装备的物品id
    /// </summary>
    public int[] equip_items = new int[2] { -1, -1};

    /// <summary>
    /// 装备的丹药id
    /// </summary>
    public int[] remedy_items = new int[5] { -1, -1, -1, -1, -1};


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
        if (definitive_attribute == null || definitive_max_attribute == null) {
            definitive_attribute = new int[count];
            definitive_max_attribute = new int[count];
            for (int i = 0; i < count; i++) {
                definitive_attribute[i] = attribute[i];
                definitive_max_attribute[i] = max_attribute[i];
            }
        }

        int old_ride = GetAttr(RoleAttribute.ride_id);
        int new_ride = -1;

        // 记录更新属性
        int[] max_value = new int[count];
        for (int i = 0; i < count; i++) {
            max_value[i] = max_attribute[i];
        }

        // 计算装备增加的属性
        for (int i = 0; i < equip_items.Length; i++) {
            int item_id = equip_items[i];
            if (item_id == -1)
                continue;
            ItemData item = GameData.instance.all_item[item_id];
            ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
            for (int j = 0; j < static_data.attributes.Length; j++) {
                int attr = (int)static_data.attributes[j];
                max_value[attr] += static_data.attr_values[j];
            }
            if (static_data.sub_ype == ItemSubType.Ride) {
                new_ride = static_data.param[0];
            }
        }

        RoleAttrConfig[] attribute_config = RoleAttrConfigData.GetAttrConfig();
        for (int i = 0; i < count; i++) {
            float rate = definitive_attribute[i] == definitive_attribute[i] ? 1 : definitive_attribute[i] * 1f / definitive_max_attribute[i];
            if (attribute_config[i].type == RoleAttrShowType.FixedMinMax) {
                definitive_max_attribute[i] = max_value[i];
                continue;
            }else if (attribute_config[i].type != RoleAttrShowType.MinMax)
                rate = 1;
            definitive_max_attribute[i] = max_value[i];
            definitive_attribute[i] = (int)(max_value[i] * rate);
        }

        for (int i = 0; i < max_attribute.Length; i++) {
        }
        EventManager.SendEvent(EventTyp.AttrChange, this);

        if (old_ride != new_ride) {
            ChangeAttrebuteValue(RoleAttribute.ride_id, new_ride);
            EventManager.SendEvent(EventTyp.ChangeRide, this);
        }
    }

    public int[] GetAllAttr() {
        return definitive_attribute;
    }

    public int[] GetAllMaxAttr() {
        return definitive_max_attribute;
    }
    public void SetRoleAttr(int[] attribute, int[] max_attribute) {
        this.attribute = attribute;
        this.max_attribute = max_attribute;
    }

    public int GetAttr(RoleAttribute attr) {
        return definitive_attribute[(int)attr];
    }

    public int GetMaxAttr(RoleAttribute attr) {
        return definitive_max_attribute[(int)attr];
    }

    public void ChangeAttrebuteMinValue(RoleAttribute role_attr, int add_value) {
        // 恢复最终数值，然后按照比例恢复本身数值
        int attr = (int)role_attr;
        definitive_attribute[attr] = Mathf.Min(0, Mathf.Min(definitive_attribute[attr] + add_value, definitive_max_attribute[attr]));
        if (definitive_attribute[attr] == definitive_max_attribute[attr]) {
            attribute[attr] = max_attribute[attr];
        } else {
            attribute[attr] = (int)(max_attribute[attr] * (definitive_attribute[attr] *1f / definitive_max_attribute[attr]));
        }
        EventManager.SendEvent(EventTyp.AttrChange, this);
    }

    public void ChangeAttrebuteMaxValue(RoleAttribute role_attr, int add_value) {
        // 增加本身数值，然后重新计算数值
        int attr = (int)role_attr;
        max_attribute[attr] += add_value;

        UpdateAttr();
    }

    public void ChangeAttrebuteValue(RoleAttribute role_attr, int set_value) {
        // 直接修改数值
        int attr = (int)role_attr;
        max_attribute[attr] = set_value;
        if (role_attr != RoleAttribute.life) {
            attribute[attr] = set_value;
        }
        UpdateAttr();
    }

    /// <summary>
    /// 添加或新建道具
    /// </summary>
    /// <param name="static_id">添加的物品静态配置id</param>
    /// <param name="count">添加的数量，返回时大于0则是无法添加的数量</param>
    /// <returns>是否成功添加 无法添加的数量在count</returns>
    public bool AddOrCreateItem(int static_id, ref int count) {
        ItemStaticData static_data = GameData.instance.item_static_data[static_id];
        // 判断是否可以叠加
        for (int i = 0; i < bag_items.Count; i++) {
            ItemData item = GameData.instance.all_item[bag_items[i]];
            if (item.static_id == static_id && item.count < static_data.maxcount) {
                // 背包有物品 并且堆叠数量未满
                int can_count = static_data.maxcount - item.count;
                if (can_count >= count) {
                    item.count += count;
                    EventManager.SendEvent(EventTyp.ItemChange, null);
                    return true;
                } else {
                    count -= can_count;
                    item.count += can_count;
                }
            }
        }

        if (bag_items.Count >= GetAttr(RoleAttribute.max_item)) {
            MessageTips.Message(21); // 提示背包已满
            return false;
        }
        do {
            int item_id = GameData.instance.NewItem(static_id, ref count);
            if (!AddItem(item_id, ref count)) {
                GameData.instance.RemoveItem(item_id);
                return false;
            }
        } while (count > 0);
        return true;
    }

    /// <summary>
    /// 添加道具
    /// </summary>
    /// <param name="static_id">添加的物品id</param>
    /// <param name="count">添加的数量，返回时大于0则是无法添加的数量</param>
    /// <returns>是否成功添加 无法添加的数量在count</returns>
    public bool AddItem(int item_id, ref int count) {
        ItemData add_item = GameData.instance.all_item[item_id];
        ItemStaticData static_data = GameData.instance.item_static_data[add_item.static_id];
        // 判断是否可以叠加
        for (int i = 0; i < bag_items.Count; i++) {
            ItemData item = GameData.instance.all_item[bag_items[i]];
            if (item.static_id == add_item.static_id && item.count < static_data.maxcount) {
                // 背包有物品 并且堆叠数量未满
                int can_count = static_data.maxcount - item.count;
                if (can_count >= count) {
                    item.count += count;
                    GameData.instance.RemoveItem(add_item.id); // 物品堆叠到一起，删除旧的物品
                    EventManager.SendEvent(EventTyp.ItemChange, null);
                    return true;
                } else {
                    count -= can_count;
                    item.count += can_count;
                }
            }
        }

        if (bag_items.Count >= GetAttr(RoleAttribute.max_item)) {
            MessageTips.Message(21); // 提示背包已满
            return false;
        }
        // 增加物品
        bag_items.Add(item_id);
        EventManager.SendEvent(EventTyp.ItemChange, null);
        return true;
    }

    public void RemoveItem(int item_id, int count = 1) {
        ItemData item = GameData.instance.all_item[item_id];
        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        if (count == 0) {
            count = item.count;
        }
        // 移除背包的
        item.count -= count;
        if (item.count <= 0) {
            bag_items.Remove(item_id);
        }
        if (item.count <= 0) {
            // 移除穿在身上的
            if (static_data.type == ItemType.Equip) {
                for (int i = 0; i < equip_items.Length; i++) {
                    if (equip_items[i] == item.id) {
                        equip_items[i] = -1;
                        break;
                    }
                }
            } else if (static_data.sub_ype == ItemSubType.recoverRemedy || static_data.sub_ype == ItemSubType.buffRemedy) {
                for (int i = 0; i < remedy_items.Length; i++) {
                    if (remedy_items[i] == item.id) {
                        remedy_items[i] = -1;
                        break;
                    }
                }
            }

            // 移除物品库
            GameData.instance.RemoveItem(item_id);
        }
        EventManager.SendEvent(EventTyp.ItemChange, null);
    }

    public void UseItem(int item_id, int count = 1) {
        ItemData item = GameData.instance.all_item[item_id];
        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        if (!LevelConfigData.CheckLevel(GetAttr(RoleAttribute.level), static_data.level)) {
            MessageTips.Message(43, LevelConfigData.GetBigName(static_data.level));
            return;
        }

        if (static_data.sub_ype == ItemSubType.recoverRemedy) { // 恢复药物
            // 扣除道具
            RemoveItem(item_id, count);
            // 恢复
            for (int i = 0; i < static_data.attributes.Length; i++) {
                ChangeAttrebuteMinValue(static_data.attributes[i], static_data.attr_values[i] * count);
            }
        } else if (static_data.sub_ype == ItemSubType.aptitudesRemedy) { // 灵根药物
            // 扣除道具
            RemoveItem(item_id, count);
            // 增加属性
            for (int i = 0; i < static_data.attributes.Length; i++) {
                int multiple = (GetAttr(static_data.attributes[i]) >= static_data.param[0]) ? 0 : 1;
                ChangeAttrebuteMaxValue(static_data.attributes[i], static_data.attr_values[i] * count * multiple);
            }
        }
    }

    /// <summary>
    /// 装备物品
    /// 戒指或坐骑：如果是已穿戴就卸下，否则就穿戴
    /// 药物：是已装备的药物则卸下，否则装备到最后一个空格子，没有的话提示装备已满
    /// </summary>
    public void EquipItem(int item_id) {
        ItemData item = GameData.instance.all_item[item_id];
        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        if (!LevelConfigData.CheckLevel(GetAttr(RoleAttribute.level), static_data.level)) {
            MessageTips.Message(43, LevelConfigData.GetBigName(static_data.level));
            return;
        }
        // 移除穿在身上的
        if (static_data.sub_ype == ItemSubType.Ring) {
            if (equip_items[0] != -1) {
                int empty_count = GetAttr(RoleAttribute.max_item) - bag_items.Count;
                Debug.Log("max_item = " + GetAttr(RoleAttribute.max_item));
                Debug.Log("bag_items.Count = " + bag_items.Count);
                Debug.Log("empty_count = " + empty_count);
                if (equip_items[0] == item_id) {
                    // 脱下
                    empty_count -= GetItemAttrbuite(item_id, RoleAttribute.max_item);
                    Debug.Log("脱下 = " + empty_count);
                } else {
                    // 更换
                    if (equip_items[0] != -1) {
                        empty_count -= GetItemAttrbuite(equip_items[0], RoleAttribute.max_item);
                        Debug.Log("更换 = " + empty_count);
                    }
                    empty_count += GetItemAttrbuite(item_id, RoleAttribute.max_item);
                    Debug.Log("穿戴 = " + empty_count);
                }
                if (empty_count < 0) {
                    // 无法更换或脱下戒指
                    MessageTips.Message(44);
                    return;
                }
            }

            if (equip_items[0] == item_id) { // 戒指
                equip_items[0] = -1;
            } else {
                equip_items[0] = item_id;
            }
            UpdateAttr();
            EventManager.SendEvent(EventTyp.ItemChange, null);
        } else if (static_data.sub_ype == ItemSubType.Ride) {
            if (equip_items[1] == item_id) { // 坐骑
                equip_items[1] = -1;
            } else {
                equip_items[1] = item_id;
            }
            UpdateAttr();
            EventManager.SendEvent(EventTyp.ItemChange, null);
        } else if (static_data.sub_ype == ItemSubType.recoverRemedy || static_data.sub_ype == ItemSubType.buffRemedy) {
            for (int i = 0; i < remedy_items.Length; i++) { // 判断卸下丹药
                if (remedy_items[i] == item_id) {
                    remedy_items[i] = -1;
                    EventManager.SendEvent(EventTyp.ItemChange, null);
                    return;
                }
            }
            for (int i = 0; i < remedy_items.Length; i++) { // 判断穿戴丹药
                if (remedy_items[i] == -1) {
                    remedy_items[i] = item_id;
                    EventManager.SendEvent(EventTyp.ItemChange, null);
                    return;
                }
            }
            MessageTips.Message(27);
        }
    }

    public int GetItemAttrbuite(int item_id, RoleAttribute attribute) {
        ItemData item = GameData.instance.all_item[item_id];
        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        for (int i = 0; i < static_data.attributes.Length; i++) {
            if (static_data.attributes[i] == RoleAttribute.max_item) {
                return static_data.attr_values[i];
            }
        }
        return 0;
    }

    /// <summary>
    /// 是否可以穿戴物品
    /// </summary>
    /// <param name="item_id">返回可穿在的索引</param>
    /// <returns></returns>
    public int CanEquipItem(int item_id) {
        if (ItemIsEquip(item_id))
            return -1;
        ItemData item = GameData.instance.all_item[item_id];
        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        // 移除穿在身上的
        if (static_data.sub_ype == ItemSubType.Ring) {
            if (equip_items[0] == -1) { // 戒指
                return 0;
            }
        }else if (static_data.sub_ype == ItemSubType.Ride) {
            if (equip_items[1] == -1) { // 坐骑
                return 1;
            }
        } else if (static_data.sub_ype == ItemSubType.recoverRemedy || static_data.sub_ype == ItemSubType.buffRemedy) {
            for (int i = 0; i < remedy_items.Length; i++) { // 丹药
                if (remedy_items[i] == -1) {
                    return i;
                }
            }
        }
        return -1;
    }

    /// <summary>
    /// 物品是否装备着
    /// </summary>
    /// <returns></returns>
    public bool ItemIsEquip(int item_id) {
        var item = GameData.instance.all_item[item_id];
        bool isWear = false; // 是否穿戴者
        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        if (static_data.sub_ype == ItemSubType.Ring) {
            return (equip_items[0] == item.id); // 戒指位置
        } else if (static_data.sub_ype == ItemSubType.Ride) {
            return (equip_items[1] == item.id); // 坐骑位置
        } else if (static_data.sub_ype == ItemSubType.recoverRemedy || static_data.sub_ype == ItemSubType.buffRemedy) {
            foreach (var id in remedy_items) { // 丹药
                if (id == item.id) {
                    isWear = true;
                    break;
                }
            }
        }
        return isWear;
    }
}
