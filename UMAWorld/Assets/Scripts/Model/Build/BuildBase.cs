using Newtonsoft.Json;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace UMAWorld {
    /// <summary>
    /// 建筑基础
    /// </summary>
    public class BuildBase {
        // 宗门区域
        [JsonIgnore]
        public Vector3[] points;
        // 大门坐标
        [JsonIgnore]
        public Vector3 mainGatePos;



        /// <summary>
        /// 宗门配置ID
        /// </summary>
        [JsonProperty(PropertyName = "1q")]
        public int confId;
        // 建筑种子
        [JsonProperty(PropertyName = "1w")]
        public int seed;
        // 建筑种子
        [JsonProperty(PropertyName = "1e")]
        public string id;

        /// <summary>
        /// mono对象
        /// </summary>
        [JsonIgnore]
        public BuildMono mono;

        public virtual bool isOnArea(Vector3 point) {
            return MathTools.PointIsInPolygon(points, point);
        }

        public virtual void InitData() {
            Debug.Log("初始化建筑 = " + id);
        }
    }

}