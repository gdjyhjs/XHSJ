using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ARPGDemo.Skill;

public class CharacterBase: UniqueIdObject {
    public StaticDataRoleBaseEle staticData;

    public List<ItemAttribute> items = new List<ItemAttribute>();
    public List<ItemAttribute> equips = new List<ItemAttribute>();
    public List<SkillData> skills = new List<SkillData>();

    public Vector3 position;

    public string charName;

    /// <summary>
    /// 攻击距离
    /// </summary>
    public float attackDistance;

    /// <summary>
    /// 攻击速度 指的是播放攻击动画的速度
    /// </summary>
    public float attackSpeed;

    /// <summary>
    /// 移动速度
    /// </summary>
    public float moveSpeed;

    /// <summary>
    /// 力量
    /// </summary>
    public int Strength;

    /// <summary>
    /// 魔力
    /// </summary>
    public int Magic;

    /// <summary>
    /// 防御
    /// </summary>
    public int Defence;

    /// <summary>
    /// 生命
    /// </summary>
    public int HP;

    /// <summary>
    /// 最大生命
    /// </summary>
    public int MaxHP;

    /// <summary>
    /// 最大魔法
    /// </summary>
    public int MaxSP;

    /// <summary>
    /// 等级
    /// </summary>
    public int Level;

    /// <summary>
    /// 魔法
    /// </summary>
    public int SP;

    /// <summary>
    /// 火抗
    /// </summary>
    public int fireResistance;

    /// <summary>
    /// 冰抗
    /// </summary>
    public int iceResistance;

    /// <summary>
    /// 电抗
    /// </summary>
    public int electricityResistance;

    /// <summary>
    /// 毒抗
    /// </summary>
    public int poisonResistance;

    /// <summary>
    /// 火伤加成
    /// </summary>
    public int fireDamage;

    /// <summary>
    /// 冰伤加成
    /// </summary>
    public int iceDamage;

    /// <summary>
    /// 电伤加成
    /// </summary>
    public int electricityDamage;

    /// <summary>
    /// 毒伤加成
    /// </summary>
    public int poisonDamage;

    /// <summary>
    /// 火伤附加
    /// </summary>
    public int fireAppend;

    /// <summary>
    /// 冰伤附加
    /// </summary>
    public int iceAppend;

    /// <summary>
    /// 电伤附加
    /// </summary>
    public int electricityAppend;

    /// <summary>
    /// 毒伤附加
    /// </summary>
    public int poisonAppend;

    /// <summary>
    /// 经验值
    /// </summary>
    public ulong Exp;

    /// <summary>
    /// 升级所需经验值
    /// </summary>
    public ulong NeedExp;

    private CharacterBase() {
    }

    public static T Create<T>(GameObject obj, int id, string name, int level = 1) where T : CharacterBase, new() {
        var staticData = MainStaticDataCenter.instance.roleBaseTable.datalist[id];
        var itemBase = new T();
        if (CreateUniqueId(itemBase)) {
            itemBase.staticData = staticData;

            // 默认添加空手为武器
            ItemAttribute weapon = ItemAttribute.Create<ItemAttribute>(0);
            itemBase.items.Add(weapon);
            itemBase.equips.Add(weapon);

            // 设置名字和等级
            itemBase.charName = name;
            itemBase.Level = level;

            // 初始化满血
            itemBase.HP = 1;
            itemBase.SP = 1;
            itemBase.MaxHP = 1;
            itemBase.MaxSP = 1;

            itemBase.UpdateAttribute();

            return itemBase;
        } else {
            return null;
        }
    }

    public void UpdateAttribute() {
        double hpRate = 1;
        double spRate = 1;
        if (MaxHP <= 0 || HP <= 0) {
            hpRate = 0;
        } else {
            hpRate = HP / MaxHP;
        }
        if (MaxSP <= 0 || SP <= 0) {
            spRate = 0;
        } else {
            spRate = SP / MaxSP;
        }
        ItemAttribute weapon = GetEquipWeapon();
        attackDistance = 1.5f;
        attackSpeed = (float)staticData.speed;
        moveSpeed = (float)staticData.speed;
        Strength = (int)staticData.strength;
        Magic = (int)staticData.magic;
        Defence = (int)staticData.defence;
        MaxHP = (int)staticData.hp;
        MaxSP = (int)staticData.sp;

        fireDamage = (int)staticData.fireDamage;
        iceDamage = (int)staticData.iceDamage;
        electricityDamage = (int)staticData.electricityDamage;
        poisonDamage = (int)staticData.poisonDamage;
        fireAppend = (int)staticData.fireAppend;
        iceAppend = (int)staticData.iceAppend;
        electricityAppend = (int)staticData.electricityAppend;
        poisonAppend = (int)staticData.poisonAppend;
        fireResistance = (int)staticData.fireResistance;
        iceResistance = (int)staticData.iceResistance;
        electricityResistance = (int)staticData.electricityResistance;
        poisonResistance = (int)staticData.poisonResistance;

        skills = new List<SkillData>();

        AddBuffAttribute();
        AddEquipAttribute();

        SP = 0;
        HP = 0;
    }

