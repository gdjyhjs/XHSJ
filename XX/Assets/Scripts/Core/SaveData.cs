using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class SaveData {
    public static void NewGame(RoleData roleData) {
        string game_path = Tools.SavePath("game.data");
        Debug.Log("´æµµ = " + game_path);
        int save_id = GameData.save_id;
        GameData gameData = new GameData();
        GameData.save_id = save_id;
        byte[] byt2 = Tools.SerializeObject(GameData.instance);
        Tools.WriteAllBytes(game_path, byt2);


        string main_role_path = Tools.SavePath("main_role.data");
        byte[] byt = Tools.SerializeObject(roleData);
        Tools.WriteAllBytes(main_role_path, byt);
    }
}
