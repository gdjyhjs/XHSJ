using UnityEngine;
using System.Collections;
using UnityEditor;


[CustomEditor(typeof( StaticDataItem))]
class  EditStaticDataItem :  EditStringIDTemplateStaticData< StaticDataItemEle>
{
    public class LocaltionParser :  EditStaticDataTemplateParser< StaticDataItemEle, string>
    {
        public override void Init()
        {
            base.Init();

            /*
name	des	type	hp	sp	strength	magic	speed	defence	fireResistance	iceResistance	electricityResistance	poisonResistance	attackDistance	energy	weight	fireDamage	iceDamage	electricityDamage	poisonDamage	fireAppend	iceAppend	electricityAppend	poisonAppend    
物品名称	物品描述	类型	血量	法力	力量	魔力	速度	防御	火抗	冰抗	电抗	毒抗	攻击距离	能量	重量	火焰伤害	冰冻伤害	闪电伤害	剧毒伤害	火焰附加	冰冻附加	闪电附加	毒素附加    

             * */

            RegisterReadingMethod("物品名称", (_data, _value) =>
            {
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
                    _data.min_hp = double.Parse(value[0]);
                    _data.max_hp = double.Parse(value[1]);
                } else {
                    _data.min_hp = double.Parse(value[0]);
                    _data.max_hp = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("法力", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_sp = double.Parse(value[0]);
                    _data.max_sp = double.Parse(value[1]);
                } else {
                    _data.min_sp = double.Parse(value[0]);
                    _data.max_sp = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("力量", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_strength = double.Parse(value[0]);
                    _data.max_strength = double.Parse(value[1]);
                } else {
                    _data.min_strength = double.Parse(value[0]);
                    _data.max_strength = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("魔力", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_magic = double.Parse(value[0]);
                    _data.max_magic = double.Parse(value[1]);
                } else {
                    _data.min_magic = double.Parse(value[0]);
                    _data.max_magic = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("速度", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_speed = double.Parse(value[0]);
                    _data.max_speed = double.Parse(value[1]);
                } else {
                    _data.min_speed = double.Parse(value[0]);
                    _data.max_speed = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("防御", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_defence = double.Parse(value[0]);
                    _data.max_defence = double.Parse(value[1]);
                } else {
                    _data.min_defence = double.Parse(value[0]);
                    _data.max_defence = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("火抗", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_fireResistance = double.Parse(value[0]);
                    _data.max_fireResistance = double.Parse(value[1]);
                } else {
                    _data.min_fireResistance = double.Parse(value[0]);
                    _data.max_fireResistance = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("冰抗", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_iceResistance = double.Parse(value[0]);
                    _data.max_iceResistance = double.Parse(value[1]);
                } else {
                    _data.min_iceResistance = double.Parse(value[0]);
                    _data.max_iceResistance = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("电抗", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_electricityResistance = double.Parse(value[0]);
                    _data.max_electricityResistance = double.Parse(value[1]);
                } else {
                    _data.min_electricityResistance = double.Parse(value[0]);
                    _data.max_electricityResistance = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("毒抗", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_poisonResistance = double.Parse(value[0]);
                    _data.max_poisonResistance = double.Parse(value[1]);
                } else {
                    _data.min_poisonResistance = double.Parse(value[0]);
                    _data.max_poisonResistance = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("攻击距离", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_attackDistance = double.Parse(value[0]);
                    _data.max_attackDistance = double.Parse(value[1]);
                } else {
                    _data.min_attackDistance = double.Parse(value[0]);
                    _data.max_attackDistance = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("能量", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_energy = double.Parse(value[0]);
                    _data.max_energy = double.Parse(value[1]);
                } else {
                    _data.min_energy = double.Parse(value[0]);
                    _data.max_energy = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("重量", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_weight = double.Parse(value[0]);
                    _data.max_weight = double.Parse(value[1]);
                } else {
                    _data.min_weight = double.Parse(value[0]);
                    _data.max_weight = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("火焰伤害", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_fireDamage = double.Parse(value[0]);
                    _data.max_fireDamage = double.Parse(value[1]);
                } else {
                    _data.min_fireDamage = double.Parse(value[0]);
                    _data.max_fireDamage = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("冰冻伤害", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_iceDamage = double.Parse(value[0]);
                    _data.max_iceDamage = double.Parse(value[1]);
                } else {
                    _data.min_iceDamage = double.Parse(value[0]);
                    _data.max_iceDamage = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("闪电伤害", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_electricityDamage = double.Parse(value[0]);
                    _data.max_electricityDamage = double.Parse(value[1]);
                } else {
                    _data.min_electricityDamage = double.Parse(value[0]);
                    _data.max_electricityDamage = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("剧毒伤害", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_poisonDamage = double.Parse(value[0]);
                    _data.max_poisonDamage = double.Parse(value[1]);
                } else {
                    _data.min_poisonDamage = double.Parse(value[0]);
                    _data.max_poisonDamage = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("火焰附加", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_fireAppend = double.Parse(value[0]);
                    _data.max_fireAppend = double.Parse(value[1]);
                } else {
                    _data.min_fireAppend = double.Parse(value[0]);
                    _data.max_fireAppend = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("冰冻附加", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_iceAppend = double.Parse(value[0]);
                    _data.max_iceAppend = double.Parse(value[1]);
                } else {
                    _data.min_iceAppend = double.Parse(value[0]);
                    _data.max_iceAppend = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("闪电附加", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_electricityAppend = double.Parse(value[0]);
                    _data.max_electricityAppend = double.Parse(value[1]);
                } else {
                    _data.min_electricityAppend = double.Parse(value[0]);
                    _data.max_electricityAppend = double.Parse(value[0]);
                }
                return true;
            });
            RegisterReadingMethod("毒素附加", (_data, _value) => {

                string[] value = _value.Split('-');
                if (value.Length == 2) {
                    _data.min_poisonAppend = double.Parse(value[0]);
                    _data.max_poisonAppend = double.Parse(value[1]);
                } else {
                    _data.min_poisonAppend = double.Parse(value[0]);
                    _data.max_poisonAppend = double.Parse(value[0]);
                }
                return true;
            });
        }
    }

    protected override void OnInit()
    {
        //ID解析已在此注册
        base.OnInit();

        //添加自己的解析器
        AddParser<LocaltionParser>();
    }
}
