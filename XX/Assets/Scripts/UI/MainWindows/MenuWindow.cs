using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MenuWindow : BaseWindow {
    public GameObject[] worldBtn;
    public void ClickSave() {
        ClickClose();
        SaveData.SaveGame();
    }

    private void OnEnable() {
        bool on_world = (UnityEngine.SceneManagement.SceneManager.GetActiveScene().name == "world");
        foreach (var item in worldBtn) {
            Tools.SetActive(item, on_world);
        }
    }

    public void ClickSetting() {
        MainUI.ShowUI("SettingWindow");
    }

    public void ClickToMain() {
        RoleData.mainRole = null;
        MainUI.HideAll();
        MainUI.ShowUI("LoginMenu");
        UnityEngine.SceneManagement.SceneManager.LoadScene("login");
    }

    public void ClickQuit() {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }
}
