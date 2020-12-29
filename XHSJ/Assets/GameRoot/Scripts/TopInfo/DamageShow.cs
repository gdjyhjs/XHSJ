using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DamageShow : MonoBehaviour
{
    public Text txtDamage;
    public Vector2 startPos = new Vector2(0, -50);
    public Vector2 movePos = new Vector2(10, 100);
    RectTransform rtf;
    private void Awake() {
        rtf = (RectTransform)transform;
    }

    public void SetDamage(int value, Transform parent) {
        rtf.SetParent(parent, false);
        rtf.localScale = Vector3.one;
        rtf.anchoredPosition = startPos;
        if (value > 0) {
            txtDamage.text = "-" + value;
        } else {
            txtDamage.text = "miss";
        }
        GameObjectPool.instance.CollectObject(gameObject, 1);
    }

    private void Update() {
        rtf.anchoredPosition += movePos * Time.deltaTime;
    }
}
