using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ARPGDemo.Character;
using System.IO;

public static class SaveLoadData {

    public static void CreateMain(int id, string name) {
        CharacterBase.depot = new Dictionary<uint, CharacterBase>();
        ItemBase.depot = new Dictionary<uint, ItemBase>();
        ItemBase.CreateAllCommonItem();
        CharacterBase.Create(id, name, 10, new Vector3(0, 0, -6));
        InitGame(InitType.Create);
    }

    /// <summary>
    /// 是否有自动存档
    /// </summary>
    public static bool HasArchives() {
        string savePath = FileHelper.DataPath("SaveData");
        var autoSavePath = savePath + "/" + "auto";
        if (Directory.Exists(autoSavePath)) {
            return true;
        }
        return false;
    }

    public static void SaveGame() {
        try {
            string savePath = FileHelper.DataPath("SaveData");
            if (!Directory.Exists(savePath)) {
                Directory.CreateDirectory(savePath);
            }
            string tmpSavePath = savePath + "/" + "tmpChars";
            // 先存到临时目录，确保存档成功了再覆盖自动存档，避免存档失败造成坏档。
            if (Directory.Exists(tmpSavePath)) {
                Directory.Delete(tmpSavePath, true);
            }
            Directory.CreateDirectory(tmpSavePath);

            string tmpCharPath = tmpSavePath + "/char.y";
            WriteByteFile charFile = new WriteByteFile(tmpCharPath);
            foreach (KeyValuePair<uint, CharacterBase> item in CharacterBase.depot) {
                CharacterBase cb = item.Value;
                // 写入基本属性数据
                charFile.Write(cb.staticData.Id);// 角色配置
                charFile.Write(cb.uid);
                charFile.Write(cb.position.x);
                charFile.Write(cb.position.y);
                charFile.Write(cb.position.z);
                charFile.Write(cb.charName);
                charFile.Write(cb.Level);
                charFile.Write(cb.Exp);
                charFile.Write(cb.HP);
                charFile.Write(cb.SP);
                // 写入物品数量
                charFile.Write(cb.items.Count);
                // 写入装备数量
                charFile.Write(cb.equips.Count);
                // 写入物品
                foreach (var uid in cb.items) {
                    charFile.Write(uid);
                }
                // 写入装备
                foreach (var uid in cb.equips) {
                    charFile.Write(uid);
                }
                Debug.LogError("保存 uid = " + cb.uid);
            }
            charFile.Close();

            var tmpItemPath = tmpSavePath + "/item.y";
            WriteByteFile itemItemFile = new WriteByteFile(tmpItemPath);
            // 写入物品数据
            foreach (var item in ItemBase.depot) {
                ItemBase ib = item.Value;
                itemItemFile.Write(ib.staticData.Id);
                itemItemFile.Write(ib.uid);
                itemItemFile.Write(ib.hp);
                itemItemFile.Write(ib.sp);
                itemItemFile.Write(ib.strength);
                itemItemFile.Write(ib.magic);
                itemItemFile.Write(ib.speed);
                itemItemFile.Write(ib.defence);
                itemItemFile.Write(ib.fireResistance);
                itemItemFile.Write(ib.iceResistance);
                itemItemFile.Write(ib.electricityResistance);
                itemItemFile.Write(ib.poisonResistance);
                itemItemFile.Write(ib.attackDistance);
                itemItemFile.Write(ib.energy);
                itemItemFile.Write(ib.weight);
                itemItemFile.Write(ib.fireDamage);
                itemItemFile.Write(ib.iceDamage);
                itemItemFile.Write(ib.electricityDamage);
                itemItemFile.Write(ib.poisonDamage);
                itemItemFile.Write(ib.fireAppend);
                itemItemFile.Write(ib.iceAppend);
                itemItemFile.Write(ib.electricityAppend);
                itemItemFile.Write(ib.poisonAppend);
            }
            itemItemFile.Close();


            // 写入其他数据
            var tmpFilePath = tmpSavePath + "/global.y";
            WriteByteFile stream = new WriteByteFile(tmpFilePath);
            stream.Write(CharacterBase.depot.Count);// 角色总数量
            stream.Write(ItemBase.depot.Count);// 物品总数量
                                                // 以后还会写入时间等数据
            stream.Close();

            var autoSavePath = savePath + "/" + "auto";
            // 覆盖自动存档
            if (Directory.Exists(autoSavePath)) {
                Directory.Delete(autoSavePath, true);
            }
            Directory.Move(tmpSavePath, autoSavePath);
            Debug.LogError("存档成功 " + autoSavePath);

        } catch (System.Exception e) {
            Debug.LogError(e.Message + "\n" + e.StackTrace);
            throw;
        }
    }

