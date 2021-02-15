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


}
