using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 角色属性配置数据
/// </summary>
public static class MessageData {
    public static string[] dataList;
    static MessageData() {
        dataList = Tools.ReadAllText("Config/MessageData.txt").Split('\n');
    }

    public static string GetMessage(int id) {
        if (id > dataList.Length || id < 1) {
            Debug.LogErrorFormat("message id range 1-{0} , but will get id = {1}", dataList.Length, id);
        }
        return dataList[id - 1];
    }
}