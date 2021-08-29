using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class g : MonoBehaviour {
    private static game _game;
    public static game game
    {
        get {
            if (_game == null) {
                GameObject go;
                g gg = FindObjectOfType<g>();
                if (gg == null)
                    go = new GameObject("g");
                else
                    go = gg.gameObject;
                StaticTools.GetOrAddComponent<g>(go).Init();
            }
            return _game;
        }
    }
    public static TimerMgr timer { get { return game.timer; } }
    public static ConfMgr conf { get { return game.conf; } }
    public static WorldMgr world { get { return game.world; } }
    public static DataMgr data { get { return game.data; } }
    public static UnitMgr units { get { return game.units; } }
    public static DateMgr date { get { return game.date; } }


    #region UI
    public static UIWorldMain uiWorldMain { get; set; }
    #endregion

    bool isInit;
    public void Awake() {
        Init();
    }

    public void Init() {
        isInit = true;
        _game = StaticTools.GetOrAddComponent<game>(gameObject);
        _game.Init();
    }
}
