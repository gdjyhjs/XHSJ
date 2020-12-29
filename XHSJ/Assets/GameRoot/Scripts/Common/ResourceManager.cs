using UnityEngine;
using System.Collections.Generic;
using System.IO;

public class ResourceManager : MonoBehaviour
{   
    static ResourceManager()
    {
        TxtLoadDic();
    }
    private static Dictionary<string, string> dic = new Dictionary<string, string>();
    /// 加载资源映射文件 
    private static void TxtLoadDic()
    {
        //1加载文本资源 
        string mapText = Resources.Load<TextAsset>("ResMap").text;
        string line = null;
        //2对文本逐行读取 StringReader放到字典中
        using (StringReader reader = new StringReader(mapText))
        {
            while ((line = reader.ReadLine()) != null)
            {   //3对每一行进行处理：用"="拆分为两段
                var keyValue = line.Split('=');
                //4前一段为key,后一段为value
                dic.Add(keyValue[0], keyValue[1]);
            }
        }
    }
    //通过资源名取得资源路径 
    //CircleAttackSkill  -- > Skill/CircleAttackSkill
    private static string GetValue(string key)
    {
        if (dic.ContainsKey(key))return dic[key];
        return null;
    }    
    public static T Load<T>(string path) where T : Object
    {
        return Resources.Load<T>(GetValue(path));
    }
    //public static Object Load(string path)
    //{
    //    return Resources.Load(GetValue(path));
    //}
}

