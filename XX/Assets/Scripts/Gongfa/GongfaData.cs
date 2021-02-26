using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[System.Serializable]
public class GongfaData {
    /// <summary>
    /// 对应功法物品id
    /// </summary>
    public int item_id;
    /// <summary>
    /// 主属性词条属性值
    /// </summary>
    public int[][] attr_value;
    /// <summary>
    /// 词条属性数值
    /// </summary>
    public int[][] ex_values;
    /// <summary>
    /// 词条属性品质
    /// </summary>
    public int[] ex_color;
    /// <summary>
    /// 修炼经验
    /// </summary>
    public int exp;
}
