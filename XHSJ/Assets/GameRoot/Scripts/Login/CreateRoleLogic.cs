using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class CreateRoleLogic : MonoBehaviour
{
    int showCharacterIdx = 0;
    public GameObject[] showObj;

    public Text txtMan;
    public Text txtWoman;
    public Text showDes;
    void Awake() {
        showCharacterIdx = Random.Range(0, 2);
        GameObject camera2 = Camera.main.gameObject;
        var post2 = camera2.AddComponent<JumpLevelGaussianBlur>();
        post2.ShowLevel(() => {
            DestroyImmediate(post2);
            ShowCharacter();
        }, 0.25f, 20);
    }

    void ShowCharacter() {
        for (int i = 0; i < showObj.Length; i++) {
            showObj[i].SetActive(false);
        }
        showObj[showCharacterIdx].SetActive(true);
        txtMan.color = showCharacterIdx == 0 ? Color.cyan : Color.white;
        txtWoman.color = showCharacterIdx == 1 ? Color.cyan : Color.white;
        var data = CqmStaticDataCenter.instance.roleBaseTable;
        showDes.text = data.datalist[showCharacterIdx].des;
    }

    public void SelectMan() {
        showCharacterIdx = 0;
        ShowCharacter();
    }

    public void SelectWoman() {
        showCharacterIdx = 1;
        ShowCharacter();
    }

    public void StartGame() {

    }

    public void ToMenu() {
        GameStateManager.curState = GameStateManager.GameState.Main;
        GameObject camera = Camera.main.gameObject;
        var post = camera.AddComponent<JumpLevelGaussianBlur>();
        post.JumpLevel(() => {
            SceneManager.LoadScene("main");
        }, 0.25f, 20);
    }
}
