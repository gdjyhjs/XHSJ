using System.Collections;
using System.Collections.Generic;
using UMA;
using UMA.CharacterSystem;
using UnityEngine;

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

        UnitBase player = g.units.player;
        GameObject go = GameObject.Instantiate(Avatar.gameObject);
        mainRoleCamera.SwitchTarget(go.transform);
        go.SetActive(true);

        UMATools.LoadUMA(go.GetComponent<DynamicCharacterAvatar>(), player.appearance.umaData);
        go.transform.position = new Vector3();
        go.AddComponent<UnitMono>().unitData = player;

        go.AddComponent<PlayerInput>();
    }

    private IEnumerator InitWorld() {
        



        yield break;
    }
}
