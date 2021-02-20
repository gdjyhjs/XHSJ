using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public static class GameConst {
    public const long oneSecondTicks = 864000000000;
    public const long oneDayTicks = 864000000000;
    public const int max_color = 6;
    public const int max_role_level = 12;
    public const int max_item_level = max_role_level / 3;
    public static Dictionary<ItemType, string> itemTypeName = new Dictionary<ItemType, string>() 
    {
        { ItemType.Other, "其他"},
        { ItemType.Remedy, "丹药"},
        { ItemType.Gongfa, "秘籍"},
        { ItemType.Equip, "装备"},
        { ItemType.Material, "材料"},
        { ItemType.Toy, "玩具"},
    };

    public static string[] item_color_str = new string[] { "E6D6BEFF", "3FBD8CFF", "397CB8FF", "A73BBDFF", "DEB731FF", "FC7425FF", "E73E47FF", };
    public static Color[] item_color = new Color[] {
        new Color(0xE6 / 255f, 0xD6 / 255f, 0xBE / 255f),
        new Color(0x3F / 255f, 0xBD / 255f, 0x8C / 255f),
        new Color(0x39 / 255f, 0x7C / 255f, 0xB8 / 255f),
        new Color(0xA7 / 255f, 0x3B / 255f, 0xBD / 255f),
        new Color(0xDE / 255f, 0xB7 / 255f, 0x31 / 255f),
        new Color(0xFC / 255f, 0x74 / 255f, 0x25 / 255f),
        new Color(0xE7 / 255f, 0x3E / 255f, 0x47 / 255f),
    };

    // 技能的威力会根据熟练度来决定：初学70%，熟练80%，小成90%，大成100%，圆满110%，化境120%。
    public static string[] attr_level_name = new string[] { "咋练", "娴熟", "通晓", "小成", "灵动", "精通", "大成", "圆满", "觉醒", "化境", "大道",
    "一千", "二千", "三千", "四千", "五千", "六千", "七千", "八千", "九千", "一万", "十万", };

    public static Dictionary<ItemSubType, string> itemSubTypeName = new Dictionary<ItemSubType, string>()
    {
        { ItemSubType.None, ""},
        { ItemSubType.Heart, "心法"},
        { ItemSubType.Body, "身法"},
        { ItemSubType.Attack, "武技/灵技"},
        { ItemSubType.Magic, "神通"},
        { ItemSubType.Skill, "绝技"},
        { ItemSubType.Ring, "戒指"},
        { ItemSubType.Ride, "坐骑"},
        { ItemSubType.recoverRemedy, "恢复丹药"},
        { ItemSubType.buffRemedy, "增益丹药"},
        { ItemSubType.aptitudesRemedy, "资质丹药"},
        { ItemSubType.otherRemedy, "其他丹药"},
    };

    public static UIShortcutKey[] uIShortcutKeys = new UIShortcutKey[]{
        new UIShortcutKey(){
            type = "uiwindow",
            param1 = "RoleWindow",
            param2 = "role",
            keyCode = KeyCode.I
        },
        new UIShortcutKey(){
            type = "uiwindow",
            param1 = "RoleWindow",
            param2 = "skill",
            keyCode = KeyCode.X
        },
        new UIShortcutKey(){
            type = "uiwindow",
            param1 = "RoleWindow",
            param2 = "artistry",
            keyCode = KeyCode.O
        },
        new UIShortcutKey(){
            type = "uiwindow",
            param1 = "RoleWindow",
            param2 = "bag",
            keyCode = KeyCode.B
        },
        new UIShortcutKey(){
            type = "occupy",
            keyCode = KeyCode.Escape
        },
    };
}
