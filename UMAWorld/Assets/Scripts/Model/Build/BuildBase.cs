using Newtonsoft.Json;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 建筑基础
/// </summary>
public class BuildBase {
    /// <summary>
    /// 领土区域顶点坐标
    /// </summary>
    [JsonIgnore]
    public Vector2[] points
    {
        get
        {
            if (m_points == null) {
                m_points = new Vector2[points_x.Length];
                for (int i = 0; i < points_x.Length; i++) {
                    m_points[i] = new Vector2(points_x[i], points_y[i]);
                }
            }
            return m_points;
        }
    }
    [JsonIgnore]
    private Vector2[] m_points;
    [JsonProperty(PropertyName = "psx")]
    protected float[] points_x;
    [JsonProperty(PropertyName = "psy")]
    protected float[]  points_y;
    /// <summary>
    /// 领地所在的位置
    /// </summary>
    [JsonIgnore]
    public Vector2 position
    {
        get
        {
            return new Vector2(position_x, position_y);
        }
        set
        {
            position_x = value.x;
            position_y = value.y;
        }
    }
    [JsonProperty(PropertyName = "px")]
    private float position_x; 
    [JsonProperty(PropertyName = "py")]
    private float position_y;
    /// <summary>
    /// 领地ID 名字
    /// </summary>
    public string id;
    /// <summary>
    /// mono对象
    /// </summary>
    [JsonIgnore]
    public BuildMono mono;

    public BuildBase() {
        // 找一个合适的位置来生成建筑

    }

    public bool isOnArea(Vector2 point) {
        return StaticTools.PointIsInArea(points, point);
    }
}
