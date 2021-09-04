using Newtonsoft.Json;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace UMAWorld {
    /// <summary>
    /// 建筑基础
    /// </summary>
    public class BuildBase {
        /// <summary>
        /// 领土区域顶点坐标
        /// </summary>
        [JsonProperty(PropertyName = "a")]
        public Point2[] points;
        /// 领地所在的位置
        /// </summary>
        [JsonProperty(PropertyName = "b")]
        public Point2 position;
        /// <summary>
        /// 领地大门所在的位置
        /// </summary>
        [JsonProperty(PropertyName = "c")]
        public Point2 doorPosition;
        /// <summary>
        /// 领地ID 名字
        /// </summary>
        [JsonProperty(PropertyName = "d")]
        public string id;
        /// <summary>
        /// mono对象
        /// </summary>
        [JsonIgnore]
        public BuildMono mono;

        public bool isOnArea(Vector2 point) {
            return MathTools.PointIsInPolygon(points, point);
        }
    }

}