using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public static class GameConst {
    public static int max_color = 6;
    public static Dictionary<ItemType, string> itemTypeName = new Dictionary<ItemType, string>() 
    {
        { ItemType.Other, "其他"},
        { ItemType.Remedy, "丹药"},
        { ItemType.Gongfa, "秘籍"},
        { ItemType.Equip, "装备"},
        { ItemType.Material, "材料"},
        { ItemType.Toy, "玩具"},
    };

    public static Dictionary<ItemSubType, string> itemSubTypeName = new Dictionary<ItemSubType, string>()
    {
        { ItemSubType.None, ""},
        { ItemSubType.Heart, "心法"},
        { ItemSubType.Body, "身法"},
        { ItemSubType.Attack, "武技"},
        { ItemSubType.Magic, "灵技"},
        { ItemSubType.Skill, "绝技"},
        { ItemSubType.Witchcraft, "神通"},
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
