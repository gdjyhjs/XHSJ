using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PageUI : MonoBehaviour {
    public int DefIndx;
    public GameObject[] show_list;
    public Toggle[] tog_list;
    public string[] uiwin;
    public string[] uiparam;
    Action<int> action;
    int show_idx = 0;
    private void Awake() {
        for (int i = 0; i < tog_list.Length; i++) {
            int idx = i;
            tog_list[idx].onValueChanged.AddListener((isOn) => {
                if (isOn) {
                    OnPack(idx);
                }
            });
        }
        SetPack(DefIndx);
    }

    public void SetAction(Action<int> action) {
        this.action = action;
    }
    
    public void SetPack(int idx) {
        if (idx >= 0 && idx < tog_list.Length && tog_list[idx]) {
            tog_list[idx].isOn = true;
        }
    }

    private void OnPack(int idx) {
        SetShow(show_idx, false);
        show_idx = idx;
        SetShow(show_idx, true);
        action?.Invoke(idx);

        if (idx >= 0 && idx < uiwin.Length && !string.IsNullOrWhiteSpace( uiwin[idx])) {
            if (idx >= 0 && idx < uiparam.Length && !string.IsNullOrWhiteSpace(uiparam[idx])) {
                MainUI.ShowUI(uiwin[idx], uiparam[idx]);
            } else {
                MainUI.ShowUI(uiwin[idx]);
            }
        }
    }

    void SetShow(int idx, bool show) {
        if (idx >= 0 && idx < show_list.Length && show_list[idx]) {
            show_list[idx].SetActive(show);
        }
    }
}
