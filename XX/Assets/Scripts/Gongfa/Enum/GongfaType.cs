using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 功法词条
/// </summary>
public enum GongfaType {
    none = 0,
    /// <summary>
    /// 刀
    /// </summary>
    knife = 1 << 0,
    /// <summary>
    /// 枪
    /// </summary>
    spear = 1 << 1,
    /// <summary>
    /// 剑
    /// </summary>
    sword = 1 << 2,
    /// <summary>
    /// 拳
    /// </summary>
    fist = 1 << 3,
    /// <summary>
    /// 掌
    /// </summary>
    palm = 1 << 4,
    /// <summary>
    /// 指
    /// </summary>
    finger = 1 << 5,
    /// <summary>
    /// 火
    /// </summary>
    fire = 1 << 6,
    /// <summary>
    /// 水
    /// </summary>
    water = 1 << 7,
    /// <summary>
    /// 雷
    /// </summary>
    thunder = 1 << 8,
    /// <summary>
    /// 风
    /// </summary>
    wind = 1 << 9,
    /// <summary>
    /// 土
    /// </summary>
    soil = 1 << 10,
    /// <summary>
    /// 木
    /// </summary>
    wood = 1 << 11,
    /// <summary>
    /// 心法
    /// </summary>
    heart = 1 << 12,
    /// <summary>
    /// 武技/灵技 普攻
    /// </summary>
    attack = 1 << 13,
    /// <summary>
    /// 身法
    /// </summary>
    body = 1 << 14,
    /// <summary>
    /// 绝技 技能
    /// </summary>
    skill = 1 << 15,
    /// <summary>
    /// 神通 大招/怒招
    /// </summary>
    magic = 1 << 16,
    /// <summary>
    /// 劲 攻击
    /// </summary>
    jin = 1 << 17,
    /// <summary>
    /// 式 防御
    /// </summary>
    shi = 1 << 18,
    /// <summary>
    /// 录 念力
    /// </summary>
    lu = 1 << 19,
    /// <summary>
    /// 诀 灵力
    /// </summary>
    jue = 1 << 20,
    /// <summary>
    /// 经 体力
    /// </summary>
    jing = 1 << 21,
    /// <summary>
    /// 大法 会心
    /// </summary>
    fa = 1 << 22,
    /// <summary>
    /// 神功 功法抗性
    /// </summary>
    gong = 1 << 23,
    /// <summary>
    /// 密卷 灵根抗性
    /// </summary>
    juan = 1 << 24,
    /// <summary>
    /// 词条配置标记为主属性
    /// </summary>
    main = 1 << 25,

}

public enum GongfaSkill {
    None = 0,
    /// <summary>
    /// 清风剑
    /// </summary>
    AttackJianQingfeng,

    /// <summary>
    /// 身法-御剑术
    /// </summary>
    BodyJianYu,

    /// <summary>
    /// 绝技-绝影剑
    /// </summary>
    SkillJianJueying,

    /// <summary>
    /// 神通-骤天剑
    /// </summary>
    MagicJianJueying,


    /// <summary>
    /// 开始技能属性
    /// </summary>
    SkillAttr = 100000,
    /// <summary>
    /// 对所有敌人增伤{0}%
    /// </summary>
    AllUnitDamage,
    /// <summary>
    /// 对普通(怪物)单位增伤{0}%
    /// </summary>
    MonsterUnitDamage,
    /// <summary>
    /// 对精英(大怪)单位增伤{0}%
    /// </summary>
    MonstrosityUnitDamage,
    /// <summary>
    /// 对大妖兽(BOSS)增伤{0}%
    /// </summary>
    BossUnitDamage,
    /// <summary>
    /// 对修仙者(人)增伤{0}%
    /// </summary>
    BossHumanDamage,

}