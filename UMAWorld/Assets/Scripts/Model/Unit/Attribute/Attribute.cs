using System.Collections;
using System.Collections.Generic;

// 属性
public class Attribute {
    public int level = 1;//等级
    public int exp = 0;//经验值
    public float power = 10;//力量-影响物理伤害、物理防御和暴击伤害
    public float strength = 10;//强壮-影响生命值上限、体力、防御能力和生命回复能力
    public float intelligence = 10;//智力-影响魔法值上限、魔法威力、魔法抗性、魔法回复能力和统率力
    public float dexterity = 10;//敏捷-影响攻击速度移、动速度、暴击率和暴击伤害

    public float health_max = 100;//最大生命
    public float health_cur = 100;//当前生命
    public float health_restore = 1;//生命回复
    public float magic_max = 100;//最大魔法
    public float magic_cur = 100;//当前魔法
    public float magic_restore = 1;//魔法回复

    public float damage = 5;//伤害
    public float defence = 3;//防御力
    
    public float speed = 1;//移动速度
    public float rotationSpeed = 100;//转向速度

    public int resist_fire = 0;//火抗性
    public int resist_forzen = 0;//冰抗性
    public int resist_lighting = 0;//雷抗性
    public int resist_poison = 0;//毒抗性
    public int resist_holy = 0;//神圣抗性
    public int resist_dark = 0;//黑暗抗性

    public bool isDie; // 是否死亡

}
