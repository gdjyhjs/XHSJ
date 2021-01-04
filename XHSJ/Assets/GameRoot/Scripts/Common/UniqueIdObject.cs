using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UniqueIdObject
{
    private static uint maxId = 10000000;
    protected static HashSet<uint> idDepot = new HashSet<uint>();
    public uint id;

    protected static bool CreateUniqueId(UniqueIdObject item) {
        for (uint i = 1; i < maxId; i++) {
            if (!idDepot.Contains(i)) {
                idDepot.Add(i);
                item.id = i;
                return true;
            }
        }
        Debug.LogError("ID池已满");
        return false;
    }
}
