using System;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class FileHelper {


    public static string StreamingAssetsPath(string path) {
        string streamingAssetsPath = Path.Combine(Application.streamingAssetsPath, path);
        return streamingAssetsPath;
    }

    public static void WriteAllText(string path, string text) {
        File.WriteAllText(path, text);
    }

    public static string ReadAllText(string path) {
        return File.ReadAllText(path);
    }

    public static string DataPath(string path) {
        string dataPath = Path.Combine(Application.dataPath, path);
        return dataPath;
    }
}