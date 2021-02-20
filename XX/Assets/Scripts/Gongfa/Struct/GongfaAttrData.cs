using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public struct GongfaAttrData
{
    public int id;
    public GongfaType type;
    public string name;
    public string des;
    public bool isSkill; // 是否技能词条
    public RoleAttribute attr; // 如果不是技能，增加属性的类型
    public GongfaSkill skill; // 如果是技能，对应的技能枚举
    public int[][] min_attr; // 第一个索引是保存不同境界的最小随机范围 第二个索引是有些词条会有多个属性变量
    public int[][] max_attr; // 第一个索引是保存不同境界的最大随机范围 第二个索引是有些词条会有多个属性变量
    public float cool;
    public int cost;

    public int[] GetRandomAttr(int lv, int color) {
        int param_count = min_attr.Length;
        int[] resilt = new int[param_count];
        for (int i = 0; i < param_count; i++) {
            float value = Random.Range(min_attr[i][lv], max_attr[i][lv]);
            resilt[i] = (int)Mathf.Ceil(value * (color + 1) / GameConst.max_color);
        }
        return resilt;
    }

    public int[] GetMainAttr(int lv, int color) {
        int param_count = min_attr.Length;
        int[] resilt = new int[param_count];
        for (int i = 0; i < param_count; i++) {
            float value =  max_attr[i][lv];
            resilt[i] = (int)Mathf.Ceil(value * (color + 1) / GameConst.max_color);
        }
        return resilt;
    }
}