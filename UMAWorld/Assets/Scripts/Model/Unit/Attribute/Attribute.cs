using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// 属性
public class Attribute {
    public int level;//等级
    public int exp;//经验值
    public float power;//力量-影响物理伤害、物理防御和暴击伤害
    public float strength;//强壮-影响生命值上限、体力、防御能力和生命回复能力
    public float intelligence;//智力-影响魔法值上限、魔法威力、魔法抗性、魔法回复能力和统率力
    public float dexterity;//敏捷-影响攻击速度移、动速度、暴击率和暴击伤害

    public float health_max;//最大生命
    public float health_cur;//当前生命
    public float health_restore;//生命回复
    public float magic_max;//最大魔法
    public float magic_cur;//当前魔法
    public float magic_restore;//魔法回复

    public float damage;//伤害
    public float defence;//防御力
    
    public float speed;//移动速度
    public float rotationSpeed;//转向速度

    public int resist_fire;//火抗性
    public int resist_forzen;//冰抗性
    public int resist_lighting;//雷抗性
    public int resist_poison;//毒抗性
    public int resist_holy;//神圣抗性
    public int resist_dark;//黑暗抗性

    public bool isDie; // 是否死亡

}
