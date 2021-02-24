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

    public long GetGameData(GlobalAttribute attr) {
        return globalAttr[(int)attr];
    }

    public void SetGameData(GlobalAttribute attr, long value) {
        globalAttr[(int)attr] = value;
        EventManager.SendEvent(EventTyp.GameDataChange, attr);
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

    #region 物品
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
    /// 记录丢弃或删除的物品id 以便复用
    /// </summary>
    public Queue<int> remove_items = new Queue<int>();

    /// <summary>
    /// 创建新物品
    /// </summary>
    public int NewItem(int static_id, ref int count) {
        bool old_id = remove_items.Count > 0; // 是否复用丢弃的物品id
        int item_id;
        if (old_id)
            item_id = remove_items.Dequeue();
        else
            item_id = all_item.Count;
        ItemData item = new ItemData() { static_id = static_id, count = 1, id = item_id };
        if (old_id)
            all_item[item_id] = item;
        else
            all_item.Add(item);
        ItemStaticData static_data = item_static_data[static_id];
        int item_count = Mathf.Min(count, static_data.maxcount);
        item.count = item_count;
        count -= item_count;
        return item_id;
    }

    public void RemoveItem(int item_id) {
        remove_items.Enqueue(item_id);
    }
    #endregion




    #region 功法
    /// <summary>
    /// 静态功法数据
    /// </summary>
    public GongfaStaticData[] gongfa_static_data = new GongfaStaticData[0];

    public static GongfaStaticData GetStaticGongfaFromItem(int item_id) {
        ItemData item = instance.all_item[item_id];
        ItemStaticData static_data = instance.item_static_data[item.static_id];
        GongfaStaticData gongfa = instance.gongfa_static_data[static_data.param[0]];
        return gongfa;
    }
    #endregion
}