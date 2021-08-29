using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// 属性
public class Attribute {
    public int seed;

    public Attribute() {
        seed = StaticTools.Random(int.MinValue, int.MaxValue);
    }

    public int hp // 用于显示的 生命
    {
        get { return Mathf.CeilToInt( health_cur); }
    }
    public int maxHp // 用于显示的 最大生命
    {
        get { return Mathf.CeilToInt(health_max); }
    }
    public int mp // 用于显示的 内力
    {
        get { return Mathf.CeilToInt(magic_cur); }
    }
    public int maxMp // 用于显示的 最大内力
    {
        get { return Mathf.CeilToInt(magic_max); }
    }
    public int Speed // 用于显示的 移动速度
    {
        get { return Mathf.CeilToInt(speed)  * 100; }
    }

    public int level = 1;//等级
    public int exp = 0;//经验值

    public float health_max = 100;//最大生命
    public float health_cur = 100;//当前生命
    public float health_restore = 1;//生命回复
    public float magic_max = 100;//最大魔法
    public float magic_cur = 100;//当前魔法
    public float magic_restore = 1;//魔法回复

    public float attack = 5;//伤害
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
