using UnityEngine;
using System.Collections;
using UnityEditor;


[CustomEditor(typeof(StaticDataItem))]
class EditStaticDataItem : EditStringIDTemplateStaticData<StaticDataItemEle> {
    public class LocaltionParser : EditStaticDataTemplateParser<StaticDataItemEle, string> {
        public override void Init() {
            base.Init();

            /*
name	des	type	hp	sp	strength	magic	speed	defence	fireResistance	iceResistance	electricityResistance	poisonResistance	attackDistance	energy	weight	fireDamage	iceDamage	electricityDamage	poisonDamage	fireAppend	iceAppend	electricityAppend	poisonAppend    
物品名称	物品描述	类型	血量	法力	力量	魔力	速度	防御	火抗	冰抗	电抗	毒抗	攻击距离	能量	重量	火焰伤害	冰冻伤害	闪电伤害	剧毒伤害	火焰附加	冰冻附加	闪电附加	毒素附加    

             * */

            RegisterReadingMethod("物品名称", (_data, _value) => {
                _data.name = _value;
                return true;
            });
            RegisterReadingMethod("物品描述", (_data, _value) => {
                _data.des = _value;
                return true;
            });
            RegisterReadingMethod("类型", (_data, _value) => {
                _data.type = (ItemType)int.Parse(_value);
                return true;
            });
            RegisterReadingMethod("血量", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_hp = float.Parse(value[0]);
                    _data.max_hp = float.Parse(value[1]);
                } else {
                    _data.min_hp = float.Parse(value[0]);
                    _data.max_hp = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("法力", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_sp = float.Parse(value[0]);
                    _data.max_sp = float.Parse(value[1]);
                } else {
                    _data.min_sp = float.Parse(value[0]);
                    _data.max_sp = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("力量", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_strength = float.Parse(value[0]);
                    _data.max_strength = float.Parse(value[1]);
                } else {
                    _data.min_strength = float.Parse(value[0]);
                    _data.max_strength = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("魔力", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_magic = float.Parse(value[0]);
                    _data.max_magic = float.Parse(value[1]);
                } else {
                    _data.min_magic = float.Parse(value[0]);
                    _data.max_magic = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("速度", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_speed = float.Parse(value[0]);
                    _data.max_speed = float.Parse(value[1]);
                } else {
                    _data.min_speed = float.Parse(value[0]);
                    _data.max_speed = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("防御", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_defence = float.Parse(value[0]);
                    _data.max_defence = float.Parse(value[1]);
                } else {
                    _data.min_defence = float.Parse(value[0]);
                    _data.max_defence = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("火抗", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_fireResistance = float.Parse(value[0]);
                    _data.max_fireResistance = float.Parse(value[1]);
                } else {
                    _data.min_fireResistance = float.Parse(value[0]);
                    _data.max_fireResistance = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("冰抗", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_iceResistance = float.Parse(value[0]);
                    _data.max_iceResistance = float.Parse(value[1]);
                } else {
                    _data.min_iceResistance = float.Parse(value[0]);
                    _data.max_iceResistance = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("电抗", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_electricityResistance = float.Parse(value[0]);
                    _data.max_electricityResistance = float.Parse(value[1]);
                } else {
                    _data.min_electricityResistance = float.Parse(value[0]);
                    _data.max_electricityResistance = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("毒抗", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_poisonResistance = float.Parse(value[0]);
                    _data.max_poisonResistance = float.Parse(value[1]);
                } else {
                    _data.min_poisonResistance = float.Parse(value[0]);
                    _data.max_poisonResistance = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("攻击距离", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_attackDistance = float.Parse(value[0]);
                    _data.max_attackDistance = float.Parse(value[1]);
                } else {
                    _data.min_attackDistance = float.Parse(value[0]);
                    _data.max_attackDistance = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("能量", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_energy = float.Parse(value[0]);
                    _data.max_energy = float.Parse(value[1]);
                } else {
                    _data.min_energy = float.Parse(value[0]);
                    _data.max_energy = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("重量", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_weight = float.Parse(value[0]);
                    _data.max_weight = float.Parse(value[1]);
                } else {
                    _data.min_weight = float.Parse(value[0]);
                    _data.max_weight = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("火焰伤害", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_fireDamage = float.Parse(value[0]);
                    _data.max_fireDamage = float.Parse(value[1]);
                } else {
                    _data.min_fireDamage = float.Parse(value[0]);
                    _data.max_fireDamage = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("冰冻伤害", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_iceDamage = float.Parse(value[0]);
                    _data.max_iceDamage = float.Parse(value[1]);
                } else {
                    _data.min_iceDamage = float.Parse(value[0]);
                    _data.max_iceDamage = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("闪电伤害", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_electricityDamage = float.Parse(value[0]);
                    _data.max_electricityDamage = float.Parse(value[1]);
                } else {
                    _data.min_electricityDamage = float.Parse(value[0]);
                    _data.max_electricityDamage = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("剧毒伤害", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_poisonDamage = float.Parse(value[0]);
                    _data.max_poisonDamage = float.Parse(value[1]);
                } else {
                    _data.min_poisonDamage = float.Parse(value[0]);
                    _data.max_poisonDamage = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("火焰附加", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_fireAppend = float.Parse(value[0]);
                    _data.max_fireAppend = float.Parse(value[1]);
                } else {
                    _data.min_fireAppend = float.Parse(value[0]);
                    _data.max_fireAppend = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("冰冻附加", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_iceAppend = float.Parse(value[0]);
                    _data.max_iceAppend = float.Parse(value[1]);
                } else {
                    _data.min_iceAppend = float.Parse(value[0]);
                    _data.max_iceAppend = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("闪电附加", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_electricityAppend = float.Parse(value[0]);
                    _data.max_electricityAppend = float.Parse(value[1]);
                } else {
                    _data.min_electricityAppend = float.Parse(value[0]);
                    _data.max_electricityAppend = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("毒素附加", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_poisonAppend = float.Parse(value[0]);
                    _data.max_poisonAppend = float.Parse(value[1]);
                } else {
                    _data.min_poisonAppend = float.Parse(value[0]);
                    _data.max_poisonAppend = float.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("通用的", (_data, _value) => {

                _data.universal = _value == "1" ? true : false;
                return true;
            });
        }
    }

    protected override void OnInit() {
        //ID解析已在此注册
        base.OnInit();

        //添加自己的解析器
        AddParser<LocaltionParser>();
    }
}