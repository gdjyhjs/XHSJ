using UnityEngine;
using System.Collections;
using UnityEditor;
using UnityEngine.UI;


[CustomEditor(typeof( StaticDataSkillData))]
class  EditStaticDataSkillData :  EditStringIDTemplateStaticData< StaticDataSkillDataEle>
{
    public class LocaltionParser :  EditStaticDataTemplateParser< StaticDataSkillDataEle, string>
    {
        public override void Init()
        {
            base.Init();

            RegisterReadingMethod("名字", (_data, _value) => {
                _data.name = _value;
                return true;
            });


            RegisterReadingMethod("描述", (_data, _value) => {
                _data.des = _value;
                return true;
            });


            RegisterReadingMethod("冷却", (_data, _value) => {
                _data.cool = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("消耗", (_data, _value) => {
                _data.cost = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("距离", (_data, _value) => {
                _data.distance = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("角度范围", (_data, _value) => {
                _data.attackAngle = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("类型", (_data, _value) => {
                _data.type = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("恢复", (_data, _value) => {
                _data.Recovery = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("伤害", (_data, _value) => {
                _data.damage = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("火伤", (_data, _value) => {
                _data.fireDamage = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("冰伤", (_data, _value) => {
                _data.iceDamage = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("电伤", (_data, _value) => {
                _data.electricityDamage = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("毒伤", (_data, _value) => {
                _data.poisonDamage = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("持续时间", (_data, _value) => {
                _data.durationTime = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("伤害间隔", (_data, _value) => {
                _data.damageInterval = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("下一个技能", (_data, _value) => {
                _data.nextSkillId = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("预制件名字", (_data, _value) => {
                string path = string.Format("Assets/GameRoot/GameEffect/GameEffects/{0}.prefab", _value);
                var target = AssetDatabase.LoadAssetAtPath<GameObject>(path);
                _data.originalPrefab = target;
                return true;
            });


            RegisterReadingMethod("图标", (_data, _value) => {
                string path = string.Format("Assets/GameRoot/Texture/icon/{0}.png", _value);
                var target = AssetDatabase.LoadAssetAtPath<Sprite>(path);
                Debug.Log(path+"="+ target);
                _data.icon = target;
                return true;
            });


            RegisterReadingMethod("动画名称", (_data, _value) => {
                _data.animationName = _value;
                return true;
            });


            RegisterReadingMethod("受击特效预制件", (_data, _value) => {
                string path = string.Format("Assets/GameRoot/GameEffect/GameEffects/{0}.prefab", _value);
                var target = AssetDatabase.LoadAssetAtPath<GameObject>(path);
                _data.hitFxName = target;
                return true;
            });


            RegisterReadingMethod("攻击类型", (_data, _value) => {
                _data.attackType = _value;
                return true;
            });


            RegisterReadingMethod("模式", (_data, _value) => {
                _data.damageMode = _value;
                return true;
            });


            RegisterReadingMethod("召唤物ID", (_data, _value) => {
                _data.SummonId = double.Parse(_value);
                return true;
            });


            RegisterReadingMethod("buffID", (_data, _value) => {
                _data.buffID = double.Parse(_value);
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
