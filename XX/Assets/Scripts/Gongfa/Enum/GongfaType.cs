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
    knife = 1 << 1,
    /// <summary>
    /// 枪
    /// </summary>
    spear = 1 << 2,
    /// <summary>
    /// 剑
    /// </summary>
    sword = 1 << 3,
    /// <summary>
    /// 拳
    /// </summary>
    fist = 1 << 4,
    /// <summary>
    /// 掌
    /// </summary>
    palm = 1 << 5,
    /// <summary>
    /// 指
    /// </summary>
    finger = 1 << 6,
    /// <summary>
    /// 火
    /// </summary>
    fire = 1 << 7,
    /// <summary>
    /// 水
    /// </summary>
    water = 1 << 8,
    /// <summary>
    /// 雷
    /// </summary>
    thunder = 1 << 9,
    /// <summary>
    /// 风
    /// </summary>
    wind = 1 << 10,
    /// <summary>
    /// 土
    /// </summary>
    soil = 1 << 11,
    /// <summary>
    /// 木
    /// </summary>
    wood = 1 << 12,
    /// <summary>
    /// 心法
    /// </summary>
    heart = 1 << 13,
    /// <summary>
    /// 身法
    /// </summary>
    body = 1 << 14,
    /// <summary>
    /// 武技/灵技 普攻
    /// </summary>
    attack = 1 << 15,
    /// <summary>
    /// 绝技 技能
    /// </summary>
    skill = 1 << 16,
    /// <summary>
    /// 神通 大招/怒招
    /// </summary>
    magic = 1 << 17,
    /// <summary>
    /// 劲 攻击
    /// </summary>
    jin = 1 << 18,
    /// <summary>
    /// 式 防御
    /// </summary>
    shi = 1 << 19,
    /// <summary>
    /// 录 念力
    /// </summary>
    lu = 1 << 20,
    /// <summary>
    /// 诀 灵力
    /// </summary>
    jue = 1 << 21,
    /// <summary>
    /// 经 体力
    /// </summary>
    jing = 1 << 22,
    /// <summary>
    /// 神功 功法抗性
    /// </summary>
    gong = 1 << 23,
    /// <summary>
    /// 密卷 灵根抗性
    /// </summary>
    juan = 1 << 24,
    /// <summary>
    /// 大法 会心
    /// </summary>
    fa = 1 << 25,

}
