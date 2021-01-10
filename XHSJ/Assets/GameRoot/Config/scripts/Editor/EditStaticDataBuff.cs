using UnityEngine;
using System.Collections;
using UnityEditor;


[CustomEditor(typeof( StaticDataBuff))]
class  EditStaticDataBuff :  EditStringIDTemplateStaticData< StaticDataBuffEle>
{
    public class LocaltionParser :  EditStaticDataTemplateParser< StaticDataBuffEle, string>
    {
        public override void Init()
        {
            /*
name	des	maxLayer	damage	fireDamage	iceDamage	electricityDamage	poisonDamage	durationTime	damageInterval	updamage	upspeed	backMove	lockAnim	hp	type
名字	描述	最大叠加层数	伤害	冰伤	火伤	电伤	毒伤	持续时间	伤害间隔	提升伤害	提升速度	位移	锁定动画	生命	类型

    */
            base.Init();

            RegisterReadingMethod("名字", (_data, _value) => {
                _data.name = _value;
                return true;
            });

            RegisterReadingMethod("描述", (_data, _value) => {
                _data.des = _value;
                return true;
            });

            RegisterReadingMethod("最大叠加层数", (_data, _value) => {
                _data.maxLayer = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("伤害", (_data, _value) => {
                _data.damage = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("冰伤", (_data, _value) => {
                _data.fireDamage = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("火伤", (_data, _value) => {
                _data.iceDamage = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("电伤", (_data, _value) => {
                _data.electricityDamage = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("毒伤", (_data, _value) => {
                _data.poisonDamage = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("持续时间", (_data, _value) => {
                _data.durationTime = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("伤害间隔", (_data, _value) => {
                _data.damageInterval = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("提升伤害", (_data, _value) => {
                _data.updamage = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("提升速度", (_data, _value) => {
                _data.upspeed = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("位移", (_data, _value) => {
                _data.backMove = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("锁定动画", (_data, _value) => {
                _data.lockAnim = _value;
                return true;
            });

            RegisterReadingMethod("生命", (_data, _value) => {
                _data.hp = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("类型", (_data, _value) => {
                _data.type = _value;
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
