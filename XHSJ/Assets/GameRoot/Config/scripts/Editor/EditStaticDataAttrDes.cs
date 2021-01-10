using UnityEngine;
using System.Collections;
using UnityEditor;


[CustomEditor(typeof( StaticDataAttrDes))]
class  EditStaticDataAttrDes :  EditStringIDTemplateStaticData< StaticDataAttrDesEle>
{
    public class LocaltionParser :  EditStaticDataTemplateParser< StaticDataAttrDesEle, string>
    {
        public override void Init()
        {
            base.Init();

            RegisterReadingMethod("属性", (_data, _value) =>
            {
                _data.attr = _value;
                return true;
            });

            RegisterReadingMethod("名字", (_data, _value) =>
            {
                _data.name = _value;
                return true;
            });

            RegisterReadingMethod("描述", (_data, _value) => {
                _data.des = _value;
                return true;
            });

            RegisterReadingMethod("最小值", (_data, _value) => {
                _data.minValue = float.Parse( _value);
                return true;
            });

            RegisterReadingMethod("最大值", (_data, _value) => {
                _data.maxValue = float.Parse(_value);
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
