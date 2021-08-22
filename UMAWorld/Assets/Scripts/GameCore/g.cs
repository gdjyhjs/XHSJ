using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class g : MonoBehaviour {
    private static Game _game;
    public static Game game
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

    bool isInit;
    public void Awake() {
        Init();
    }

    public void Init() {
        isInit = true;
        _game = StaticTools.GetOrAddComponent<Game>(gameObject);
        _game.Init();
    }
}
