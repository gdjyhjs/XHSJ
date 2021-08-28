using System.Collections;
using System.Collections.Generic;
using UMA;
using UMA.CharacterSystem;
using UnityEngine;
using UnityStandardAssets.Characters.ThirdPerson;

public class WorldMgr : MonoBehaviour {
    public DynamicCharacterAvatar Avatar;
    public UMARandomAvatar Randomizer;
    public MouseOrbitImproved mainRoleCamera;

    private void Awake() {
        g.game.world = this;
        string playerName = StaticTools.GetString(DataKey.onPlayerName);
        g.data.LoadGame(playerName);
    }

    private IEnumerator Start() {
        yield return InitWorld();
        // 加载玩家
        UnitBase player = g.units.player;
        GameObject go = GameObject.Instantiate(Avatar.gameObject);
        go.SetActive(true);
        mainRoleCamera.SwitchTarget(go.transform);
        // 加载模型
        DynamicCharacterAvatar avatar = go.GetComponent<DynamicCharacterAvatar>();
        UMATools.LoadUMA(avatar, player.appearance.umaData);
        // 添加世界单位基类
        player.mono = go.AddComponent<UnitMono>();
        player.mono.unitData = player;
        player.mono.avatar = avatar;
        // 添加控制器
        go.AddComponent<UserInput>();
        player.mono.persion = go.GetComponent<ThirdPersonCharacter>();
        go.transform.position = new Vector3();
        // 动画事件
        go.GetComponent<AnimEvent>().unitMono = player.mono;
        go.tag = GameConf.unitTag;
        // 更新UI
        g.uiWorldMain.unit = player;
        g.uiWorldMain.UpdateUI();

        StartCoroutine(Test());

        player.attribute.damage += 30;
    }

    private IEnumerator InitWorld() {
        



        yield break;
    }


    List<UnitMono> npcs = new List<UnitMono>();
    private IEnumerator Test() {
        int idx = 0;
        while (true) {

            for (int i = npcs.Count - 1; i >= 0; i--) {
                if (npcs[i].unitData.isDie) {
                    Destroy(npcs[i].unitData.mono.gameObject, 5f);
                    npcs.RemoveAt(i);
                }
            }
            if (npcs.Count < 10) {
                string id = "npc" + idx++;
                UnitBase unit = g.units.NewUnit(id);
                g.units.playerUnitID = id;

                GameObject go = GameObject.Instantiate(Avatar.gameObject);
                go.SetActive(true);

                // 加载模型
                DynamicCharacterAvatar avatar = go.GetComponent<DynamicCharacterAvatar>();
                Randomizer.Randomize(avatar);
                avatar.BuildCharacter(true);

                //UMATools.LoadUMA(avatar, unit.appearance.umaData);
                unit.appearance.umaData = UMATools.SaveUMA(avatar);

                // 添加世界单位基类
                unit.mono = go.AddComponent<UnitMono>();
                unit.mono.unitData = unit;
                unit.mono.avatar = avatar;
                // 添加控制器
                go.AddComponent<UnitAI>();
                unit.mono.persion = go.GetComponent<ThirdPersonCharacter>();
                go.transform.position = new Vector3(StaticTools.Random(-10, 10), 0, StaticTools.Random(-10, 10));
                // 动画事件
                go.GetComponent<AnimEvent>().unitMono = unit.mono;
                go.tag = GameConf.unitTag;

                npcs.Add(unit.mono);
            }

            yield return new WaitForSeconds(1);
        }
    }

    private void OnGUI() {
        for (int i = 0; i < npcs.Count; i++) {
            GUILayout.Label(npcs[i].unitData.id + " " + npcs[i].unitData.attribute.hp + "/" + npcs[i].unitData.attribute.maxHp);
        }
    }
}
