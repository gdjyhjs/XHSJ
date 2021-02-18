using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIAssets : MonoBehaviour {
    public static UIAssets instance;
    private void Awake() {
        if (instance == null) {
            instance = this;
        }
    }

    public Sprite[] itemColor;
    public Sprite[] bgColor;
    public GameObject[] grilPrefab;
    public GameObject[] boyPrefab;
    public GameObject[] ridePrefab;

    // 0-5 心法 武技/灵技 绝技 身法 神通
    // 6-21 坐骑
    // 22-25 戒指
    public Sprite[] itemIcon;
}
