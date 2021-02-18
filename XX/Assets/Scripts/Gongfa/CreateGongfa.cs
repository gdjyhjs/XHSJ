using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Random = UnityEngine.Random;
/* 炼气期 筑基期 结丹期 金丹期
功法				每个境界数量 20*12
 * */
/// <summary>
/// 创建功法
/// </summary>
public static class CreateGongfa {
    static int gongfa_count = 12;
    // 1劲 2御 3录 4诀 5经 6神功 7密卷 8大法 9身法 10武技灵技 11绝技 12神通
    static int create_count = 1;
    static CreateGongfa() {

    }
    public static int create_id;
    public static int max_id;
    public static void Init() {
        List<GongfaStaticData> gongfa_list = new List<GongfaStaticData>();
        // 生成心法 几个境界就循环几次
        int lv_count = LevelConfigData.dataList.Length / 3; // 每个境界有前期，中期，后期 所以这里要除以3 得到境界数量
        int max_count = lv_count * gongfa_count * gongfa_count;
        create_id = 0;
        max_id = 0;
        for (int lv = 0; lv < lv_count; lv++) { // 几个境界 循环几次 每次创建该境界功法
            for (int role_attr = 0; role_attr < gongfa_count; role_attr++) { // 几个属性循环几次 每次创建该属性功法 刀枪剑拳掌指火水雷风土木
                for (int gongfa_idx = 0; gongfa_idx < create_count; gongfa_idx++) { // 每个境界每个属性该功法创建数量
                    // 心法
                    for (GongfaType typ = GongfaType.jin; typ <= GongfaType.fa; typ = (GongfaType)((int)typ << 1)) {
                        max_id++;
                    }
                }
            }
        }
        for (int lv = 0; lv < lv_count; lv++) { // 几个境界 循环几次 每次创建该境界功法
            for (int role_attr = 0; role_attr < gongfa_count; role_attr++) { // 几个属性循环几次 每次创建该属性功法 刀枪剑拳掌指火水雷风土木
                for (int gongfa_idx = 0; gongfa_idx < create_count; gongfa_idx++) { // 每个境界每个属性该功法创建数量
                    // 心法，劲-攻击，式-防御，录-念力，诀-灵力，经-体力，神功-功法抗性，密卷-灵根抗性，大法-会心
                    for (GongfaType typ = GongfaType.jin; typ <= GongfaType.fa; typ = (GongfaType)((int)typ << 1)) {
                        gongfa_list.Add(CreateRandomGongfa(lv, GongfaType.heart | typ, RoleAttribute.gongfa_knife + role_attr));
                        create_id++;
                    }
                    // 身法
                    // 武技/灵技
                    // 绝技
                    // 神通
                }
            }
        }
        Debug.Log("功法总创建数量 " + create_id + "/" + max_id);

        List<ItemStaticData> item_list = new List<ItemStaticData>(GameData.instance.item_static_data);
        int item_id = item_list.Count;
        foreach (GongfaStaticData gongfa in gongfa_list) {
            ItemSubType subType = ItemSubType.Heart;
            item_list.Add(new ItemStaticData() { id = item_id, param = new int[] { gongfa.id }, type = ItemType.Gongfa, sub_ype = subType,
                name = gongfa.name.Substring(4, gongfa.name.Length - 4),icon = 0, color = gongfa.color, level = gongfa.level,
                price = gongfa.price, maxcount = 1,
            });
            item_id++;
        }
        GameData.instance.gongfa_static_data = gongfa_list.ToArray();
        GameData.instance.item_static_data = item_list.ToArray();
    }

    /// <summary>
    ///  创建随机功法
    /// </summary>
    public static GongfaStaticData CreateRandomGongfa(int lv, GongfaType gongfa_typ, RoleAttribute role_attr) {
        if ((gongfa_typ & GongfaType.heart) == GongfaType.heart) {
            // 创建心法
            return CreateRandomHeartGongfaData(lv, gongfa_typ, role_attr);
        }
        throw new Exception("gongfa type error");
    }

