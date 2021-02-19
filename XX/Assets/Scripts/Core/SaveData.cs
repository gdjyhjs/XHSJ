using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SaveData {
     static SaveData _instance;
    public static SaveData instance
    {
        get
        {
            if (_instance == null) {
                _instance = new SaveData();
            }
            return _instance;
        }
    }
    public static float progress;

    public static void NewGame(RoleData roleData) {
        MainUI.HideAll();

        progress = 0;
        string game_path = Tools.SavePath("game.data");
        int save_id = GameData.instance.save_id;
        GameData.instance = new GameData();
        GameData.instance.NewGame(save_id);

        roleData.UpdateAttr();
        GameData.instance.SaveGame();
        byte[] byt2 = Tools.SerializeObject(GameData.instance);
        Tools.WriteAllBytes(game_path, byt2);
        progress = 50;




        string main_role_path = Tools.SavePath("main_role.data");
        roleData.SaveGame();
        byte[] byt = Tools.SerializeObject(roleData);
        Tools.WriteAllBytes(main_role_path, byt);
        progress = 100;

        SaveData.ReadGame(save_id);
    }

    public static void ReadGame(int save_id) {
        MainUI.HideAll();
        MainUI.instance.StartCoroutine(instance.EnterGame(save_id));
    }

    private IEnumerator EnterGame(int save_id) {
        progress = 0;
        GameData.instance.save_id = save_id;
        string game_path = Tools.SavePath("game.data");
        byte[] game_byt = Tools.ReadAllBytes(game_path);
        GameData.instance = Tools.DeserializeObject<GameData>(game_byt);
        GameData.instance.ReadGame();
        progress = 50;

        string main_role_path = Tools.SavePath("main_role.data");
        byte[] main_role_byt = Tools.ReadAllBytes(main_role_path);
        RoleData.mainRole = Tools.DeserializeObject<RoleData>(main_role_byt);
        RoleData.mainRole.ReadGame();
        progress = 99;

        AsyncOperation load_scene = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync("world");
        while (true) {
            if (load_scene.isDone)
                break;
            yield return 0;
        }
        yield return 0;
        MainUI.ShowUI("MainWindows");
        progress = 100;
    }

    public static void SaveGame() {
        string game_path = Tools.SavePath("game.data");
        GameData.instance.SaveGame();
        byte[] byt2 = Tools.SerializeObject(GameData.instance);
        Tools.WriteAllBytes(game_path, byt2);

        string main_role_path = Tools.SavePath("main_role.data");
        RoleData.mainRole.SaveGame();
        byte[] byt = Tools.SerializeObject(RoleData.mainRole);
        Tools.WriteAllBytes(main_role_path, byt);

        MessageTips.Message(17);
    }
}
