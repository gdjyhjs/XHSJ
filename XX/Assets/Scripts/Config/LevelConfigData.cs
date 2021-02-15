using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 先天气运数据
/// </summary>
public static class LevelConfigData {
    public static LevelConfig[] dataList;
    static LevelConfigData() {
        string[] data = Tools.ReadAllText("Config/level.txt").Split('\n');
        List<LevelConfig> all = new List<LevelConfig>();
        foreach (string item in data) {
            if (string.IsNullOrWhiteSpace(item))
                continue;
            string[] tmp = item.Split(',');
            all.Add(new LevelConfig() { name = tmp[0], exp = int.Parse(tmp[1])});
        }
        dataList = all.ToArray();
    }

    public static string GetName(int level) {
        try {
            return dataList[level - 1].name;
        } catch (System.Exception) {
            Debug.LogError("等级错误：" + level);
            throw;
        }
    }
}

/// <summary>
/// 等级配置结构
/// </summary>
public struct LevelConfig {
    public string name;
    public int exp;
}