    public static bool LoadGame() {
        CharacterBase.depot = new Dictionary<uint, CharacterBase>();
        ItemBase.depot = new Dictionary<uint, ItemBase>();
        try {
            var savePath = FileHelper.DataPath("SaveData");
            var autoSavePath = savePath + "/auto";
            var globalFile = autoSavePath + "/global.y";
            if (!Directory.Exists(autoSavePath) || !File.Exists(globalFile)) {
                Debug.LogError("没有存档");
                return false;
            }

            int charRoleCount = 0;
            int allItemCount = 0;
            ReadByteFile stream = new ReadByteFile(globalFile);
            stream.Read(out charRoleCount);
            stream.Read(out allItemCount);
            stream.Close();
            if (charRoleCount <= 0) {
                return false;
            }

            var itemFilePath = autoSavePath + "/item.y";
            ReadByteFile itemFile = new ReadByteFile(itemFilePath);
            for (int i = 0; i < allItemCount; i++) {
                itemFile.Read(out string item_staticData_Id);
                itemFile.Read(out uint item_uid);
                itemFile.Read(out float item_hp);
                itemFile.Read(out float item_sp);

                itemFile.Read(out float item_strength);
                itemFile.Read(out float item_magic);
                itemFile.Read(out float item_speed);
                itemFile.Read(out float item_defence);

                itemFile.Read(out float item_fireResistance);
                itemFile.Read(out float item_iceResistance);
                itemFile.Read(out float item_electricityResistance);
                itemFile.Read(out float item_poisonResistance);

                itemFile.Read(out float item_attackDistance);
                itemFile.Read(out float item_energy);
                itemFile.Read(out float item_weight);
                itemFile.Read(out float item_fireDamage);
                itemFile.Read(out float item_iceDamage);
                itemFile.Read(out float item_electricityDamage);
                itemFile.Read(out float item_poisonDamage);

                itemFile.Read(out float item_fireAppend);
                itemFile.Read(out float item_iceAppend);
                itemFile.Read(out float item_electricityAppend);
                itemFile.Read(out float item_poisonAppend);

                ItemBase.LoadItem(item_staticData_Id, item_uid, item_hp, item_sp,
                    item_strength, item_magic, item_speed, item_defence,
                    item_fireResistance, item_iceResistance, item_electricityResistance, item_poisonResistance,
                    item_attackDistance, item_energy, item_weight, item_fireDamage, item_iceDamage, item_electricityDamage, item_poisonDamage,
                    item_fireAppend, item_iceAppend, item_electricityAppend, item_poisonAppend);
            }
            itemFile.Close();

            foreach (var item in ItemBase.depot) {
                Debug.LogError(item.Key + " >> " + item.Value.uid);
            }

            var charFilePath = autoSavePath + "/char.y";
            ReadByteFile file = new ReadByteFile(charFilePath);
            for (int i = 0; i < charRoleCount; i++) {
                // 读取基本属性数据
                file.Read(out string staticDataId);// 角色配置
                file.Read(out uint uid);
                file.Read(out float position_x);
                file.Read(out float position_y);
                file.Read(out float position_z);
                file.Read(out string charName);
                file.Read(out int Level);
                file.Read(out ulong Exp);
                file.Read(out int HP);
                file.Read(out int SP);
                Debug.LogError("读取 uid = " + uid + "\t\tname = "+ charName);

                HashSet<uint> items = new HashSet<uint>();
                HashSet<uint> equips = new HashSet<uint>();
                // 读取物品数量
                file.Read(out int items_Count);
                // 读取装备数量
                file.Read(out int equips_Count);
                for (int j = 0; j < items_Count; j++) {
                    file.Read(out uint item_uid);
                    items.Add(item_uid);
                }
                for (int j = 0; j < equips_Count; j++) {
                    file.Read(out uint item_uid);
                    equips.Add(item_uid);
                }

                CharacterBase.LoadCharacter(staticDataId, uid, new Vector3(position_x, position_y, position_z), charName, Level, Exp, items, equips, HP, SP);
            }
            file.Close();

            foreach (var item in CharacterBase.depot) {
                Debug.LogError(item.Key + " >> " + item.Value.charName);
            }

            InitGame();
            Debug.LogError("读档成功");
            return true;

        } catch (System.Exception e) {
            Debug.LogError(e.Message + "\n" + e.StackTrace);
            throw;
        }
    }

    enum InitType {
        Node = 0,
        Create = 1,
    }

    private static void InitGame(InitType typ = default) {
        if (typ == InitType.Create) {
            CreateNewGame();
        }

#if UNITY_EDITOR
            UnityEngine.SceneManagement.SceneManager.LoadScene("world");
#else
            UnityEngine.SceneManagement.SceneManager.LoadScene("myDemo");
#endif
    }

    private static void CreateNewGame() {
        for (int i = -1; i < 2; i++) {
            var pos = new Vector3(i * 6, 0, 6);
            CharacterBase.Create(1, pos: pos);
        }
    }
}
