using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[SerializeField]
public class ItemBase: UniqueIdObject<ItemBase> {
    /// <summary>
    /// 通用物品 {配置表的id，实例化的唯一uid}
    /// </summary>
    public static Dictionary<int, uint> comItems = new Dictionary<int, uint>();
    public StaticDataItemEle staticData;
    public float hp;
    public float sp;
    public float strength;
    public float magic;
    public float speed;
    public float defence;
    public float fireResistance;
    public float iceResistance;
    public float electricityResistance;
    public float poisonResistance;
    public float attackDistance;
    public float energy;
    public float weight;
    public float fireDamage;
    public float iceDamage;
    public float electricityDamage;
    public float poisonDamage;
    public float fireAppend;
    public float iceAppend;
    public float electricityAppend;
    public float poisonAppend;

    public static ItemBase Create(int staticId) {
        var staticData = MainStaticDataCenter.instance.itemTable.findItemWithId(staticId.ToString());
        if (staticData.universal) {
            return CreateCommon(staticId);
        }

        var itemBase = new ItemBase();
        uint uid = GetUniqueId();
        if (uid > 0) {
            itemBase.staticData = staticData;
            itemBase.uid = uid;
            itemBase.hp = Random.Range(staticData.min_hp, staticData.max_hp + 1);
            itemBase.sp = Random.Range(staticData.min_sp, staticData.max_sp + 1);
            itemBase.strength = Random.Range(staticData.min_strength, staticData.max_strength + 1);
            itemBase.magic = Random.Range(staticData.min_magic, staticData.max_magic + 1);
            itemBase.speed = Random.Range(staticData.min_speed, staticData.max_speed + 1);
            itemBase.defence = Random.Range(staticData.min_defence, staticData.max_defence + 1);
            itemBase.fireResistance = Random.Range(staticData.min_fireResistance, staticData.max_fireResistance + 1);
            itemBase.iceResistance = Random.Range(staticData.min_iceResistance, staticData.max_iceResistance + 1);
            itemBase.electricityResistance = Random.Range(staticData.min_electricityResistance, staticData.max_electricityResistance + 1);
            itemBase.poisonResistance = Random.Range(staticData.min_poisonResistance, staticData.max_poisonResistance + 1);
            itemBase.attackDistance = Random.Range(staticData.min_attackDistance, staticData.max_attackDistance + 1);
            itemBase.energy = Random.Range(staticData.min_energy, staticData.max_energy + 1);
            itemBase.weight = Random.Range(staticData.min_weight, staticData.max_weight + 1);
            itemBase.fireDamage = Random.Range(staticData.min_fireDamage, staticData.max_fireDamage + 1);
            itemBase.iceDamage = Random.Range(staticData.min_iceDamage, staticData.max_iceDamage + 1);
            itemBase.electricityDamage = Random.Range(staticData.min_electricityDamage, staticData.max_electricityDamage + 1);
            itemBase.poisonDamage = Random.Range(staticData.min_poisonDamage, staticData.max_poisonDamage + 1);
            itemBase.fireAppend = Random.Range(staticData.min_fireAppend, staticData.max_fireAppend + 1);
            itemBase.iceAppend = Random.Range(staticData.min_iceAppend, staticData.max_iceAppend + 1);
            itemBase.electricityAppend = Random.Range(staticData.min_electricityAppend, staticData.max_electricityAppend + 1);
            itemBase.poisonAppend = Random.Range(staticData.min_poisonAppend, staticData.max_poisonAppend + 1);
            return itemBase;
        } else {
            return null;
        }
    }

    public static void LoadItem(string statitId, uint uid, params float[] data){
        var staticData = MainStaticDataCenter.instance.itemTable.findItemWithId(statitId);
        var itemBase = new ItemBase();
        uid = GetUniqueId(uid);
        if (uid > 0) {
            itemBase.staticData = staticData;
            itemBase.uid = uid;
            itemBase.hp = data[0];
            itemBase.sp = data[1];
            itemBase.strength = data[2];
            itemBase.magic = data[3];
            itemBase.speed = data[4];
            itemBase.defence = data[5];
            itemBase.fireResistance = data[6];
            itemBase.iceResistance = data[7];
            itemBase.electricityResistance = data[8];
            itemBase.poisonResistance = data[9];
            itemBase.attackDistance = data[10];
            itemBase.energy = data[11];
            itemBase.weight = data[12];
            itemBase.fireDamage = data[13];
            itemBase.iceDamage = data[14];
            itemBase.electricityDamage = data[15];
            itemBase.poisonDamage = data[16];
            itemBase.fireAppend = data[17];
            itemBase.iceAppend = data[18];
            itemBase.electricityAppend = data[19];
            itemBase.poisonAppend = data[20];
        }
    }

    private static ItemBase CreateCommon(int id){
        if (comItems.ContainsKey(id)) {
            uint item_uid = comItems[id];
            return ItemBase.depot[item_uid];
        }

        var staticData = MainStaticDataCenter.instance.itemTable.findItemWithId(id.ToString());
        var itemBase = new ItemBase();
        uint uid = GetUniqueId();
        if (uid > 0) {
            itemBase.staticData = staticData;
            itemBase.uid = uid;
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

    public static void CreateAllCommonItem() {
        List<StaticDataItemEle> data = MainStaticDataCenter.instance.itemTable.datalist;
        foreach (var item in data) {
            if (item.universal) {
                CreateCommon(int.Parse(item.Id));
            }
        }
    }
}
