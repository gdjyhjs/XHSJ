using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowShapeMask : MonoBehaviour
{
    public RectTransform yuan;
    public RectTransform fang;
    public void ShowYuan(RectTransform rtf) {
        yuan.position = rtf.position;
    }
    public void ShowFang(RectTransform rtf) {
        fang.position = rtf.position;
    }
    public void Hide() {
        yuan.position = new Vector3(100000, 0, 0);
        yuan.position = new Vector3(100000, 0, 0);
    }
}
