using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ItemTips : MonoBehaviour
{
    public static ItemTips instance;

    public RectTransform bg;
    public ItemTip mainitemtip;
    public ItemTip equipitemtip;
    public GameObject btns;
    Button[] tfbtns;
    Text[] txtbtns;
    public GameObject mask;

    int btn_count;
    int show_id;
    RectTransform pop;
    bool lockui;
    private void Awake() {
        if (instance == null)
            instance = this;
        pop = (RectTransform)PopUI.instance.transform;

        Transform parent= btns.transform;
        btn_count = parent.childCount;
        tfbtns = new Button[btn_count];
        txtbtns = new Text[btn_count];
        for (int i = 0; i < btn_count; i++) {
            Transform child = parent.GetChild(i);
            tfbtns[i] = child.GetComponent<Button>();
            txtbtns[i] = child.GetComponentInChildren<Text>();
        }
    }

    public void HideTips(int id) {
        if (lockui)
            return;
        if (show_id == id) {
            gameObject.SetActive(false);
        }
    }

    public void HideTips() {
        if (lockui)
            return;
        gameObject.SetActive(false);
    }
    public int ShowTips(int item_id, RectTransform rtf, params ItemTipsBtn[] btn_list) {
        if (lockui)
            return -1;
        ItemData item = GameData.instance.all_item[item_id];
        return ShowTips(item, rtf, btn_list);
    }

    public int ShowTips(ItemData item, RectTransform rtf, params ItemTipsBtn[] btn_list) {
        if (lockui)
            return -1;
        gameObject.SetActive(true);
        mainitemtip.ShowTip(item);
        //equipitemtip.ShowTip(item);
        if (btn_list.Length > 0) {
            lockui = true;
            mask.SetActive(true);
        }
        for (int i = 0; i < btn_count; i++) {
            int idx = i;
            Button btn = tfbtns[idx];
            if (idx < btn_list.Length) {
                Tools.SetActive(btn.gameObject, true);
                txtbtns[idx].text = MessageData.GetMessage(btn_list[idx].btn_name);
                btn.onClick.RemoveAllListeners();
                btn.onClick.AddListener(() => {
                    ClickClose();
                    btn_list[idx].btn_func();
                });
            } else {
                Tools.SetActive(btn.gameObject, false);
            }
        }
        SetPosition(rtf);
        show_id = ++show_id % 10000;
        return show_id;
    }

    private void SetPosition(RectTransform rtf) {
        LayoutRebuilder.ForceRebuildLayoutImmediate((RectTransform)mainitemtip.transform);
        LayoutRebuilder.ForceRebuildLayoutImmediate((RectTransform)equipitemtip.transform);
        LayoutRebuilder.ForceRebuildLayoutImmediate((RectTransform)btns.transform);
        LayoutRebuilder.ForceRebuildLayoutImmediate(bg);

        bg.position = rtf.position;

        float x = bg.anchoredPosition.x, y = bg.anchoredPosition.y + rtf.sizeDelta.y / 2 + bg.sizeDelta.y / 2;
        
        // 判断是否超过屏幕上面       若：坐标y+一半高度 大于 屏幕高度的一半
        if ((y + bg.sizeDelta.y / 2) > pop.sizeDelta.y / 2) {
            y = bg.anchoredPosition.y - rtf.sizeDelta.y / 2 - bg.sizeDelta.y / 2;
            // 判断是否超过屏幕下面       若：坐标y-一半高度 大于 -屏幕高度的一半
            if ((y - bg.sizeDelta.y / 2) < - pop.sizeDelta.y / 2) {
                // 需要提高高度到完整显示      得到面板高度比屏幕一半高多少
                float offset = pop.sizeDelta.y / 2 - Mathf.Abs(y - bg.sizeDelta.y / 2);
                y -= offset;
            }
        }

        if ((x + bg.sizeDelta.x / 2) > (pop.sizeDelta.x / 2)) {
            x -= (x + bg.sizeDelta.x / 2) - (pop.sizeDelta.x / 2);
        } else if ((x - bg.sizeDelta.x / 2) < (-pop.sizeDelta.x / 2)) {
            x += (-pop.sizeDelta.x / 2) - (x - bg.sizeDelta.x / 2);
        }

        bg.anchoredPosition = new Vector2(x, y);
    }

    public void ClickClose() {
        mask.SetActive(false);
        lockui = false;
        HideTips();
    }
}


public struct ItemTipsBtn {
    public UnityEngine.Events.UnityAction btn_func;
    public int btn_name;
}