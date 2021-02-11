using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public static class Tools {
    public static string ReadAllText(string path) {
        return File.ReadAllText(AssetCachesDir + path);
    }

    public static string AssetCachesDir
    {
        get
        {
            string dir = "";
#if UNITY_EDITOR
            // dir = Application.dataPath + "Caches/";//路径：/AssetsCaches/
            dir = Application.streamingAssetsPath + "/";//路径：/xxx_Data/StreamingAssets/
#elif UNITY_IOS
            dir = Application.temporaryCachePath + "/";//路径：Application/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/Library/Caches/
#elif UNITY_ANDROID
            dir = Application.persistentDataPath + "/";//路径：/data/data/xxx.xxx.xxx/files/
#else
            dir = Application.streamingAssetsPath + "/";//路径：/xxx_Data/StreamingAssets/
#endif
            return dir;
        }
    }
}
