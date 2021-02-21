using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Random = UnityEngine.Random;
using System.Text;
/* 炼气期 筑基期 结丹期 金丹期
功法				每个境界数量 20*12
* */
/// <summary>
/// 创建功法
/// </summary>
public static class CreateGongfa {
    static int gongfa_count = 12;
    // 1劲 2御 3录 4诀 5经 6神功 7密卷 8大法 9身法 10武技灵技 11绝技 12神通
    static int create_count = 20;
    static CreateGongfa() {

    }
    public static int create_id;
    public static int max_id;
    public static void Init() {
        List<GongfaStaticData> gongfa_list = new List<GongfaStaticData>();
        List<ItemStaticData> item_list = new List<ItemStaticData>(GameData.instance.item_static_data);
        // 生成心法 几个境界就循环几次
        int lv_count = LevelConfigData.dataList.Length / 3; // 每个境界有前期，中期，后期 所以这里要除以3 得到境界数量
        int max_count = lv_count * gongfa_count * gongfa_count;
        // 心法 等级数量 * 品质数量 * 功法类型数量  * 
        // 等级数量 * 品质数量 * 功法类型数量  * 
        max_id = lv_count * GameConst.max_color * gongfa_count * create_count * 12 * 12;
        //for (int lv = 0; lv < lv_count; lv++) { // 炼气期 筑基期 结丹期 金丹期 ... 
        //    for (int color = 1; color <= GameConst.max_color; color++) { // 绿 蓝 紫 黄 橙 ...
        //        int role_attr_offset = 0;
        //        for (GongfaType typ = GongfaType.knife; typ <= GongfaType.wood; typ = (GongfaType)((int)typ << 1)) { // 刀枪剑拳掌指火水雷风土木
        //            for (GongfaType bigtype = GongfaType.heart; bigtype <= GongfaType.magic; bigtype = (GongfaType)((int)bigtype << 1)) { // 心法 武技/灵技 身法 绝技 神通
        //                if (bigtype == GongfaType.heart) {
        //                    for (GongfaType subtyp = GongfaType.jin; subtyp <= GongfaType.juan; subtyp = (GongfaType)((int)subtyp << 1)) { // 劲 御 录 诀 经 神功 密卷 大法
        //                        for (int gongfa_idx = 0; gongfa_idx < create_count; gongfa_idx++) { // 每个境界每个属性该功法创建数量
        //                            CreateRandomGongfa(lv, typ | bigtype | subtyp, color, gongfa_list, item_list);
        //                        }
        //                    }
        //                } else {
        //                    for (int gongfa_idx = 0; gongfa_idx < create_count; gongfa_idx++) { // 每个境界每个属性该功法创建数量
        //                        CreateRandomGongfa(lv, typ | bigtype, color, gongfa_list, item_list);
        //                    }
        //                }
        //            }
        //            role_attr_offset++; // 刀枪剑拳掌指火水雷风土木
        //        }
        //    }
        //}

        // 测试 start
        CreateRandomGongfa(0, GongfaType.attack | GongfaType.sword, 5, gongfa_list, item_list);
        CreateRandomGongfa(0, GongfaType.body | GongfaType.sword, 5, gongfa_list, item_list);
        CreateRandomGongfa(0, GongfaType.skill | GongfaType.sword, 5, gongfa_list, item_list);
        CreateRandomGongfa(0, GongfaType.magic | GongfaType.sword, 5, gongfa_list, item_list);
        CreateRandomGongfa(0, GongfaType.heart | GongfaType.jin | GongfaType.sword, 5, gongfa_list, item_list);
        CreateRandomGongfa(0, GongfaType.heart | GongfaType.shi | GongfaType.sword, 5, gongfa_list, item_list);
        CreateRandomGongfa(0, GongfaType.heart | GongfaType.lu | GongfaType.sword, 5, gongfa_list, item_list);
        CreateRandomGongfa(0, GongfaType.heart | GongfaType.jue | GongfaType.sword, 5, gongfa_list, item_list);
        CreateRandomGongfa(0, GongfaType.heart | GongfaType.jing | GongfaType.sword, 5, gongfa_list, item_list);
        CreateRandomGongfa(0, GongfaType.heart | GongfaType.fa | GongfaType.sword, 5, gongfa_list, item_list);
        CreateRandomGongfa(0, GongfaType.heart | GongfaType.gong | GongfaType.sword, 5, gongfa_list, item_list);
        CreateRandomGongfa(0, GongfaType.heart | GongfaType.juan | GongfaType.sword, 5, gongfa_list, item_list);
        // 测试 end
        Debug.Log("功法总创建数量   " + create_id + "/" + max_id + "   id{" + (item_list.Count - create_id - 1) + "-" + (item_list.Count - 1) + "}");


        GameData.instance.gongfa_static_data = gongfa_list.ToArray();
        GameData.instance.item_static_data = item_list.ToArray();
    }


