using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 先天气运数据
/// </summary>
public static class LevelConfigData {
    public static LevelConfig[] dataList;
    public static string[] bigLevelName;
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

        bigLevelName = new string[dataList.Length / 3];
        for (int i = 0; i < dataList.Length; i+=3) {
            bigLevelName[i/3] = dataList[i].name.Split(' ')[0] +"期";
        }
    }

    public static string GetName(int level) {
        try {
            return dataList[level - 1].name;
        } catch (System.Exception) {
            Debug.LogError("level err ：" + level);
            throw;
        }
    }

    /// <summary>
    ///  获取大境界等级名称
    /// </summary>
    public static string GetBigName(int level) {
        try {
            return bigLevelName[level];
        } catch (System.Exception) {
            Debug.LogError("big level err：" + level);
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