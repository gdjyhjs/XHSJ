using UnityEngine;
using System.Collections;
using UnityEditor;


[CustomEditor(typeof( StaticDataRoleBase))]
class  EditStaticDataRoleBase :  EditStringIDTemplateStaticData< StaticDataRoleBaseEle>
{
    public class LocaltionParser :  EditStaticDataTemplateParser< StaticDataRoleBaseEle, string>
    {
        public override void Init()
        {
            base.Init();

            RegisterReadingMethod("des", (_data, _value) =>
            {
                _data.des = _value;
                return true;
            });

            RegisterReadingMethod("hp", (_data, _value) => {
                _data.hp = double.Parse(_value);
                return true;
            });

            RegisterReadingMethod("sp", (_data, _value) => {
                _data.sp = double.Parse(_value);
                return true;
            });

            RegisterReadingMethod("strength", (_data, _value) => {
                _data.strength = double.Parse(_value);
                return true;
            });

            RegisterReadingMethod("magic", (_data, _value) => {
                _data.magic = double.Parse(_value);
                return true;
            });

            RegisterReadingMethod("speed", (_data, _value) => {
                _data.speed = double.Parse(_value);
                return true;
            });

            RegisterReadingMethod("defence", (_data, _value) => {
                _data.defence = double.Parse(_value);
                return true;
            });

            RegisterReadingMethod("fireResistance", (_data, _value) => {
                _data.fireResistance = double.Parse(_value);
                return true;
            });

            RegisterReadingMethod("iceResistance", (_data, _value) => {
                _data.iceResistance = double.Parse(_value);
                return true;
            });

            RegisterReadingMethod("electricityResistance", (_data, _value) => {
                _data.electricityResistance = double.Parse(_value);
                return true;
            });

            RegisterReadingMethod("poisonResistance", (_data, _value) => {
                _data.poisonResistance = double.Parse(_value);
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
