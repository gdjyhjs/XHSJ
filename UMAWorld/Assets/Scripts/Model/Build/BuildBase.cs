using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 建筑基础
/// </summary>
public class BuildBase : MonoBehaviour {
    public bool isInit; // 是否初始化
    /// <summary>
    /// 领土区域顶点坐标
    /// </summary>
    Vector2[] points;

    public void Init() {
        if (!isInit) {
            isInit = true;
        }
    }



}
