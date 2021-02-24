using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MainWindows : BaseWindow {
    public Text longitude, latitude, lingqi, fengshui, yaocai, jinshi, 
        level_name, show_time, hp, mp, nl, role_name, show_coin, show_contributions, show_city_token;
    public GameObject boy_head, gril_head;
    public Image img_hp, img_mp, img_nl;

    public void UpdateUI() {
        RoleData roleData = RoleData.mainRole;
        if (roleData == null)
            return;
        UpdateInfo();
        int longitude = roleData.GetAttr(RoleAttribute.longitude);
        int latitude = roleData.GetAttr(RoleAttribute.latitude);
        UpdateSpace(longitude, latitude);
        UpdateGameData();
    }

    private void OnEnable() {
        LoadingUI.instance.Hide();
        UpdateUI();
        EventManager.AddEvent(EventTyp.SpaceChange, OnSelectSpace);
        EventManager.AddEvent(EventTyp.AttrChange, OnAttrChange);
        EventManager.AddEvent(EventTyp.MinValueChange, OnAttrChange);
        EventManager.AddEvent(EventTyp.GameDataChange, OnGameDataChange);
    }

    private void OnDisable() {
        EventManager.RemoveEvent(EventTyp.SpaceChange, OnSelectSpace);
        EventManager.RemoveEvent(EventTyp.AttrChange, OnAttrChange);
        EventManager.RemoveEvent(EventTyp.MinValueChange, OnAttrChange);
        EventManager.RemoveEvent(EventTyp.GameDataChange, OnGameDataChange);
    }

    public void OnSelectSpace(object param) {
        Vector2Int pos = (Vector2Int)param;
        UpdateSpace(pos.x, pos.y);
    }

    public void OnAttrChange(object roleData) {
        if ((RoleData)roleData == RoleData.mainRole) {
            UpdateInfo();
        }
    }

    public void OnGameDataChange(object param) {
        UpdateGameData();
    }

    public void UpdateInfo() {
        RoleData roleData = RoleData.mainRole;
        level_name.text = LevelConfigData.GetName(roleData.GetAttr(RoleAttribute.level));
        hp.text = string.Format("{0}/{1}", roleData.GetAttr(RoleAttribute.hp), roleData.GetMaxAttr(RoleAttribute.hp));
        mp.text = string.Format("{0}/{1}", roleData.GetAttr(RoleAttribute.mp), roleData.GetMaxAttr(RoleAttribute.mp));
        nl.text = string.Format("{0}/{1}", roleData.GetAttr(RoleAttribute.spirit), roleData.GetMaxAttr(RoleAttribute.spirit));
        role_name.text = roleData.name;
        show_coin.text = roleData.GetAttr(RoleAttribute.coin).ToString(); ;
        show_contributions.text = roleData.GetAttr(RoleAttribute.contributions).ToString(); ;
        show_city_token.text = roleData.GetAttr(RoleAttribute.city_token).ToString(); ;
        gril_head.SetActive(roleData.sex == Sex.Girl);
        boy_head.SetActive(roleData.sex == Sex.Boy);
    }

    public void UpdateGameData() {
        long time = GameData.instance.globalAttr[(int)GlobalAttribute.time];
        show_time.text = Tools.ShowTime(new System.DateTime(time));
    }

    public void UpdateSpace(int longitude,int latitude) {
        RoleData roleData = RoleData.mainRole;
        this.longitude.text = longitude.ToString();
        this.latitude.text = latitude.ToString();

        Random.InitState(GameData.instance.seed * longitude + latitude + GameData.GetMonthCount());
        WorldUnit unit = WorldCreate.instance.get_units(longitude, latitude);
        bool wait_lingqi = (unit & WorldUnit.WaitLingqi) == WorldUnit.WaitLingqi;
        bool wait_yaocai = (unit & WorldUnit.WaitYaocai) == WorldUnit.WaitYaocai;
        bool wait_jinshi = (unit & WorldUnit.WaitJinshi) == WorldUnit.WaitJinshi;
        if (wait_lingqi) {
            lingqi.text = "0";
        } else {
            if (Random.Range(0, 10000) == 20) {
                lingqi.text = Random.Range(150, 600).ToString();
            } else {
                lingqi.text = Random.Range(10, 30).ToString();
            }
        }
        fengshui.text = Random.Range(10, 100).ToString();
        if (wait_yaocai) {
            yaocai.text = "0";
        } else {
            if (Random.Range(0, 10000) == 20) {
                yaocai.text = Random.Range(150, 600).ToString();
            } else {
                yaocai.text = Random.Range(10, 30).ToString();
            }
        }
        if (wait_jinshi) {
            jinshi.text = "0";
        } else {
            if (Random.Range(0, 10000) == 20) {
                jinshi.text = Random.Range(150, 600).ToString();
            } else {
                jinshi.text = Random.Range(10, 30).ToString();
            }
        }
    }
















    public void ClickRole() {
        // 人物
        MainUI.ShowUI("RoleWindow", "role");
    }
    public void ClickNotice() {
        // 通知
        MessageTips.Message(1);
    }
    public void ClickTask() {
        // 任务
        MessageTips.Message(1);
    }
    public void ClickSkill() {
        // 技能
        MainUI.ShowUI("RoleWindow", "skill");
    }
    public void ClickBag() {
        // 背包
        MainUI.ShowUI("RoleWindow", "bag");
    }
    public void ClickArtistry() {
        // 技艺
        MainUI.ShowUI("RoleWindow", "artistry");
    }
    public void ClickMap() {
        // 小地图
        MessageTips.Message(1);
    }
    public void ClickLevel() {
        // 逆天改命
        MessageTips.Message(1);
    }
    public void ClickTime() {
        // 跳过本月
        MessageTips.Message(1);
    }
    public void ClickChangeTask() {
        // 显示/隐藏任务
        MessageTips.Message(1);
    }

    public void ClickXiu() {
        // 修炼
        MessageTips.Message(1);
    }
    public void ClickKan() {
        // 堪舆
        MessageTips.Message(1);
    }
    public void ClickCai() {
        // 采药
        MessageTips.Message(1);
    }
    public void ClickWa() {
        // 挖矿
        MessageTips.Message(1);
    }
}
