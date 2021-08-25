using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{


    private void OnGUI() {
        if (GUILayout.Button("测试")) {
            TextData data = new TextData() { id = 0, name = "小明" };
            string str = StaticTools.ToJson(data);
            Debug.Log(str.Length + "str：" + str.Length);

            List<TextData> list = new List<TextData>();
            list.Add(new TextData() { id = 0, name = "小明" });
            list.Add(new TextData() { id = 1, name = "小红" });
            list.Add(new TextData() { id = 2, name = "小主" });
            string strList = StaticTools.ToJson(list);
            Debug.Log(strList.Length + "》strList：" + strList + ">" + strList.Length);
            string strArray = StaticTools.ToJson(list.ToArray());
            Debug.Log(strArray.Length + "》strList：" + strArray + ">" + strArray.Length);

            Dictionary<int, TextData> dic = new Dictionary<int, TextData>();
            foreach (var item in list) {
                dic.Add(item.id, item);
            }
            string strDic = StaticTools.ToJson(dic);
            Debug.Log(strDic.Length + "》strDic：" + strDic + ">" + strDic.Length);


            List<string> lll = new List<string>() {"小米", "小他", "小个", "小才", };
            string strlll = StaticTools.ToJson(lll);
            Debug.Log(strlll.Length + "》strlll：" + strlll + ">" + strlll.Length);


            string strAlll = StaticTools.ToJson(lll.ToArray());
            Debug.Log(strAlll.Length + "》strAlll：" + strAlll + ">" + strAlll.Length);


        }
    }
}

[System.Serializable]
public class TextData {
    public int id;
    public string name;
}