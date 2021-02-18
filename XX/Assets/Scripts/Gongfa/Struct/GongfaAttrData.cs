using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public struct GongfaAttrData
{
    public int id;
    public GongfaType type;
    public string name;
    public string des;
    public RoleAttribute attr; // 增加的属性类型
    public int[][] min_attr; // 保存不同境界的最小随机范围
    public int[][] max_attr; // 保存不同境界的最大随机范围

    public int[] GetRandomAttr(int lv, int color) {
        int param_count = min_attr.Length;
        int[] resilt = new int[param_count];
        for (int i = 0; i < param_count; i++) {
            float value = Random.Range(min_attr[i][lv], min_attr[i][lv]);
            resilt[i] = (int)Mathf.Ceil(value * (color + 1) / GameConst.max_color);
        }
        return resilt;
    }
}