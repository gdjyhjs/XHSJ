using System;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class FileHelper {


    public static string StreamingAssetsPath(string path) {
        string streamingAssetsPath = Path.Combine(Application.streamingAssetsPath, path);
        if (Application.platform == RuntimePlatform.Android)
            streamingAssetsPath = "file://" + streamingAssetsPath;
        return streamingAssetsPath;
    }

    public static void WriteAllText(string path, string text) {
        File.WriteAllText(path, text);
    }

    public static string ReadAllText(string path) {
        return File.ReadAllText(path);
    }
}