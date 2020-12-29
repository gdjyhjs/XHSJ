using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ARPGDemo.Character;

public struct TopInfo {
    public CharacterStatus status;
    public GameObject charObj;
    public Transform charTf;
    public TopInfoShow topShow;
    public AI.FSM.BaseFSM fsm;
    public TopInfo(GameObject obj, TopInfoShow show, CharacterStatus statu) {
        charObj = obj;
        topShow = show;
        status = statu;
        charTf = obj.transform;
        fsm = obj.GetComponent<AI.FSM.BaseFSM>();
    }
}

public class TopInfoManager : MonoBehaviour
{public static TopInfoManager instance;
    public List<TopInfo> tops = new List<TopInfo>();
    public GameObject prefab;
  public  void CreateStatus(object obj) {
        GameObject go = obj as GameObject;
        if (go) {
            CharacterStatus status = go.GetComponent<CharacterStatus>();
            GameObject top = GameObjectPool.instance.CreateObject("UI_TopInfo", prefab, default, default);
            top.transform.SetParent(transform, false);
            TopInfoShow show = top.GetComponent<TopInfoShow>();
            TopInfo info = new TopInfo(go, show, status);
            tops.Add(info);
        }
    }

    public void RmStatus(object obj) {
        for (int i = 0; i < tops.Count; i++) {
            if (Equals(tops[i].charObj, obj)) {
                GameObjectPool.instance.CollectObject(tops[i].topShow.gameObject);
                tops.RemoveAt(i);
                return;
            }
        }
    }

    public void ChatacterDamage(object obj) {
        object[] data = obj as object[];
        if (null != data && data.Length == 2) {
            for (int i = 0; i < tops.Count; i++) {
                if (Equals(tops[i].charObj, data[0])) {
                    TopInfoShow ui = tops[i].topShow;
                    var damage = (int)data[1];
                    ui.ChatacterDamage(damage);
                    return;
                }
            }
        }
    }

    private void Awake() {
        instance = this;
    }
    void LateUpdate()
    {
        for (int i = 0; i < tops.Count; i++) {
            tops[i].topShow.UpdateState(tops[i]);
        }
    }
}
