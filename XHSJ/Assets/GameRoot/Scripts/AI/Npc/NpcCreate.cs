using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ARPGDemo.Character;

public class NpcCreate : MonoSingleton<NpcCreate> {
    public List<CharacterStatus> allChar = new List<CharacterStatus>();
    public GameObject player;
    public GameObject enemy;
    public uint mainRoleId = 1;
    // Start is called before the first frame update
    void Awake()
    {
        Debug.LogError("开始创建角色");
        CreateMainPlayer();
        CreateNpc();
    }

    void CreateMainPlayer() {
        if (CharacterBase.depot.ContainsKey(mainRoleId)) {
            CharacterBase mainRole = CharacterBase.depot[mainRoleId];
            var obj = Instantiate<GameObject>(player, GetPos(mainRole.position), default);
            obj.SetActive(true);
            obj.transform.SetParent(transform);
            var mainChar = obj.GetComponent<CharacterStatus>();
            mainChar.chBase = mainRole;
            allChar.Add(mainChar);
        } else {
            Debug.LogError("不存在主角数据");
        }
    }

    void CreateNpc() {
        foreach (KeyValuePair<uint, CharacterBase> item in CharacterBase.depot) {
            CharacterBase ch = item.Value;
            if (ch.uid == mainRoleId)
                continue;
            var obj = Instantiate<GameObject>(enemy, GetPos(ch.position), default);
            obj.SetActive(true);
            obj.transform.SetParent(transform);
            var npcChar = obj.GetComponent<ARPGDemo.Character.CharacterStatus>();
            npcChar.chBase = ch;
            allChar.Add(npcChar);
        }
    }

    Vector3 GetPos(Vector3 pos) {
        RaycastHit hit;
        if (Physics.Raycast(pos + Vector3.up * 500, -Vector3.up,out hit, 1000, 1 << 8)) {
            return hit.point;
        }
        return pos;
    }

    private void OnGUI() {
        if (GUI.Button(new Rect(50, 50, 100, 40), "存档")){
            SaveLoadData.SaveGame();
        }
        if (GUI.Button(new Rect(50, 150, 100, 40), "读档")) {
            SaveLoadData.LoadGame();
        }
    }
}
