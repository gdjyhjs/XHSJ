using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 静态数据条目基类
/// </summary>
[System.Serializable]
public class CqmStaticData
{
    public virtual void ReportAllAssetsPath(HashSet<string> s)
    {

    }

    public virtual bool Check(List<string> s, CqmStaticDataCenter database)
    {
        return true;
    }

    public virtual string GetIdentifier()
    {
        return string.Empty;
    }
}

/// <summary>
/// 根据ID索引的数据条目
/// </summary>
[System.Serializable]
public class cqmStaticIDData<T> : CqmStaticData
{
    public T Id;

    public override bool Check(List<string> s, CqmStaticDataCenter database)
    {
        return base.Check(s, database);
    }

    public override string GetIdentifier()
    {
        return Id.ToString();
    }
}

[System.Serializable]
public class TableDataPath
{
    //导入表所在路径
    public string dataPath;
    //导入表名
    public string tableName;
}

/// <summary>
/// 静态数据表基类
/// </summary>
public class cqmStaticDataTableBase : MonoBehaviour
{
    public List<TableDataPath> tablePathList;

    //导入表所在路径
    public string dataPath;
    //导入表名
    public string tableName;

    [Tooltip("是否生成 txt")]
    public bool generateTxt;

    //是否初始化成功
    private bool initSuccess;
    public bool InitSuccess
    {
        get { return initSuccess; }
        set { initSuccess = value; }
    }

    //初始化数据表，统一操作
    public void Init()
    {
        OnInit();
    }

    //根据需要，初始化时做不同的操作
    protected virtual void OnInit()
    {

    }

    //打包准备阶段，需要提供所有依赖的资源
    public virtual void ReportAllAssetsPath(HashSet<string> s)
    {
        //LogMgr.LogSection(LogMgr.Section.Editor, this.ToString() + " BeginPacking");
    }

    public virtual bool Check(CqmStaticDataCenter database)
    {
        return true;
    }
}

/// <summary>
/// 静态数据表基类
/// </summary>
public class CqmStaticDataTable<T> : cqmStaticDataTableBase where T : CqmStaticData, new()
{
    //数据存放区，序列化时存储
    public List<T> datalist;
    //xrb
    public List<T> AfterSearchDatalist;

    [Tooltip("被搜索的id")]
    public string searchid;

    //改写接口
    public override void ReportAllAssetsPath(HashSet<string> s)
    {
        base.ReportAllAssetsPath(s);

        foreach (T t in datalist)
        {
            t.ReportAllAssetsPath(s);
        }
    }

    public override bool Check(CqmStaticDataCenter database)
    {
        bool res = InitSuccess;

        foreach (T t in datalist)
        {
            List<string> errList = new List<string>();
            bool localRes = t.Check(errList, database);
            if(!localRes)
            {
                Debug.LogErrorFormat("{0}配置表错误, Id={1}", name, t.GetIdentifier());
                foreach(var err in errList)
                {
                    Debug.LogErrorFormat("错误详情:{0}", err);
                }
            }
            res &= localRes;
        }

        res &= base.Check(database);

        return res;
    }
}


/// <summary>
/// 根据ID索引的数据表
/// </summary>
/// <typeparam name="T"></typeparam>
public class cqmStaticIDDataTable<T, TK> : CqmStaticDataTable<T> where T : cqmStaticIDData<TK>, new()
{
    private Dictionary<TK, T> lookupTable = null;

    //初始化完毕后构建查找表 
    protected override void OnInit()
    {
        base.OnInit();

        lookupTable = new Dictionary<TK, T>(datalist.Count);
        bool initResult = true;
        foreach (T item in datalist)
        {

            //#if UNITY_EDITOR
            //            if (!lookupTable.ContainsKey(item.Id))
            //            {
            //#endif
            try {
                lookupTable.Add(item.Id, item);
            } catch (System.Exception e) {
                Debug.LogErrorFormat(e.Message+"\n"+e.StackTrace);
                Debug.LogErrorFormat("配表重复！！ {1}conflict with id: {0}", item.Id, name);
                throw;
            }
//#if UNITY_EDITOR
//            }
//            else
//            {
//                initResult = false;
//                LogMgr.ErrorParam(LogMgr.Section.General, "{1} conflict with id:{0}", item.Id, name);
                
//            }
//#endif
        }
        InitSuccess = initResult;
    }

    //查找数据
    public T findItemWithId(TK id)
    {
        if (lookupTable == null)
        {
            OnInit();
        }
        if(id == null)
        {
            return null;
        }
        T result = null;
        lookupTable.TryGetValue(id, out result);
        return result;
    }

