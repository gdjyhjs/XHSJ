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
                _data.hp = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("sp", (_data, _value) => {
                _data.sp = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("strength", (_data, _value) => {
                _data.strength = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("magic", (_data, _value) => {
                _data.magic = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("speed", (_data, _value) => {
                _data.speed = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("defence", (_data, _value) => {
                _data.defence = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("fireResistance", (_data, _value) => {
                _data.fireResistance = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("iceResistance", (_data, _value) => {
                _data.iceResistance = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("electricityResistance", (_data, _value) => {
                _data.electricityResistance = float.Parse(_value);
                return true;
            });

            RegisterReadingMethod("poisonResistance", (_data, _value) => {
                _data.poisonResistance = float.Parse(_value);
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
