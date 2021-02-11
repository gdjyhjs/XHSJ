
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 角色数据
/// </summary>
[System.Serializable]
public class RoleData
{

    /// <summary>
    /// 角色外观
    /// </summary>
    public RoleAppearance appearance;

    /// <summary>
    /// 角色技能
    /// </summary>
    int[] skills;

    /// <summary>
    /// 装备的技能 
    /// </summary>
    int[] equip_skills;

    /// <summary>
    /// 内在性格
    /// </summary>
    public int[] intrinsic_disposition;

    /// <summary>
    /// 外在性格
    /// </summary>
    public int[] external_disposition;

    /// <summary>
    /// 种族
    /// </summary>
    public int race;

    /// <summary>
    /// 境界 等级
    /// </summary>
    public int level;

    /// <summary>
    /// 经验值
    /// </summary>
    public int exp;

    /// <summary>
    /// 最大经验值
    /// </summary>
    public int max_exp;

    /// <summary>
    /// 性别
    /// </summary>
    public int sex;

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
}
