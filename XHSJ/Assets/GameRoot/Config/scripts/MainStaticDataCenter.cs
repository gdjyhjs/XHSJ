using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 所有静态配置表的容器
/// </summary>
public class  MainStaticDataCenter : MonoSingleton< MainStaticDataCenter>
{
    private void Awake() {
        DontDestroyOnLoad(this);
    }

    public static string prefabPath = "Assets/Config/prefab/StaticDataCenter.prefab";

    public int loginSceneIdx = -1;
    //所有静态数据表，需要手动一一添加
    HashSet< StaticDataTableBase> allDatas;
    HashSet< StaticDataTableBase> priorDatas;

    //本地化表策划配置
    public  StaticDataLocazation locazationTable;
    public  StaticDataRoleBase roleBaseTable;
    public StaticDataAttrDes attrDesTable;
    public StaticDataBuff buffTable;
    public StaticDataItem itemTable;
    public StaticDataSkillData skillDataTable;

    public IEnumerator InitPriorTables()
    {
        priorDatas = new HashSet< StaticDataTableBase>();
        foreach ( StaticDataTableBase tb in priorDatas)
        {
	        if (tb)
		        yield return null;
                tb.Init();
        }
    }

    //手动添加所有表
    public void InitAllTables()
    {
        allDatas = new HashSet< StaticDataTableBase>();
        allDatas.Add(locazationTable);

        foreach ( StaticDataTableBase tb in allDatas)
        {
            if (tb)
            {
                if (priorDatas != null && priorDatas.Contains(tb))
                    continue;
                tb.Init();
            }
        }
    }


    //报告所有静态表所依赖的资源路径
    public HashSet<string> ReportAllAssetPaths()
    {
        HashSet<string> output = new HashSet<string>();
        if (allDatas == null) {
            Debug.LogError("Data Tables not initialized");
            return null;
        }
        foreach ( StaticDataTableBase table in allDatas)
        {
            if(table)
                table.ReportAllAssetsPath(output);
        }
        return output;
    }

    public bool Check()
    {
        bool res = true;

        foreach ( StaticDataTableBase table in allDatas)
        {
            if (table)
            {
                res &= table.Check(this);
            }
        }

        return res;
    }

    public IEnumerable AllData()
    {
        return allDatas;
    }
}