    /// <summary>
    /// 测试任务临时使用
    /// </summary>
    /// <returns></returns>
    public TK[] GetAllKeys()
    {
        TK[] tk = new TK[lookupTable.Count];
        int index = 0;
        foreach (TK key in lookupTable.Keys)
        {
            tk[index++] = key;
        }
        
        return tk;
    }

    public override bool Check(CqmStaticDataCenter database)
    {
        HashSet<TK> keySet = new HashSet<TK>();
        bool res = true;
        foreach (T item in datalist)
        {
            if(keySet.Contains(item.Id))
            {
                Debug.LogErrorFormat("{0}配置表ID重复, Id={1}", name, item.Id);
                res &= false;
            }
            keySet.Add(item.Id);
        }
        InitSuccess = res;
        /*
        bool pathAvailable = true;
#if UNITY_EDITOR
        string test = "Assets/GameRoot/Level/Map/WldfCt-001-01/WldfCt-001-01";
        HashSet<string> assetPath = new HashSet<string>();
        ReportAllAssetsPath(assetPath);
        foreach (var s in assetPath)
        {
            if (string.IsNullOrEmpty(s))
            {
                continue;
            }
            if (System.IO.Directory.Exists(s))
            {
                LogMgr.ErrorParam(LogMgr.Section.Editor, "asset is directory:{0} in table {1}", s, name);
                continue;
            }
            if(s==test)
            {
                LogMgr.ErrorParam(LogMgr.Section.Editor, "test found:{0}", name);
            }
            Object o = UnityEditor.AssetDatabase.LoadAssetAtPath<Object>(s);
            if (o == null)
            {
                pathAvailable = false;
                LogMgr.ErrorParam(LogMgr.Section.Editor, "asset not exist:{0} in table {1}", s, name);
                continue;
            }
            var d = UnityEditor.AssetDatabase.GetDependencies(s);
            foreach (var sd in d)
            {
                if (System.IO.Directory.Exists(sd))
                {
                    LogMgr.ErrorParam(LogMgr.Section.Editor, "asset is directory:{0} in table {1} dep {2}", sd, name, s);
                    continue;
                }
                if (sd == test)
                {
                    LogMgr.ErrorParam(LogMgr.Section.Editor, "test found:{0} dep {1}", name, s);
                }
                Object o2 = UnityEditor.AssetDatabase.LoadAssetAtPath<Object>(sd);
                if (o2 == null)
                {
                    pathAvailable = false;
                    LogMgr.ErrorParam(LogMgr.Section.Editor, "asset not exist:{0} in table {1} dep {2}", sd, name, s);
                }
            }
        }
#endif
    */
        return base.Check(database) && res/* && pathAvailable*/;
    }
}

public interface HasKey2<TK2>
{
    TK2 GetKey2();
}

[System.Serializable]
public class cqmLookupGroup<T, TK, TK2> where T: cqmStaticIDData<TK>, HasKey2<TK2>, new()
{
    public TK2 groupId;
    public List<T> groupedElements;
}

public class cqmAddtionalLookupGroup<T, TK, TK2>  where T : cqmStaticIDData<TK>, HasKey2<TK2>, new()    
{
    [SerializeField]
    public cqmLookupGroup<T, TK, TK2>[] groups;
    private Dictionary<TK2, cqmLookupGroup<T, TK, TK2>> lookupTable=null;

    public bool Init()
    {
        bool res = true;
        foreach(var g in groups)
        {
            if(lookupTable.ContainsKey(g.groupId))
            {
                res = false;
                Debug.LogErrorFormat("lookup table key conflicted: {0}", g.groupId);
            }
            else
            {
                lookupTable.Add(g.groupId, g);
            }
        }
        return res;
    }

    public bool ReciveList(List<T> dataList)
    {
        lookupTable.Clear();
        groups = null;
        lookupTable = new Dictionary<TK2, cqmLookupGroup<T, TK, TK2>>();
        foreach(var data in dataList)
        {
            TK2 k2 = data.GetKey2();
            cqmLookupGroup<T, TK, TK2> g = null;

            if (!lookupTable.TryGetValue(k2, out g))
            {
                g = new cqmLookupGroup<T, TK, TK2>();
                lookupTable.Add(k2, g);
                g.groupId = k2;
            }

            g.groupedElements.Add(data);
        }
        groups = lookupTable.Values.KToArray();
        return true;
    }
}