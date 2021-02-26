using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

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
    [MenuItem("Tools/存档/删除所有存档",false , 2000)]
    public static void SaveDelete() {
        for (int id = 0; id < 9; id++) {
            string dir = "SaveData_" + id;
            string savepath = Tools.AssetCachesDir + dir;
            if (System.IO.Directory.Exists(savepath)) {
                System.IO.Directory.Delete(savepath, true);
            }
        }
    }

    [MenuItem("Tools/统计代码量", false, 2001)]
    public static void Test() {
        int fileCount = 0, codeCount = 0, lineCount = 0;long count = 0;
        GetallfilesOfDir("Assets", ".cs", ref fileCount, ref codeCount, ref lineCount, ref count);
        Debug.LogFormat("C#代码 文件数{0} \t 总行数{1}/{2} \t 字数{3}", fileCount, codeCount, lineCount, count);
        fileCount = 0; codeCount = 0; lineCount = 0; count = 0;
        GetallfilesOfDir("Assets", ".txt", ref fileCount, ref codeCount, ref lineCount, ref count);
        Debug.LogFormat("配置 文件数{0} \t 总行数{1}/{2} \t 字数{3}", fileCount, codeCount, lineCount, count);
    }
    private static void GetallfilesOfDir(string path, string extName, ref int fileCount, ref int codeCount, ref int lineCount, ref long count) {
        string[] dir = Directory.GetDirectories(path); //文件夹列表   
        DirectoryInfo fdir = new DirectoryInfo(path);
        string[] file = Directory.GetFiles(path);
        foreach (string f in file)
        {
            if (Path.GetExtension(f) == extName) {
                fileCount++;
                string text = File.ReadAllText(f);
                count += text.Length;
                string[] lines = text.Split('\n');
                foreach (var item in lines) {
                    lineCount++;
                    if (!string.IsNullOrWhiteSpace(item)) {
                        codeCount++;
                    }
                }
            }
        }
        foreach (string d in dir) {
            GetallfilesOfDir(d, extName, ref fileCount, ref codeCount, ref lineCount, ref count);
        }
    }




    [MenuItem("Tools/文件转存UTF8", false, 2001)]
    public static void ToUtf8() {
        ToUtf8("Assets", ".cs");
    }
    private static void ToUtf8(string path, string extName) {
        //string[] dir = Directory.GetDirectories(path); //文件夹列表   
        //DirectoryInfo fdir = new DirectoryInfo(path);
        //string[] file = Directory.GetFiles(path);
        //foreach (string f in file) {
        //    if (Path.GetExtension(f) == extName) {
        //        fileCount++;
        //        string text = File.ReadAllText(f);
        //        count += text.Length;
        //        string[] lines = text.Split('\n');
        //        foreach (var item in lines) {
        //            lineCount++;
        //            if (!string.IsNullOrWhiteSpace(item)) {
        //                codeCount++;
        //            }
        //        }
        //    }
        //}
        //foreach (string d in dir) {
        //    GetallfilesOfDir(d, extName, ref fileCount, ref codeCount, ref lineCount, ref count);
        //}
    }
}
