using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PopUI : MonoBehaviour {
    public static PopUI instance;
    Dictionary<string, GameObject> uiList;
    public UIWindow[] all;
    private void Awake() {
        if (instance == null) {
            instance = this;
            DontDestroyOnLoad(gameObject);
        } else {
            Destroy(gameObject);
        }

        uiList = new Dictionary<string, GameObject>();

        foreach (var item in all) {
            if (item.active) {
                GameObject obj = Instantiate(item.obj);
                uiList.Add(obj.name, obj.gameObject);
                obj.transform.SetParent(transform, false);
                obj.SetActive(!item.show);
                obj.SetActive(item.show);
            }
        }
    }
}
