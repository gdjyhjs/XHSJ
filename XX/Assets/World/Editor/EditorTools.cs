using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class EditorTools : Editor
{
    [MenuItem("Tools/Main")]
    public static void MainScene() {
        UnityEditor.SceneManagement.EditorSceneManager.OpenScene("Assets/Scenes/main.unity");
    }
    [MenuItem("Tools/UI")]
    public static void UIScene() {
        UnityEditor.SceneManagement.EditorSceneManager.OpenScene("Assets/Scenes/UI.unity");
    }
    [MenuItem("Tools/World")]
    public static void WorldScene() {
        UnityEditor.SceneManagement.EditorSceneManager.OpenScene("Assets/World/Scene/world.unity");
    }
    [MenuItem("Tools/´æµµ/É¾³ýËùÓÐ´æµµ",false , 2000)]
    public static void SaveDelete() {
        for (int id = 0; id < 9; id++) {
            string dir = "SaveData_" + id;
            string savepath = Tools.AssetCachesDir + dir;
            if (System.IO.Directory.Exists(savepath)) {
                System.IO.Directory.Delete(savepath, true);
            }
        }
    }


}
