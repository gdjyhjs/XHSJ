using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class UniqueIdObject<T>: Singleton<T> where T : UniqueIdObject<T>
{
    private uint maxId = 10000000;
    public Dictionary<uint, T> depot = new Dictionary<uint, T>();
    public uint id;

    protected static uint GetUniqueId() {
        for (uint i = 1; i < Instance.maxId; i++) {
            if (!Instance.depot.ContainsKey(i)) {
                return i;
            }
        }
        Debug.LogError("ID池已满");
        return 0;
    }

    protected static bool DeleteObject(uint id) {
        if (Instance.depot.ContainsKey(id)) {
            Instance.depot.Remove(id);
            return true;
        }
        Debug.LogError("ID不存在");
        return false;
    }

    protected static void ClearAll() {
        Instance.depot = new Dictionary<uint, T>();
    }
}
