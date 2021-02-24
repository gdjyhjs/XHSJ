using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

public class BtnScale : MonoBehaviour {
    public int scale_speed = 1;
    public int show_id = -1;
    public string window_name;
    public string sub_window_name;
    float scale = 1;
    float target_scale = 1;
    private void Awake() {
        var ent = gameObject.AddComponent<EventTrigger>();
        UnityAction<BaseEventData> enter = new UnityAction<BaseEventData>(OnEnter);
        EventTrigger.Entry enterev = new EventTrigger.Entry();
        enterev.eventID = EventTriggerType.PointerEnter;
        enterev.callback.AddListener(enter);

        UnityAction<BaseEventData> exit = new UnityAction<BaseEventData>(OnExit);
        EventTrigger.Entry exitev = new EventTrigger.Entry();
        exitev.eventID = EventTriggerType.PointerExit;
        exitev.callback.AddListener(exit);

        EventTrigger trigger = gameObject.AddComponent<EventTrigger>();
        trigger.triggers.Add(enterev);
        trigger.triggers.Add(exitev);
    }

    private void OnEnter(BaseEventData data) {
        if (show_id> 0) {
            string ex = "";
            if (!string.IsNullOrWhiteSpace(window_name)) {
                foreach (SettingStruct item in SettingData.instance.worldShortcutKeys) {
                    if (item.type == "uiwindow") {
                        if ((window_name == item.param1) && (string.IsNullOrWhiteSpace(sub_window_name) || sub_window_name == item.param2)) {
                            ex = string.Format("({0})", item.keyCode);
                        }
                    }
                }
            }
            EnterPointTips.instance.ShowTips(show_id, (RectTransform)transform, ex);
        }
        target_scale = 1.2f;
    }
    private void OnExit(BaseEventData data) {
        if (show_id > 0) {
            EnterPointTips.instance.HideTips();
        }
        target_scale = 1;
    }

    private void Update() {
        if (scale != target_scale) {
            float change = scale_speed * Time.deltaTime;
            if (target_scale > scale) {
                scale += change;
                if (scale > target_scale) {
                    scale = target_scale;
                }
            } else {
                scale = change;
                if (scale < target_scale) {
                    scale = target_scale;
                }
            }
            transform.localScale = Vector3.one * scale;
        }
    }
}
