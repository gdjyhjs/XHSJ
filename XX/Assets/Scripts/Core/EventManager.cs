using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class EventManager
{
    static Dictionary<EventTyp, List<Action<object>>> all;

    static EventManager() {
        all = new Dictionary<EventTyp, List<Action<object>>>();
        for (int i = 0; i < (int)EventTyp.end; i++) {
            all.Add((EventTyp)i, new List<Action<object>>());
        }
    }

    public static void AddEvent(EventTyp typ, Action<object> action) {
        all[typ].Add(action);
    }

    public static void RemoveEvent(EventTyp typ, Action<object> action) {
        all[typ].Remove(action);
    }

    public static void SendEvent(EventTyp typ, object param) {
        foreach (Action<object> item in all[typ]) {
            item(param);
        }
    }
}
