using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;
using Random = UnityEngine.Random;

public class DataMgr{

    public int worldSeed = 5; // 生成世界的种子

    public void NewGame(string playerName, int version)
    {
        // 世界随机种子
        worldSeed = StaticTools.Random(int.MinValue, int.MaxValue);
        Random.InitState(worldSeed);
        // 随机城市
        Debug.Log("随机城市 g.builds = " + g.builds);
        g.builds.InitData();
        Debug.Log("随机城市 OK g.builds = " + g.builds);
        SaveGame(playerName, version);
    }

    public void SaveGame(string playerName, int version) {
        Debug.Log("保存存档:" + playerName);
        StaticTools.SetString(DataKey.UnitMgr + playerName, StaticTools.ToJson(g.units));
        StaticTools.SetString(DataKey.Version + playerName, version);
        StaticTools.SetString(DataKey.DataMgr + playerName, StaticTools.ToJson(g.data));
        Debug.Log("保存 g.builds = " + g.builds);
        StaticTools.SetString(DataKey.BuildMgr + playerName, StaticTools.ToJson(g.builds));
    }

    public void LoadGame(string playerName) {
        Debug.Log("读取存档:"+ playerName);
        g.game.units = StaticTools.FromJson<UnitMgr>(StaticTools.GetString(DataKey.UnitMgr + playerName));
        GameConf.version = StaticTools.GetInt(DataKey.Version + playerName);
        g.game.data = StaticTools.FromJson<DataMgr>(StaticTools.GetString(DataKey.DataMgr + playerName));
        g.game.builds = StaticTools.FromJson<BuildMgr>(StaticTools.GetString(DataKey.BuildMgr + playerName));

    }
}


public static class DataKey {
    // 全局
    public static string Language = "Language"; // 正在使用的语言
    public static string onPlayerName = "onPlayerName"; // 正在使用的存档角色名


    // 单个存档
    public static string UnitMgr = "UnitMgr"; // 单位管理存档
    public static string Version = "Version"; // 当前游戏版本
    public static string DataMgr = "DataMgr"; // 当前游戏版本
    public static string BuildMgr = "BuildMgr"; // 当前游戏版本
}