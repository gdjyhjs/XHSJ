using UnityEngine;
using System.Collections.Generic;
using System.IO;
using System;

public static class AIConfiguration
{
    private static string sourcePath;

    private static Dictionary<string, Dictionary<string, Dictionary<string, string>>> cache = new Dictionary<string, Dictionary<string, Dictionary<string, string>>>();

    public static Dictionary<string, Dictionary<string, string>> Load(string aiConfigFile) {
        if (cache.ContainsKey(aiConfigFile))
            return cache[aiConfigFile];

        sourcePath = FileHelper.StreamingAssetsPath(aiConfigFile);
        string text = FileHelper.ReadAllText(sourcePath);
        if (string.IsNullOrEmpty(text)) {
            return null;
        } else {
            var dic = BuildDic(text);
            cache.Add(aiConfigFile, dic);
            return dic;
        }
    }

    //处理每行数据
    private static Dictionary<string, Dictionary<string, string>> BuildDic(string text)
    {
        Dictionary<string, Dictionary<string, string>> dicConfig = new Dictionary<string,Dictionary<string,string>> ();

        StringReader reader = new StringReader(text);
        string mainKey = null;
        string subKey = null;
        string subValue = null;
        string line = null;
        //遍历每一行数据
        while ((line = reader.ReadLine()) != null)
        {
            //处理方式 
            //先去除文本两端的空白
            line = line.Trim();
            //检查是否为null或""
            if (!string.IsNullOrEmpty(line))//如果不为空
            {
                //检查是否是"["开头
                if (line.StartsWith("["))
                {
                    //如果是 则在字典中加入主键，主键为"["与"]"之间的内容
                    mainKey = line.Substring(1, line.IndexOf("]") - 1);
                    //添加主键对应的值 
                    dicConfig.Add(mainKey, new Dictionary<string, string>());
                }
                else//不是"["开头 ,意味该行是配置项   配置键= 配置值
                {
                    //将"="左右两边的内容取出
                    var configKeyValue = line.Split('>');
                    //左->子键，右->子值
                    subKey = configKeyValue[0].Trim();
                    subValue = configKeyValue[1].Trim();
                    //将子键与子值加入字典
                    dicConfig[mainKey].Add(subKey, subValue);
                }
            }
        }
        return dicConfig;

    }
}
