using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LoadingUI : MonoBehaviour {
    public static LoadingUI instance;
    public UnityEngine.UI.Text t_msg;
    private void Awake() {
        if (instance == null) {
            instance = this;
            DontDestroyOnLoad(gameObject);
        } else {
            Destroy(gameObject);
        }
    }

    public void Hide() {
        gameObject.SetActive(false);
    }

    public void Show(int msg_id) {
        gameObject.SetActive(true);
        t_msg.text = MessageData.GetMessage(msg_id);
    }
}
