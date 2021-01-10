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

    public InputField inputName;
    public Text placeholder;

    void Awake() {
        showCharacterIdx = Random.Range(1, 2);
        GameObject camera2 = Camera.main.gameObject;
        var post2 = camera2.AddComponent<JumpLevelGaussianBlur>();
        post2.ShowLevel(() => {
            DestroyImmediate(post2);
            ShowCharacter();
        }, 0.25f, 20);
        RandomName();
    }

    void ShowCharacter() {
        for (int i = 0; i < showObj.Length; i++) {
            showObj[i].SetActive(false);
        }
        showObj[showCharacterIdx].SetActive(true);
        txtMan.color = showCharacterIdx == 0 ? Color.cyan : Color.white;
        txtWoman.color = showCharacterIdx == 1 ? Color.cyan : Color.white;
        var data =  MainStaticDataCenter.instance.roleBaseTable;
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

    private Coroutine ie;
    public void StartGame() {
        if (string.IsNullOrWhiteSpace(inputName.text)){
            inputName.text = "";
            if (ie != null) {
                StopCoroutine(ie);
            }
            ie = StartCoroutine(ShowPlaceholder());
        } else {
            SaveLoadData.CreateMain(showCharacterIdx, inputName.text);
        }
    }

    public void RandomName() {
        inputName.text = CreateName.GetRandomSurnnameName((int)(Time.time * 1000));
    }

    public IEnumerator ShowPlaceholder() {
        Color[] colors = new Color[] { Color.white, Color.blue, Color.white, Color.blue, Color.white, Color.blue, Color.white, Color.blue };
        foreach (var item in colors) {
            placeholder.color = item;
            yield return new WaitForSeconds(.15f);
        }
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
