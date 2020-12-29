using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 所有静态配置表的容器
/// </summary>
public class CqmStaticDataCenter : MonoBehaviour //CqmSingleton<CqmStaticDataCenter>
{
    public static string prefabPath = "Assets/Config/prefab/StaticDataCenter.prefab";

    public int loginSceneIdx = -1;
    //所有静态数据表，需要手动一一添加
    HashSet<cqmStaticDataTableBase> allDatas;
    HashSet<cqmStaticDataTableBase> priorDatas;

    //本地化表策划配置
    public CqmStaticDataLocazation locazationTable;

    public IEnumerator InitPriorTables()
    {
        priorDatas = new HashSet<cqmStaticDataTableBase>();
        foreach (cqmStaticDataTableBase tb in priorDatas)
        {
	        if (tb)
		        yield return null;
                tb.Init();
        }
    }

    //手动添加所有表
    public void InitAllTables()
    {
        allDatas = new HashSet<cqmStaticDataTableBase>();
        allDatas.Add(locazationTable);

        foreach (cqmStaticDataTableBase tb in allDatas)
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
        foreach (cqmStaticDataTableBase table in allDatas)
        {
            if(table)
                table.ReportAllAssetsPath(output);
        }
        return output;
    }

    public bool Check()
    {
        bool res = true;

        foreach (cqmStaticDataTableBase table in allDatas)
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
