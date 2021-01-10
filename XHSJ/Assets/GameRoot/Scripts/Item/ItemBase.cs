using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ItemBase: UniqueIdObject<ItemBase> {
    /// <summary>
    /// 通用物品 {配置表的id，实例化的唯一uid}
    /// </summary>
    public static Dictionary<int, uint> comItems = new Dictionary<int, uint>();
    public StaticDataItemEle staticData;
    public double hp;
    public double sp;
    public double strength;
    public double magic;
    public double speed;
    public double defence;
    public double fireResistance;
    public double iceResistance;
    public double electricityResistance;
    public double poisonResistance;
    public double attackDistance;
    public double energy;
    public double weight;
    public double fireDamage;
    public double iceDamage;
    public double electricityDamage;
    public double poisonDamage;
    public double fireAppend;
    public double iceAppend;
    public double electricityAppend;
    public double poisonAppend;

    public static T Create<T>(int staticId) where T: ItemBase,new() {
        var staticData = MainStaticDataCenter.instance.itemTable.datalist[staticId];
        var itemBase = new T();
        uint uid = GetUniqueId();
        if (uid > 0) {
            itemBase.hp = Random.Range((float)staticData.min_hp, (float)staticData.max_hp + 1);
            itemBase.sp = Random.Range((float)staticData.min_sp, (float)staticData.max_sp + 1);
            itemBase.strength = Random.Range((float)staticData.min_strength, (float)staticData.max_strength + 1);
            itemBase.magic = Random.Range((float)staticData.min_magic, (float)staticData.max_magic + 1);
            itemBase.speed = Random.Range((float)staticData.min_speed, (float)staticData.max_speed + 1);
            itemBase.defence = Random.Range((float)staticData.min_defence, (float)staticData.max_defence + 1);
            itemBase.fireResistance = Random.Range((float)staticData.min_fireResistance, (float)staticData.max_fireResistance + 1);
            itemBase.iceResistance = Random.Range((float)staticData.min_iceResistance, (float)staticData.max_iceResistance + 1);
            itemBase.electricityResistance = Random.Range((float)staticData.min_electricityResistance, (float)staticData.max_electricityResistance + 1);
            itemBase.poisonResistance = Random.Range((float)staticData.min_poisonResistance, (float)staticData.max_poisonResistance + 1);
            itemBase.attackDistance = Random.Range((float)staticData.min_attackDistance, (float)staticData.max_attackDistance + 1);
            itemBase.energy = Random.Range((float)staticData.min_energy, (float)staticData.max_energy + 1);
            itemBase.weight = Random.Range((float)staticData.min_weight, (float)staticData.max_weight + 1);
            itemBase.fireDamage = Random.Range((float)staticData.min_fireDamage, (float)staticData.max_fireDamage + 1);
            itemBase.iceDamage = Random.Range((float)staticData.min_iceDamage, (float)staticData.max_iceDamage + 1);
            itemBase.electricityDamage = Random.Range((float)staticData.min_electricityDamage, (float)staticData.max_electricityDamage + 1);
            itemBase.poisonDamage = Random.Range((float)staticData.min_poisonDamage, (float)staticData.max_poisonDamage + 1);
            itemBase.fireAppend = Random.Range((float)staticData.min_fireAppend, (float)staticData.max_fireAppend + 1);
            itemBase.iceAppend = Random.Range((float)staticData.min_iceAppend, (float)staticData.max_iceAppend + 1);
            itemBase.electricityAppend = Random.Range((float)staticData.min_electricityAppend, (float)staticData.max_electricityAppend + 1);
            itemBase.poisonAppend = Random.Range((float)staticData.min_poisonAppend, (float)staticData.max_poisonAppend + 1);
            return itemBase;
        } else {
            return null;
        }
    }

    public static T CreateCommon<T>(int id) where T : ItemBase, new() {
        if (comItems.ContainsKey(id)) {
            return ItemBase.Instance.depot[comItems[id]] as T;
        }

        var staticData = MainStaticDataCenter.instance.itemTable.datalist[id];
        var itemBase = new T();
        uint uid = GetUniqueId();
        if (uid > 0) {
            itemBase.hp =staticData.min_hp;
            itemBase.sp = staticData.min_sp;
            itemBase.strength = staticData.min_strength;
            itemBase.magic = staticData.min_magic;
            itemBase.speed = staticData.min_speed;
            itemBase.defence = staticData.min_defence;
            itemBase.fireResistance = staticData.min_fireResistance;
            itemBase.iceResistance = staticData.min_iceResistance;
            itemBase.electricityResistance = staticData.min_electricityResistance;
            itemBase.poisonResistance = staticData.min_poisonResistance;
            itemBase.attackDistance = staticData.min_attackDistance;
            itemBase.energy = staticData.min_energy;
            itemBase.weight = staticData.min_weight;
            itemBase.fireDamage = staticData.min_fireDamage;
            itemBase.iceDamage = staticData.min_iceDamage;
            itemBase.electricityDamage = staticData.min_electricityDamage;
            itemBase.poisonDamage = staticData.min_poisonDamage;
            itemBase.fireAppend = staticData.min_fireAppend;
            itemBase.iceAppend = staticData.min_iceAppend;
            itemBase.electricityAppend = staticData.min_electricityAppend;
            itemBase.poisonAppend = staticData.min_poisonAppend;
            return itemBase;
        } else {
            return null;
        }
    }

}
