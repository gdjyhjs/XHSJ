using UnityEngine;
using System.Collections;
using UnityEditor;


[CustomEditor(typeof( StaticDataLocazation))]
class  EditStaticDataLocation :  EditStringIDTemplateStaticData< StaticDataLocazationEle>
{
    public class LocaltionParser :  EditStaticDataTemplateParser< StaticDataLocazationEle, string>
    {
        public override void Init()
        {
            base.Init();

            RegisterReadingMethod("CN", (_data, _value) =>
            {
                _data.cn = _value;
                return true;
            });

            RegisterReadingMethod("TWCN", (_data, _value) =>
            {
                _data.twcn = _value;
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
