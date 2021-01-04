using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ARPGDemo.Character;
using System.IO;

public static class SaveLoadData
{

    public static void CreateMain(int id,string name) {
        Debug.LogError("创建游戏！"+id+" "+name);
        //StaticDataRoleBaseEle roleBase = MainStaticDataCenter.instance.roleBaseTable.datalist[id];
        //CharacterStatus status = CharacterStatus.Create<PlayerStatus>(new GameObject(), id);
        //SaveCharData(new CharacterStatus[] { status });
    }


    public static void  SaveGame() {
        var chars = NpcCreate.instance.allChar.ToArray();
        if (chars == null) {
            Debug.LogError("存档数据为空");
            return;
        }

        var savePath = FileHelper.DataPath("SaveData");
        if (!Directory.Exists(savePath)) {
            Directory.CreateDirectory(savePath);
        }
        var tmpSavePath = savePath + "/" + "tmpChars";
        // 先存到临时目录，确保存档成功了再覆盖自动存档，避免存档失败造成坏档。
        if (Directory.Exists(tmpSavePath)) {
            Directory.Delete(tmpSavePath, true);
        }
        Directory.CreateDirectory(tmpSavePath);

        uint idx = 0;
        foreach (var ch in NpcCreate.instance.allChar) {
            CharacterBase cb = ch.chBase;
            try {
                var tmpFilePath = tmpSavePath + "/" + idx;
                StreamWriter stream = new StreamWriter(tmpFilePath);
                // 写入基本属性数据
                stream.Write(cb.staticData.Id);// 角色配置
                stream.Write(cb.position.x);
                stream.Write(cb.position.y);
                stream.Write(cb.position.z);
                stream.Write(cb.charName);
                stream.Write(cb.Level);
                stream.Write(cb.Exp);
                // 写入物品数量
                stream.Write(cb.items.Count);
                // 写入装备数量
                stream.Write(cb.equips.Count);
                // 写入物品
                foreach (ItemAttribute item in cb.items) {
                    stream.Write(item.staticData.Id);
                    stream.Write(item.id);
                    stream.Write(item.staticData);
                    stream.Write(item.hp);
                    stream.Write(item.sp);
                    stream.Write(item.strength);
                    stream.Write(item.magic);
                    stream.Write(item.speed);
                    stream.Write(item.defence);
                    stream.Write(item.fireResistance);
                    stream.Write(item.iceResistance);
                    stream.Write(item.electricityResistance);
                    stream.Write(item.poisonResistance);
                    stream.Write(item.attackDistance);
                    stream.Write(item.energy);
                    stream.Write(item.weight);
                    stream.Write(item.fireDamage);
                    stream.Write(item.iceDamage);
                    stream.Write(item.electricityDamage);
                    stream.Write(item.poisonDamage);
                    stream.Write(item.fireAppend);
                    stream.Write(item.iceAppend);
                    stream.Write(item.electricityAppend);
                    stream.Write(item.poisonAppend);
                }
                // 写入装备
                foreach (var item in cb.equips) {
                    stream.Write(item.id);
                }
                stream.Close();
            } catch (System.Exception e) {
                Debug.LogError(e.Message + "\n" + e.StackTrace);
                throw;
            }
            idx++;
        }
        // 写入其他数据
        try {
            var tmpFilePath = tmpSavePath + "/Global";
            StreamWriter stream = new StreamWriter(tmpFilePath);
            stream.Write(idx);// 角色数量
            // 以后还会写入时间等数据
            stream.Close();
        } catch (System.Exception e) {
            Debug.LogError(e.Message + "\n" + e.StackTrace);
            throw;
        }

        var autoSavePath = savePath + "/" + "auto";
        // 覆盖自动存档
        if (Directory.Exists(autoSavePath)) {
            Directory.Delete(autoSavePath);
        }
        Directory.Move(tmpSavePath, autoSavePath);
    }

    public static bool LoadGame() {
        var savePath = FileHelper.DataPath("SaveData");
        var autoSavePath = savePath + "/auto";
        var globalFile = autoSavePath + "/Global";
        if (!Directory.Exists(autoSavePath) || !File.Exists(globalFile)) {
            return false;
        }

#if UNITY_EDITOR
        UnityEngine.SceneManagement.SceneManager.LoadScene("world");
#else
        UnityEngine.SceneManagement.SceneManager.LoadScene("myDemo");
#endif
        uint count;
        try {
            StreamReader stream = new StreamReader(globalFile);
            //count = stream.Read();
            stream.Close();
        } catch (System.Exception e) {
            Debug.LogError(e.Message + "\n" + e.StackTrace);
            throw;
        }
        return true;
    }
}
