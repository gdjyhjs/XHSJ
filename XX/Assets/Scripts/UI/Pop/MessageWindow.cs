using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MessageWindow : MonoBehaviour {
    struct MsgData {
        public int title_id;
        public int msg_id;
        public string[] values;
        public Action cancel_func;
        public Action ok_func;
        public bool need_cancel;
        public float auto_cancel;
        public float auto_ok;
    }

    static MessageWindow instance;
    static Queue<MsgData> messages;
    public Text t_title;
    public Text t_msg;
    public GameObject cancelBtn;
    public Text t_cancel;
    public Text t_ok;

    MsgData cur_msg;
    private void Awake() {
        if (instance == null)
            instance = this;
        messages = new Queue<MsgData>();
    }

    public static void CheckMessage(int title_id, int msg_id, Action ok_func, Action cancel_func = null, float auto_cancel= 0, float auto_ok = 0, params string[] values) {
        if (instance == null)
            return;
        MsgData msg = new MsgData() { title_id = title_id, msg_id = msg_id, values = values, cancel_func = cancel_func, ok_func = ok_func, need_cancel = true, auto_cancel = auto_cancel, auto_ok = auto_ok };
        if (instance.gameObject.activeSelf) {
            messages.Enqueue(msg);
            return;
        }
        instance.SetMsg(msg);
    }

    public static void Message(int title_id, int msg_id, Action ok_func = null, float auto_ok = 0, params string[] values) {
        if (instance == null)
            return;

        MsgData msg = new MsgData() { title_id = title_id, msg_id = msg_id, values = values, ok_func = ok_func, auto_ok = auto_ok };
        if (instance.gameObject.activeSelf) {
            messages.Enqueue(msg);
            return;
        }
        instance.SetMsg(msg);
    }

    void SetMsg(MsgData msg) {
        cur_msg = msg;

        show_time = 0;
        instance.gameObject.SetActive(true);
        t_title.text = MessageData.GetMessage(msg.title_id);
        t_msg.text = string.Format(MessageData.GetMessage(msg.msg_id), msg.values);
        cancelBtn.SetActive(msg.need_cancel);
        SetButton();
    }

    public void ClickOk() {
        instance.gameObject.SetActive(false);
        cur_msg.ok_func?.Invoke();
        Close();
    }

    public void ClickCancel() {
        instance.gameObject.SetActive(false);
        cur_msg.cancel_func?.Invoke();
        Close();
    }

    void Close() {
        if (messages.Count > 0) {
            var msg = messages.Dequeue();
            SetMsg(msg);
        }
    }

    float show_time;
    private void Update() {
        show_time += Time.deltaTime;
        if (cur_msg.auto_ok != 0) {
            if (show_time > cur_msg.auto_ok) {
                ClickOk();
            } else {
                SetButton();
            }
        } else if (cur_msg.auto_cancel != 0) {
            if (show_time > cur_msg.auto_cancel) {
                ClickCancel();
            } else {
                SetButton();
            }
        }
    }

    private void SetButton() {
        t_ok.text = MessageData.GetMessage(78);
        t_cancel.text = MessageData.GetMessage(79);
        if (cur_msg.auto_ok != 0) {
            t_ok.text = string.Format("{0}（{1}）", MessageData.GetMessage(78), (int)(cur_msg.auto_ok - show_time));
        } else if (cur_msg.auto_cancel != 0) {
            t_ok.text = string.Format("{0}（{1}）", MessageData.GetMessage(79), (int)(cur_msg.auto_cancel - show_time));
        }
    }
}
