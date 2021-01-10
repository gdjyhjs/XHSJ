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
                WriteByteFile file = new WriteByteFile(tmpFilePath);
                // 写入基本属性数据
                file.Write(cb.staticData.Id);// 角色配置
                file.Write(cb.position.x);
                file.Write(cb.position.y);
                file.Write(cb.position.z);
                file.Write(cb.charName);
                file.Write(cb.Level);
                file.Write(cb.Exp);
                // 写入物品数量
                file.Write(cb.items.Count);
                // 写入装备数量
                file.Write(cb.equips.Count);
                // 写入物品
                foreach (ItemBase item in cb.items) {
                    file.Write(item.staticData.Id);
                    file.Write(item.id);
                    file.Write(item.hp);
                    file.Write(item.sp);
                    file.Write(item.strength);
                    file.Write(item.magic);
                    file.Write(item.speed);
                    file.Write(item.defence);
                    file.Write(item.fireResistance);
                    file.Write(item.iceResistance);
                    file.Write(item.electricityResistance);
                    file.Write(item.poisonResistance);
                    file.Write(item.attackDistance);
                    file.Write(item.energy);
                    file.Write(item.weight);
                    file.Write(item.fireDamage);
                    file.Write(item.iceDamage);
                    file.Write(item.electricityDamage);
                    file.Write(item.poisonDamage);
                    file.Write(item.fireAppend);
                    file.Write(item.iceAppend);
                    file.Write(item.electricityAppend);
                    file.Write(item.poisonAppend);
                }
                // 写入装备
                foreach (var item in cb.equips) {
                    file.Write(item.id);
                }
                file.Close();
            } catch (System.Exception e) {
                Debug.LogError(e.Message + "\n" + e.StackTrace);
                throw;
            }
            idx++;
        }
        // 写入其他数据
        try {
            var tmpFilePath = tmpSavePath + "/Global";
            WriteByteFile stream = new WriteByteFile(tmpFilePath);
            stream.Write(NpcCreate.instance.allChar.Count);// 角色总数量
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
        int allRoleCount = 0;
        try {
            ReadByteFile stream = new ReadByteFile(globalFile);
            stream.Read(out allRoleCount);
            stream.Close();
        } catch (System.Exception e) {
            Debug.LogError(e.Message + "\n" + e.StackTrace);
            throw;
        }
        if (allRoleCount <= 0) {
            return false;
        }
        for (int i = 0; i < allRoleCount; i++) {
            try {
                ReadByteFile file = new ReadByteFile(globalFile);
                file.Read(out allRoleCount);
                // 读取基本属性数据
                file.Read(out string staticDataId);// 角色配置
                file.Read(out float position_x);
                file.Read(out float position_y);
                file.Read(out float position_z);
                file.Read(out string charName);
                file.Read(out int Level);
                file.Read(out ulong Exp);
                // 读取物品数量
                file.Read(out int items_Count);
                // 读取装备数量
                file.Read(out int equips_Count);
                for (int j = 0; j < items_Count; j++) {
                    file.Read(out string item_staticData_Id);
                    file.Read(out uint item_id);
                    file.Read(out double item_hp);
                    file.Read(out double item_sp);
                    file.Read(out double item_strength);
                    file.Read(out double item_magic);
                    file.Read(out double item_speed);
                    file.Read(out double item_defence);
                    file.Read(out double item_fireResistance);
                    file.Read(out double item_iceResistance);
                    file.Read(out double item_electricityResistance);
                    file.Read(out double item_poisonResistance);
                    file.Read(out double item_attackDistance);
                    file.Read(out double item_energy);
                    file.Read(out double item_weight);
                    file.Read(out double item_fireDamage);
                    file.Read(out double item_iceDamage);
                    file.Read(out double item_electricityDamage);
                    file.Read(out double item_poisonDamage);
                    file.Read(out double item_fireAppend);
                    file.Read(out double item_iceAppend);
                    file.Read(out double item_electricityAppend);
                    file.Read(out double item_poisonAppend);
                    ItemBase item = null;
                }
                file.Close();
            } catch (System.Exception e) {
                Debug.LogError(e.Message + "\n" + e.StackTrace);
                throw;
            }
        }


        return true;
    }
}
