using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class game : MonoBehaviour {
    public TimerMgr timer;
    public WorldMgr world;
    public ConfMgr conf;
    public DataMgr data;
    public UnitMgr units;
    public BuildMgr builds;
    public DateMgr date;


    public void Init() {
        conf = new ConfMgr();
        data = new DataMgr();
        units = new UnitMgr();
        builds = new BuildMgr();
        date = new DateMgr();

        timer = CommonTools.GetOrAddComponent<TimerMgr>(gameObject);
        conf.Init(() => Debug.Log("conf ok"));
    }
}
