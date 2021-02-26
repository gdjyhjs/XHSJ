using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum ItemType {
    /// <summary>
    /// 其他
    /// </summary>
    Other,
    /// <summary>
    /// 丹药
    /// </summary>
    Remedy,
    /// <summary>
    /// 秘籍 参数：功法id
    /// </summary>
    Gongfa,
    /// <summary>
    /// 装备
    /// </summary>
    Equip,
    /// <summary>
    /// 材料
    /// </summary>
    Material,
    /// <summary>
    /// 玩具
    /// </summary>
    Toy,

    end,
}

public enum ItemSubType {

    /// <summary>
    /// 默认
    /// </summary>
    None,


    /// <summary>
    /// 心法
    /// </summary>
    Heart = 1000,
    /// <summary>
    /// 身法
    /// </summary>
    Body,
    /// <summary>
    /// 武技/灵技
    /// </summary>
    Attack,
    /// <summary>
    /// 绝技 技能
    /// </summary>
    Skill,
    /// <summary>
    /// 神通 大招/怒招
    /// </summary>
    /// 
    Magic,



    /// <summary>
    /// 戒指
    /// </summary>
    Ring = 2000,
    /// <summary>
    /// 坐骑
    /// </summary>
    Ride,



    /// <summary>
    /// 恢复丹药 参数：战斗中消耗念力
    /// </summary>
    recoverRemedy = 3000,
    /// <summary>
    /// 增益丹药 参数：战斗中消耗念力,持续时间
    /// </summary>
    buffRemedy,
    /// <summary>
    /// 资质丹药 参数：资质限制
    /// </summary>
    aptitudesRemedy,
    /// <summary>
    /// 其他功能丹药 筑基丹参数：成功率
    /// </summary>
    otherRemedy,
}
