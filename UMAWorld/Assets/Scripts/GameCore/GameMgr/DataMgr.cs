using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;
using Random = UnityEngine.Random;


namespace UMAWorld {
    public class DataMgr {

        public int worldSeed = 5; // 生成世界的种子
        public List<SchoolBuildData> buildData = new List<SchoolBuildData>();

        public void NewGame(string playerName, int version) {
            // 世界随机种子
            worldSeed = CommonTools.Random(int.MinValue, int.MaxValue);
            CommonTools.RandomSeed(worldSeed);
            // 随机城市
            Debug.Log("随机城市 worldSeed=" + worldSeed);
            g.builds.InitData();
            SaveGame(playerName, version);
        }

        public void SaveGame(string playerName, int version) {
            Debug.Log("保存存档:" + playerName);
            CommonTools.SetString(DataKey.UnitMgr + playerName, CommonTools.ToJson(g.units));
            CommonTools.SetString(DataKey.Version + playerName, version);
            CommonTools.SetString(DataKey.DataMgr + playerName, CommonTools.ToJson(g.data));
            Debug.Log("保存 g.builds = " + g.builds);
        }

        public void LoadGame(string playerName) {
            Debug.Log("读取存档:" + playerName);
            g.game.units = CommonTools.FromJson<UnitMgr>(CommonTools.GetString(DataKey.UnitMgr + playerName));
            GameConf.version = CommonTools.GetInt(DataKey.Version + playerName);
            g.game.data = CommonTools.FromJson<DataMgr>(CommonTools.GetString(DataKey.DataMgr + playerName));
            g.game.builds.LoadData();
        }
    }


    public static class DataKey {
        // 全局
        public static string Language = "Language"; // 正在使用的语言
        public static string onPlayerName = "onPlayerName"; // 正在使用的存档角色名


        // 单个存档
        public static string UnitMgr = "UnitMgr"; // 单位管理存档
        public static string Version = "Version"; // 当前游戏版本
        public static string DataMgr = "DataMgr"; // 数据管理
    }



}