    private void AddBuffAttribute() {
        //todo
    }

    // 只有武器装备加的攻击距离会生效，其他装备的都不会生效
    // 注意，不要给装备赋予魔力和力量属性，装备属性要在最后计算，因为要计算发挥，需要先结算完其他buff增加的属性
    // 攻击速度等于武器的发挥  攻击距离等于武器的攻击距离
    // 移动速度 等于 力量 * (int)ItemType.EquipEnd / 装备总重量
    private void AddEquipAttribute() {
        double equipWeight = 0;
        double speed = 1;

        foreach (ItemAttribute item in equips) {
            equipWeight += item.weight;

            // 计算重量发挥和能量发挥
            double weightPlay = CalculationPlay(Strength, item.weight, true);
            double energyPlay = CalculationPlay(Magic, item.energy, false);

            if (item.staticData.type == ItemType.Weapon) {
                attackDistance = (float)item.attackDistance;
                attackSpeed = (float)weightPlay;
            }
            Defence += (int)(item.defence * weightPlay);
            MaxHP += (int)(item.hp * weightPlay);
            MaxSP += (int)(item.sp * weightPlay);
            fireDamage += (int)(item.fireDamage * weightPlay);
            iceDamage += (int)(item.iceDamage * weightPlay);
            electricityDamage += (int)(item.electricityDamage * weightPlay);
            poisonDamage += (int)(item.poisonDamage * weightPlay);
            fireAppend += (int)(item.fireAppend * weightPlay);
            iceAppend += (int)(item.iceAppend * weightPlay);
            electricityAppend += (int)(item.electricityAppend * weightPlay);
            poisonAppend += (int)(item.poisonAppend * weightPlay);
            fireResistance += (int)(item.fireResistance * weightPlay);
            iceResistance += (int)(item.iceResistance * weightPlay);
            electricityResistance += (int)(item.electricityResistance * weightPlay);
            poisonResistance += (int)(item.poisonResistance * weightPlay);

            speed += (item.speed * weightPlay);
        }
        attackDistance = (float)(attackDistance * speed);
        attackSpeed = (float)(attackSpeed * speed);
        moveSpeed = (float)(Strength * (int)ItemType.EquipEnd / equipWeight * speed);
    }

    // 计算发挥
    static private double CalculationPlay(double StrengthOrMagic, double WeightOrEnergy, bool calculationWeight) {
        int id = (int)(calculationWeight ? AttrEnum.weightPlay : AttrEnum.energyPlay);
        StaticDataAttrDesEle attrData = MainStaticDataCenter.instance.attrDesTable.datalist[id];
        double min = attrData.minValue;
        double max = attrData.maxValue;
        double value = System.Math.Tanh(StrengthOrMagic / WeightOrEnergy);
        double center = 0.761594155955765; // 0.76
        double result;
        if (value <= center) {
            result = min + 1 / center * value * min;
        } else {
            result = 1 + 1 / (1 - center) * (value - center) * (max - 1);
        }
        return result;
    }

    static private void Test() {
        for (float i = 1; i <= 100; i+=0.5f) {
            double streng = i;
            double magic = 100 - i;
            var v = CalculationPlay(streng, magic, true);
            System.Console.WriteLine(streng +"/" + magic + "=" + v);
        }
    }

    /// <summary>
    /// 获取装备的武器
    /// </summary>
    public ItemAttribute GetEquipWeapon() {
        ItemAttribute weapon = null;
        foreach (var item in equips) {
            if (item.staticData.type == ItemType.Weapon) {
                weapon = item;
                break;
            }
        }
        return weapon;
    }
}