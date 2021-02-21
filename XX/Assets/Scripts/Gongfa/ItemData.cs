using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[System.Serializable]
public class ItemData
{
    public int id;
    public int static_id;
    public int count;
    /// <summary>
    /// 物品参数
    /// 对于功法就是学习进度
    /// </summary>
    public int param;
}
