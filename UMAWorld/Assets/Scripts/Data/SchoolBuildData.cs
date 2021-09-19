using Newtonsoft.Json;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
// 黄俊山
public class SchoolBuildData
{

    [JsonProperty(PropertyName = "q")]
    public int confId;
    // 建筑种子
    [JsonProperty(PropertyName = "w")]
    public int seed;
    // 建筑ID
    [JsonProperty(PropertyName = "e")]
    public string id;
    // 大门坐标
    [JsonProperty(PropertyName = "r")]
    public float mainGatePosX;
    // 大门坐标
    [JsonProperty(PropertyName = "t")]
    public float mainGatePosZ;
}
