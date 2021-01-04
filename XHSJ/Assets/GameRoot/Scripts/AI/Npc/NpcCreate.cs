using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ARPGDemo.Character;

public class NpcCreate : MonoSingleton<NpcCreate> {
    public List<CharacterStatus> allChar = new List<CharacterStatus>();
    public GameObject player;
    public GameObject enemy;
    // Start is called before the first frame update
    void Init()
    {
        CreateMainPlayer();
        CreateNpc();
    }

    void CreateMainPlayer() {
        var obj = Instantiate<GameObject>(player, GetPos(new Vector3(0, 0, -6)), default);
        obj.SetActive(true);
        obj.transform.SetParent(transform);
        var mainChar = obj.GetComponent<CharacterStatus>();
        mainChar.chBase.charName = "玩家";
        allChar.Add(mainChar);
    }

    void CreateNpc() {
        for (int i = -1; i < 2; i++) {
            var obj = Instantiate<GameObject>(enemy, GetPos(new Vector3(i * 6, 0, 6)), default);
            obj.SetActive(true);
            obj.transform.SetParent(transform);
            var npcChar = obj.GetComponent<ARPGDemo.Character.CharacterStatus>();
            npcChar.chBase.charName = "陪练" + (i + 2);
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
}
