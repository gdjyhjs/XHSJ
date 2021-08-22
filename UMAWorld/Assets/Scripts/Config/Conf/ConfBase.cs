using System.Linq;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConfBaseItem
{
    public int id;
    public bool isVariant;

    public ConfBaseItem CloneBase()
    {
        return MemberwiseClone() as ConfBaseItem;
    }
}

public class ConfBase
{
    public bool isTryGetIDError;
    public string confName;

    public ReturnAction<ConfBaseItem, int> onGetItemObjectHandler = null;

    public List<ConfBaseItem> allConfBase;
    private Dictionary<int, ConfBaseItem> allConfDic = new Dictionary<int, ConfBaseItem>();

    public System.Action onInitCall;

    public virtual void Init()
    {

    }

    public virtual void InitEnd()
    {
        for (int i = 0; i < allConfBase.Count; i++)
        {
            AddItem(allConfBase[i].id, allConfBase[i]);
        }
    }

    public virtual void OnInit()
    {
    }

    //添加Item
    public virtual void AddItem(int id, ConfBaseItem item)
    {
        if (allConfDic.ContainsKey(id))
        {
            UnityEngine.Debug.LogError(confName + "表ID重复：" + id);
        }
        allConfDic[id] = item;
    }

    //获取Item
    public virtual T GetItemObject<T>(int id) where T : ConfBaseItem
    {
        ConfBaseItem t = null;

        t = onGetItemObjectHandler?.Invoke(id);
        if (t != null)
        {
            return t as T;
        }

        allConfDic.TryGetValue(id, out t);

        if (isTryGetIDError && t == null)
        {
            Debug.Log(GetType().Name + "：找不到ID " + id);
        }

        return t as T;
    }
}