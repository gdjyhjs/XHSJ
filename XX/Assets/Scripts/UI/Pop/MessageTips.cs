using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MessageTips : MonoBehaviour {
    public static MessageTips instance;

    public GameObject prefab;
    List<GameObject> idle_objs;
    List<GameObject> use_objs;
    string last_msg;
    float next_time;

    public float speed = 50; // 飘的速度
    public float time = 2; // 飘的时间
    public float interval_time = 0.3f; // 间隔时间
    Stack<string> messages;

    private void Awake() {
        if (instance == null)
            instance = this;
        idle_objs = new List<GameObject>();
        use_objs = new List<GameObject>();
        messages = new Stack<string>();
    }

    public static void Message(int id, params string[] values) {
        string msg = string.Format( MessageData.GetMessage(id), values);
        if (instance.last_msg == msg && instance.next_time > Time.time)
            return;
        instance.last_msg = msg;
        instance.messages.Push(msg);
        if (instance.next_time > Time.time) {
            instance.StartCoroutine(instance.MoveUp(msg, instance.next_time - Time.time));
            instance.next_time = instance.next_time + instance.interval_time;
            return;
        } else {
            instance.StartCoroutine(instance.MoveUp(msg));
            instance.next_time = Time.time + instance.interval_time;
        }

    }

    IEnumerator MoveUp(string msg, float t) {
        yield return new WaitForSeconds(t);
        StartCoroutine(MoveUp(msg));
    }

    IEnumerator MoveUp(string msg) {
        GameObject obj = GetObj();
        Text txt = obj.GetComponentInChildren<Text>();
        txt.text = msg;
        RectTransform rtf = (RectTransform)obj.transform;
        rtf.anchoredPosition = new Vector2(0, 100);
        RectTransform t_rtf = (RectTransform)txt.transform;
        LayoutRebuilder.ForceRebuildLayoutImmediate(t_rtf);
        rtf.sizeDelta = t_rtf.sizeDelta + new Vector2(40, 20);
        CanvasGroup canvas = obj.GetComponent<CanvasGroup>();
        canvas.alpha = 1;
        float t = 0;
        while (t < time) {
            canvas.alpha -= 1 / time * Time.deltaTime;
            t += Time.deltaTime;
            rtf.anchoredPosition += new Vector2(0, speed * Time.deltaTime);
            yield return 0;
        }
        rtf.anchoredPosition = new Vector2(0, 99999);
        PutObj(rtf.gameObject);
    }

    private GameObject GetObj() {
        GameObject obj;
        if (idle_objs.Count > 0) {
            obj = idle_objs[0];
            idle_objs.RemoveAt(0);
        } else {
            obj = Instantiate(prefab);
            obj.transform.SetParent(transform, false);
        }
        use_objs.Add(obj);
        return obj;
    }

    private void PutObj(GameObject obj) {
        use_objs.Remove(obj);
        idle_objs.Add(obj);
    }

}
