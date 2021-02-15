using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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
        _globalAttr = new long[(int)GlobalAttribute.end];
    }


    private int _save_id;
    private long[] _globalAttr;


    /// <summary>
    /// ´æµµID
    /// </summary>
    public static int save_id {
        get
        {
            return instance._save_id;
        }
        set
        {
            instance._save_id = value;
        }
    }

    public static long[] globalAttr
    {
        get
        {
            return instance._globalAttr;
        }
        set
        {
            instance._globalAttr = value;
        }
    }
}
