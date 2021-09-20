using System.Collections;
using System.Collections.Generic;
using UMA;
using UMA.CharacterSystem;
using UnityEngine;
using UnityStandardAssets.Characters.ThirdPerson;


namespace UMAWorld {
    public class WorldMgr : MonoBehaviour {
        public DynamicCharacterAvatar Avatar;
        public UMARandomAvatar Randomizer;
        public MouseOrbitImproved mainRoleCamera;
        public bool initOK;
        public Transform treeainPoint;

        private void Awake() {
            initOK = false;
            g.game.world = this;
            string playerName = CommonTools.GetString(DataKey.onPlayerName);
            g.data.LoadGame(playerName);
            Debug.Log("宗门数量："+ g.builds.allSchool.Values.Count);
            Debug.Log("seed = " + g.data.worldSeed);
            CommonTools.RandomSeed(g.data.worldSeed);
        }

        private IEnumerator Start() {
            g.uiWorldLoading.Open();
            yield return InitWorld();
            // 加载玩家
            UnitBase player = g.units.player;
            GameObject goPlayer = GameObject.Instantiate(Avatar.gameObject);
            goPlayer.SetActive(true);
            mainRoleCamera.SwitchTarget(goPlayer.transform);
            // 加载模型
            DynamicCharacterAvatar avatar = goPlayer.GetComponent<DynamicCharacterAvatar>();
            try {
                UMATools.LoadUMA(avatar, player.appearance.umaData);
            } catch (System.Exception e) {
                Debug.LogError(e.Message+"\n"+e.StackTrace);
            }
            // 添加世界单位基类
            player.mono = goPlayer.AddComponent<UnitMono>();
            player.mono.unitData = player;
            player.mono.avatar = avatar;
            // 添加控制器
            goPlayer.AddComponent<UserInput>();
            player.mono.persion = goPlayer.GetComponent<ThirdPersonCharacter>();
            goPlayer.transform.position = CommonTools.GetGroundPoint(Vector3.zero);
            // 动画事件
            goPlayer.GetComponent<AnimEvent>().unitMono = player.mono;
            goPlayer.tag = GameConf.unitTag;
            // 更新主界面
            g.uiWorldMain.unit = g.units.player;
            g.uiWorldMain.UpdateUI();
            yield return new WaitForSeconds(0.75f);
            g.uiWorldLoading.Close();
            // 地形创造器
            treeainPoint.SetParent(goPlayer.transform, false);

            initOK = true;

            InitNav();



            StartCoroutine(Test());

#if UNITY_EDITOR
            // 绘画宗门区域
            foreach (var item in g.builds.allSchool.Values)
            {
                int vertexCount = item.points.Length;
                Vector3[] testPoints = new Vector3[vertexCount + 1];
                GameObject test = new GameObject();
                test.AddComponent<BuildMono>().Init(item);
            }
#endif
        }
        private IEnumerator InitWorld() {
            while (true) {
                float statusPercentage = MouseSoftware.EasyTerrain.GetUpdateStatusPercentage();
                if (statusPercentage >= 100f && Application.isPlaying) {
                    break;
                }
                yield return 0;
            }
        }

        private void InitNav() {
            Transform tiles = GameObject.Find("_TerrainTiles_").transform;
            for (int i = 0; i < tiles.childCount; i++) {
                tiles.GetChild(i).gameObject.AddComponent<NavMeshSourceTag>();
            }
            GameObject go = new GameObject("navBuilder");
            go.AddComponent<LocalNavMeshBuilder>().m_Tracked = g.units.player.mono.transform;
        }


        private void Update() {
            if (!initOK)
                return;
            g.date.AddTime(Time.deltaTime);

            if (Input.GetKeyDown(KeyCode.B)) {
                g.uiCharInfo.gameObject.SetActive(!g.uiCharInfo.gameObject.activeSelf);
            }
        }



        public int npcCount;
        List<UnitMono> npcs = new List<UnitMono>();
        WaitForSeconds waitOneSecond = new WaitForSeconds(1);
        private IEnumerator Test() {
            int idx = 0;
            while (true) {
                for (int i = npcs.Count - 1; i >= 0; i--) {
                    if (npcs[i].unitData.isDie) {
                        Destroy(npcs[i].unitData.mono.gameObject, 5f);
                        npcs.RemoveAt(i);
                    }
                }
                while (npcs.Count < npcCount) {
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
                    go.AddComponent<UnitAI>().targetUnit = g.units.player.mono;
                    unit.mono.persion = go.GetComponent<ThirdPersonCharacter>();
                    go.transform.position = CommonTools.GetGroundPoint(new Vector3(CommonTools.Random(-10, 10), 0, CommonTools.Random(-10, 10)));
                    // 动画事件
                    go.GetComponent<AnimEvent>().unitMono = unit.mono;
                    go.tag = GameConf.unitTag;

                    npcs.Add(unit.mono);
                    yield return 0;
                }
                yield return waitOneSecond;
            }
        }

        //private void OnGUI() {
        //    for (int i = 0; i < npcs.Count; i++) {
        //        GUILayout.Label(npcs[i].unitData.id + " " + npcs[i].unitData.attribute.hp + "/" + npcs[i].unitData.attribute.maxHp);
        //    }
        //}
    }
}