    /// <summary>
    /// 创建功法
    /// </summary>
    public static void CreateRandomGongfa(int lv, GongfaType gongfa_typ, int color, List<GongfaStaticData> gongfa_list, List<ItemStaticData> item_list) {
        create_id = gongfa_list.Count;
        GongfaStaticData gongfa;
        ItemSubType sub_type = ItemSubType.Heart;
        if ((gongfa_typ & GongfaType.heart) == GongfaType.heart) {
            gongfa = new HeartGongfaStaticData(lv, gongfa_typ, color, create_id);
        } else {
            gongfa = new SkillGongfaStaticData(lv, gongfa_typ, color, create_id);
            if ((gongfa_typ & GongfaType.attack) == GongfaType.attack) {
                sub_type = ItemSubType.Attack;
            } else if ((gongfa_typ & GongfaType.body) == GongfaType.body) {
                sub_type = ItemSubType.Body;
            } else if ((gongfa_typ & GongfaType.skill) == GongfaType.skill) {
                sub_type = ItemSubType.Skill;
            } else if ((gongfa_typ & GongfaType.magic) == GongfaType.magic) {
                sub_type = ItemSubType.Magic;
            }
        }

        if (gongfa != null) {
            gongfa_list.Add(gongfa);
            CreateGongfaItem(gongfa, item_list, sub_type);
        }
    }

    public static void CreateGongfaItem(GongfaStaticData gongfa, List<ItemStaticData> item_list, ItemSubType sub_type) {

        StringBuilder des = new StringBuilder();
        if (gongfa is HeartGongfaStaticData) {
            HeartGongfaStaticData gf = (HeartGongfaStaticData)gongfa;
            des.AppendFormat("道点消耗：{0}", gf.need_daodian);
        } else if (gongfa is SkillGongfaStaticData) {
            SkillGongfaStaticData gf = (SkillGongfaStaticData)gongfa;
            des.AppendFormat("技能冷却：{0}", gf.cool);
            des.AppendLine();
            des.AppendFormat("施法消耗：{0}", gf.cost);
        }
        des.AppendLine();
        des.AppendLine("——————————————————");

        bool isSkill = true;
        for (int i = 0; i < gongfa.attr_id.Length; i++) {
            var attr_id = gongfa.attr_id[i];
            GongfaAttrData main_attr_data = GongfaAttrConfig.GetAttrConfig(attr_id);
            if (!main_attr_data.isSkill && isSkill) {
                isSkill = false;
                des.AppendLine("<color=#E28225FF>装备后可获得以下属性</color>");
            }
            if (isSkill) {
                des.AppendLine(DesFormat(main_attr_data.des, gongfa.attr_value[i]));
            } else {
                des.AppendLine("　" + DesFormat(main_attr_data.des, gongfa.attr_value[i]));
            }
        }
        des.AppendLine("——————————————————");
        for (int i = 0; i < gongfa.ex_id.Length; i++) {
            GongfaAttrData congfa_attr_data = GongfaAttrConfig.GetAttrConfig(gongfa.ex_id[i]);
            des.AppendFormat("　<size=10>{1}</size>：<color=#{0}>", GameConst.item_color_str[gongfa.ex_color[i]], GameConst.attr_level_name[i]);
            des.Append(DesFormat(congfa_attr_data.des, gongfa.ex_values[i]));
            des.AppendLine("</color>");
        }
        des.AppendLine("——————————————————");
        if (gongfa.attr_condition[0].Length == 1) {
            RoleAttrConfig[] attribute_config = RoleAttrConfigData.GetAttrConfig();
            des.AppendFormat("学习条件：{0}达到{1}", attribute_config[(int)gongfa.attr_condition[0][0]].name, gongfa.value_condition[0]);
        } else {
            des.AppendFormat("任意一项战斗资质达到{0}", gongfa.value_condition[0]);
        }




        int item_static_id = item_list.Count;
        var item = new ItemStaticData() {
            id = item_static_id,
            type = ItemType.Gongfa,
            sub_ype = sub_type,
            price = gongfa.price,
            maxcount = 1,
            param = new int[] { gongfa.id },

            name = gongfa.name,
            icon = ItemSubType.Magic - sub_type,
            color = gongfa.color,
            level = gongfa.level,

            des = des.ToString(),
            attributes = null,
            attr_values = null,
        };
        item_list.Add(item);
    }

    static string DesFormat(string des, int[] attrs) {
        switch (attrs.Length) {
            case 0:
                return des;
            case 1:
                return string.Format(des, attrs[0]);
            case 2:
                return string.Format(des, attrs[0], attrs[1]);
            case 3:
                return string.Format(des, attrs[0], attrs[1], attrs[2]);
            case 4:
                return string.Format(des, attrs[0], attrs[1], attrs[2], attrs[3]);
            case 5:
                return string.Format(des, attrs[0], attrs[1], attrs[2], attrs[3], attrs[4]);
            default:
                return string.Format(des, attrs[0], attrs[1], attrs[2], attrs[3], attrs[4], attrs[5]);
        }
    }
}