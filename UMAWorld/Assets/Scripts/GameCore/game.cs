using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Game : MonoBehaviour {
    public TimerMgr timer;
    public ConfMgr conf = new ConfMgr();

    public void Init() {
        timer = StaticTools.GetOrAddComponent<TimerMgr>(gameObject);
        conf.Init(() => Debug.Log("conf ok"));
    }
}
