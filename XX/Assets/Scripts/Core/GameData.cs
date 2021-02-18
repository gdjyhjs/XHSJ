using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[System.Serializable]
public class GameData {
    private static GameData _instance;
    public static GameData instance
    {
        get
        {
            if (_instance == null) {
                _instance = new GameData();
            }
            return _instance;
        }
        set
        {
            _instance = value;
        }
    }

    public GameData() {
        instance = this;
        globalAttr = new long[(int)GlobalAttribute.end];
    }

    public static int GetMonthCount() {
        long time = GameData.instance.globalAttr[(int)GlobalAttribute.time];
        DateTime dateTime = new DateTime(time);
        int month_count = dateTime.Year * 12 + dateTime.Month;
        return month_count;
    }


    public void NewGame(int save_id) {
        GameData.instance.save_id = save_id;
        UnityEngine.Random.InitState(System.DateTime.Now.Second);
        GameData.instance.seed = UnityEngine.Random.Range(0, 1000);
        // 初始化静态物品数据
        item_static_data = ItemConfigData.dataList;
        // 初始化功法
        CreateGongfa.Init();
    }
    public void SaveGame() {
        save_all_item = all_item.ToArray();
    }
    public void ReadGame() {
        all_item = new List<ItemData>(save_all_item);
    }


    public int save_id;
    public long[] globalAttr;
    public int seed;
    /// <summary>
    /// 静态功法数据
    /// </summary>
    public GongfaStaticData[] gongfa_static_data = new GongfaStaticData[0];
    /// <summary>
    /// 静态物品数据
    /// </summary>
    public ItemStaticData[] item_static_data = new ItemStaticData[0];


    /// <summary>
    ///  游戏所有物品
    /// </summary>
    private ItemData[] save_all_item;

    /// <summary>
    ///  游戏所有物品
    /// </summary>
    [System.NonSerialized]
    public List<ItemData> all_item = new List<ItemData>();

    /// <summary>
    /// 创建新物品
    /// </summary>
    public int NewItem(int static_id) {
        int item_id = all_item.Count;
        ItemData item = new ItemData() { static_id = static_id, count = 1, id = item_id };
        all_item.Add(item);
        return item_id;
    }

    public void RemoveItem(int item_id) {
        // Todo
    }
}