    /// <summary>
    /// 创建随机心法
    /// </summary>
    public static HeartGongfaStaticData CreateRandomHeartGongfaData(int lv, GongfaType gongfa_typ, RoleAttribute roleAttr) {
        HeartGongfaStaticData gongfa = new HeartGongfaStaticData();
        SetGongfaData(gongfa, lv, gongfa_typ);
        if ((gongfa_typ & GongfaType.gong) == GongfaType.gong) {
            gongfa.name += "神功";
            // 功法需求属性类型
            RoleAttribute[] condition = new RoleAttribute[] { roleAttr };
            gongfa.attr_condition = new RoleAttribute[][] { condition };
            // 功法主要增加的属性
            SetGongfaMainAttribyte(gongfa, GongfaType.gong);
        } else if ((gongfa_typ & GongfaType.juan) == GongfaType.juan) {
            gongfa.name += "密卷";
            // 功法需求属性类型
            RoleAttribute[] condition = new RoleAttribute[] { roleAttr };
            gongfa.attr_condition = new RoleAttribute[][] { condition };
            // 功法主要增加的属性
            SetGongfaMainAttribyte(gongfa, GongfaType.juan);
        } else {
            // 功法需求属性类型 以下功法学习条件是任意战斗资质达到某个数值
            RoleAttribute[] condition = new RoleAttribute[] { RoleAttribute.gongfa_knife, RoleAttribute.gongfa_spear,
                RoleAttribute.gongfa_sword, RoleAttribute.gongfa_fist, RoleAttribute.gongfa_palm, RoleAttribute.gongfa_finger, };
            gongfa.attr_condition = new RoleAttribute[][] { condition };
            if ((gongfa_typ & GongfaType.jin) == GongfaType.jin) {
                gongfa.name += "劲";
                // 功法主要增加的属性
                SetGongfaMainAttribyte(gongfa, GongfaType.jin);
            }else if ((gongfa_typ & GongfaType.shi) == GongfaType.shi) {
                gongfa.name += "式";
                // 功法主要增加的属性
                SetGongfaMainAttribyte(gongfa, GongfaType.shi);
            } else if ((gongfa_typ & GongfaType.lu) == GongfaType.lu) {
                gongfa.name += "录";
                // 功法主要增加的属性
                SetGongfaMainAttribyte(gongfa, GongfaType.lu);
            } else if ((gongfa_typ & GongfaType.jue) == GongfaType.jue) {
                gongfa.name += "诀";
                // 功法主要增加的属性
                SetGongfaMainAttribyte(gongfa, GongfaType.jue);
            } else if ((gongfa_typ & GongfaType.jing) == GongfaType.jing) {
                gongfa.name += "经";
                // 功法主要增加的属性
                SetGongfaMainAttribyte(gongfa, GongfaType.jing);
            } else if ((gongfa_typ & GongfaType.fa) == GongfaType.fa) {
                gongfa.name += "大法";
                // 功法主要增加的属性
                SetGongfaMainAttribyte(gongfa, GongfaType.fa);
            }
        }
        // 功法需求属性数值
        gongfa.value_condition = new int[] { SetGongfaConditionValue(gongfa) };
        // 功法需要的道点
        gongfa.need_daodian = SetGongfaNeedDaodian(gongfa);
        return gongfa;

    }
    /// <summary>
    /// 设置功法主要属性
    /// </summary>
    public static void SetGongfaMainAttribyte(HeartGongfaStaticData gongfa, GongfaType gongfa_typ) {
        int lv = gongfa.level;
        GongfaAttrData congfa_attr_data = GongfaAttrConfig.GetRandomExAttr(gongfa_typ);
        gongfa.attr_typ = congfa_attr_data.attr;
        gongfa.gongfa_attr_id = congfa_attr_data.id;
        gongfa.attr_value = congfa_attr_data.min_attr[0][lv] + (congfa_attr_data.max_attr[0][lv] - congfa_attr_data.min_attr[0][lv]) * gongfa.color / GameConst.max_color;
    }

    /// <summary>
    /// 设置属性需求数值
    /// </summary>
    public static int SetGongfaConditionValue(GongfaStaticData gongfa) {
        return gongfa.level * gongfa.level * 6 + gongfa.level * gongfa.color + gongfa.level * 2 + gongfa.color;
    }

    /// <summary>
    /// 设置需要的道点
    /// </summary>
    public static int SetGongfaNeedDaodian(GongfaStaticData gongfa) {
        return (int)((gongfa.level * gongfa.level * 6 + gongfa.level * gongfa.color + gongfa.level * 2 + gongfa.color) * 0.1 * gongfa.color + 2 * gongfa.color);
    }

    /// <summary>
    /// 设置功法基础数据和词条
    /// </summary>
    public static void SetGongfaData(GongfaStaticData gongfa, int lv, GongfaType gongfa_typ) {
        gongfa.id = create_id;
        gongfa.name = GetGongfaName(lv, gongfa_typ);
        gongfa.level = lv;
        int color = Random.Range(1, GameConst.max_color + 1);
        gongfa.color = color;
        gongfa.price = 20 * (lv + 1) * (gongfa.color + 1);
        gongfa.type = gongfa_typ;
        int ex_count = lv + gongfa.color;
        
        // 随机功法词条
        gongfa.ex_gongfa_attr_data_id = new int[ex_count];
        gongfa.ex_attrs = new RoleAttribute[ex_count];
        gongfa.ex_values = new int[ex_count][];
        gongfa.attr_condition = new RoleAttribute[ex_count][];
        gongfa.value_condition = new int[ex_count];
        for (int i = 0; i < ex_count; i++) {
            GongfaAttrData congfa_attr_data = GongfaAttrConfig.GetRandomExAttr(gongfa_typ);
            gongfa.ex_gongfa_attr_data_id[i] = congfa_attr_data.id;
            gongfa.ex_attrs[i] = congfa_attr_data.attr;
            gongfa.ex_values[i] = congfa_attr_data.GetRandomAttr(lv, color);
        }
    }

    public static string GetGongfaName(int lv, GongfaType gongfa_typ) {
        return RandName.GetRandPopeName();
    }
}