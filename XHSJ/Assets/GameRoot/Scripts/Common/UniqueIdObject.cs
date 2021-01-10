using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class UniqueIdObject<T>: Singleton<T> where T : UniqueIdObject<T>
{
    private static uint maxId = 10000000;
    public static Dictionary<uint, T> depot = new Dictionary<uint, T>();
    private uint _uid;
    public uint uid
    {
        get
        {
            return _uid;
        }
        set
        {
            _uid = value;
            depot.Add(_uid, (T)this);
        }
    }

    protected static uint GetUniqueId() {
        for (uint i = 1; i < maxId; i++) {
            if (!depot.ContainsKey(i)) {
                return i;
            }
        }
        Debug.LogError("ID池已满");
        return 0;
    }
    protected static uint GetUniqueId(uint id) {
        if (!depot.ContainsKey(id)) {
            return id;
        }
        Debug.LogError("ID池已满");
        return 0;
    }

    protected static bool DeleteObject(uint id) {
        if (depot.ContainsKey(id)) {
            depot.Remove(id);
            return true;
        }
        Debug.LogError("ID不存在");
        return false;
    }

    protected static void ClearAll() {
        depot = new Dictionary<uint, T>();
    }

    public static T FindItem(uint uid) {
        if (depot.ContainsKey(uid)) {
            return depot[uid];
        }
        return null;
    }
}
