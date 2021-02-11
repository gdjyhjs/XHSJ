using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EnterPointTips : MonoBehaviour
{
    public static EnterPointTips instance;

    public Text text;
    public RectTransform bg;
    public LayoutElement element;
    public RectTransform tRtf;
    int show_id;
    RectTransform pop;
    private void Awake() {
        if (instance == null)
            instance = this;
        pop = (RectTransform)PopUI.instance.transform;
    }

    public void HideTips(int id) {
        if (show_id == id) {
            gameObject.SetActive(false);
        }
    }

    public void HideTips() {
        gameObject.SetActive(false);
    }

    public int ShowTips(string str, RectTransform rtf) {
        gameObject.SetActive(true);
        SetSize(str);
        SetPosition(rtf);
        show_id = ++show_id % 10000;
        return show_id;
    }

    private void SetSize(string str) {
        text.text = str;
        element.enabled = false;
        LayoutRebuilder.ForceRebuildLayoutImmediate(tRtf);

        if (tRtf.sizeDelta.x > 500) {
            element.enabled = true;
            text.text = "¡¡¡¡" + str;
            LayoutRebuilder.ForceRebuildLayoutImmediate(tRtf);
        }

        bg.sizeDelta = tRtf.sizeDelta + new Vector2(40, 40);

        LayoutRebuilder.ForceRebuildLayoutImmediate(bg);
    }

    private void SetPosition(RectTransform rtf) {
        bg.position = rtf.position;

        float x = bg.anchoredPosition.x, y = bg.anchoredPosition.y + rtf.sizeDelta.y / 2 + bg.sizeDelta.y / 2;
        
        if ((y + bg.sizeDelta.y / 2) > pop.sizeDelta.y / 2) {
            y = bg.anchoredPosition.y - rtf.sizeDelta.y / 2 - bg.sizeDelta.y / 2;
        }

        if ((x + bg.sizeDelta.x / 2) > (pop.sizeDelta.x / 2)) {
            x -= (x + bg.sizeDelta.x / 2) - (pop.sizeDelta.x / 2);
        } else if ((x - bg.sizeDelta.x / 2) < (-pop.sizeDelta.x / 2)) {
            x += (-pop.sizeDelta.x / 2) - (x - bg.sizeDelta.x / 2);
        }

        bg.anchoredPosition = new Vector2(x, y);
    }
}
