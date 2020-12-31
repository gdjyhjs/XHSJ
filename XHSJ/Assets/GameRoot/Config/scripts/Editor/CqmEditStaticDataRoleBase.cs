using UnityEngine;
using System.Collections;
using UnityEditor;


[CustomEditor(typeof(CqmStaticDataRoleBase))]
class CqmEditStaticDataRoleBase : CqmEditStringIDTemplateStaticData<CqmStaticDataRoleBaseEle>
{
    public class LocaltionParser : CqmEditStaticDataTemplateParser<CqmStaticDataRoleBaseEle, string>
    {
        public override void Init()
        {
            base.Init();

            RegisterReadingMethod("des", (_data, _value) =>
            {
                _data.des = _value;
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
