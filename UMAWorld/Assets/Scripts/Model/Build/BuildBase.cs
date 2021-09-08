using Newtonsoft.Json;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace UMAWorld {
    /// <summary>
    /// 建筑基础
    /// </summary>
    public class BuildBase {
        /// 宗门所在的位置
        /// </summary>
        [JsonProperty(PropertyName = "a")]
        public Point2 position;

        /// <summary>
        /// 宗门区域顶点坐标
        /// </summary>
        [JsonProperty(PropertyName = "b")]
        public Point2[] points;

        /// <summary>
        /// 宗门创建随机种子
        /// </summary>
        [JsonProperty(PropertyName = "c")]
        public int seed;

        /// <summary>
        /// 宗门ID 名字
        /// </summary>
        [JsonProperty(PropertyName = "d")]
        public string id;

        /// <summary>
        /// 宗门大门所在的位置
        /// </summary>
        [JsonProperty(PropertyName = "e")]
        public Point2 doorPosition;

        /// <summary>
        /// 宗门禁地所在的位置
        /// </summary>
        [JsonProperty(PropertyName = "f")]
        public Point2 forbiddenPosition;

        /// <summary>
        /// 宗门外殿所在的位置
        /// </summary>
        [JsonProperty(PropertyName = "g")]
        public Point2 outHallPosition;

        /// <summary>
        /// 宗门内殿所在的位置
        /// </summary>
        [JsonProperty(PropertyName = "h")]
        public Point2 innerHallPosition;

        /// <summary>
        /// 宗门配置ID
        /// </summary>
        [JsonProperty(PropertyName = "i")]
        public int confId;

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