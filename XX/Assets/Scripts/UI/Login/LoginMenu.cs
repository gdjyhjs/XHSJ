using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class LoginMenu : BaseWindow {
    public void ClickStart() {
        MainUI.ShowUI("LoginLoad");
    }

    /// <summary>
    /// 点击成就
    /// </summary>
    public void ClickAchievement() {
        MessageTips.Message(1);
    }

    /// <summary>
    /// 点击设置
    /// </summary>
    public void ClickSetting() {
        MainUI.ShowUI("SettingWindow");
    }

    /// <summary>
    /// 点击退出
    /// </summary>
    public void ClickExit() {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }

    public CanvasGroup canvasGroup;
    private void Start() {
        canvasGroup.gameObject.SetActive(false);
        StartCoroutine(Show());
    }

    private void OnEnable() {
        StartCoroutine(WaitShow());
    }

    IEnumerator WaitShow() {
        yield return new WaitForSeconds(0.2f);
        LoadingUI.instance.Hide();
    }



    private IEnumerator Show() {
        canvasGroup.alpha = 0;
        canvasGroup.gameObject.SetActive(true);
        while (canvasGroup.alpha < 1) {
            canvasGroup.alpha += Time.deltaTime;
            yield return 0;
        }
    }
}
