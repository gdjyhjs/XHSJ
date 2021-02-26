using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class GongfaItem : MonoBehaviour {


    private void Awake() {
        UnityAction<BaseEventData> enter = new UnityAction<BaseEventData>(OnEnter);
        EventTrigger.Entry enterev = new EventTrigger.Entry();
        enterev.eventID = EventTriggerType.PointerEnter;
        enterev.callback.AddListener(enter);

        UnityAction<BaseEventData> exit = new UnityAction<BaseEventData>(OnExit);
        EventTrigger.Entry exitev = new EventTrigger.Entry();
        exitev.eventID = EventTriggerType.PointerExit;
        exitev.callback.AddListener(exit);

        UnityAction<BaseEventData> clickup = new UnityAction<BaseEventData>(OnClickUp);
        EventTrigger.Entry clickupev = new EventTrigger.Entry();
        clickupev.eventID = EventTriggerType.PointerUp;
        clickupev.callback.AddListener(clickup);

        UnityAction<BaseEventData> drag = new UnityAction<BaseEventData>(OnDrag);
        EventTrigger.Entry dragev = new EventTrigger.Entry();
        dragev.eventID = EventTriggerType.Drag;
        dragev.callback.AddListener(drag);

        UnityAction<BaseEventData> begindrag = new UnityAction<BaseEventData>(OnBeginDrag);
        EventTrigger.Entry begindragev = new EventTrigger.Entry();
        begindragev.eventID = EventTriggerType.BeginDrag;
        begindragev.callback.AddListener(begindrag);

        UnityAction<BaseEventData> enddrag = new UnityAction<BaseEventData>(OnEndDrag);
        EventTrigger.Entry enddragev = new EventTrigger.Entry();
        enddragev.eventID = EventTriggerType.EndDrag;
        enddragev.callback.AddListener(enddrag);

        EventTrigger trigger = (bg != null ? bg : color).gameObject.AddComponent<EventTrigger>();
        trigger.triggers.Add(enterev);
        trigger.triggers.Add(exitev);
        trigger.triggers.Add(clickupev);
        trigger.triggers.Add(dragev);
        trigger.triggers.Add(begindragev);
        trigger.triggers.Add(enddragev);
    }

    bool can_drag;
    public bool onItem;
    bool isBag;
    System.Action clickFunc;
    private void OnEnter(BaseEventData data) {
        onItem = true;
        if (gongfa != null) {
            int item_id = gongfa.item_id;
            ItemTips.instance.ShowTips(item_id, (RectTransform)transform);
        }
    }
    private void OnExit(BaseEventData data) {
        onItem = false;
        ItemTips.instance.HideTips();
    }
    private void OnClickUp(BaseEventData data) {
        if (!onItem)
            return;
        if (gongfa != null && roleData == RoleData.mainRole) {
            bool isWear = roleData.GonfaIsEquip(gongfa); // 是否穿戴着
            if (isWear) {
                if (isBag) {
                    MessageTips.Message(48);
                } else {
                    RoleData.mainRole.UnfixGongfa(gongfa);
                }
            } else {
                RoleData.mainRole.EquipGongfa(gongfa);
            }
        }
        clickFunc?.Invoke();
    }
    private void OnDrag(BaseEventData data) {
        if (can_drag && gongfa != null && roleData == RoleData.mainRole) {
            EventManager.SendEvent(EventTyp.DragItem, gongfa);
        }
    }
    private void OnBeginDrag(BaseEventData data) {
        if (can_drag && gongfa != null && roleData == RoleData.mainRole) {
            EventManager.SendEvent(EventTyp.BeginDragItem, gongfa);
        }
    }
    private void OnEndDrag(BaseEventData data) {
        if (can_drag && gongfa != null && roleData == RoleData.mainRole) {
            EventManager.SendEvent(EventTyp.EndDragItem, gongfa);
        }
    }

    public Image bg;
    public Image color;
    public Image icon;
    public Text t_name;
    public Text t_type;
    public Text t_level;
    public GameObject useing;
    public UIItemType itemType;
    RoleData roleData;
    GongfaData gongfa;

    public void SetItem(GongfaData gongfa, RoleData role = null, bool isBag = false, System.Action clickFunc = null) {
        roleData = role;
        this.gongfa = gongfa;
        this.isBag = isBag;
        this.clickFunc = clickFunc;
        if (gongfa == null) {
            icon.enabled = false;
            color.sprite = UIAssets.instance.gongfaColor[0]; ;
            if (bg)
                bg.sprite = UIAssets.instance.bgColor[0];
            if (t_name)
                t_name.text = null;
            if (t_type)
                t_type.text = null;
            if (t_level)
                t_level.text = null;
            Tools.SetActive(useing, false);
            return;
        }

        int item_id = gongfa.item_id;
        ItemData item = GameData.instance.all_item[item_id];
        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        icon.enabled = true;
        icon.sprite = UIAssets.instance.itemIcon[static_data.icon];
        color.sprite = UIAssets.instance.gongfaColor[static_data.color];
        if (bg)
            bg.sprite = UIAssets.instance.bgColor[static_data.color];
        if (t_name)
            t_name.text = static_data.name;
        if (t_type)
            t_type.text = GameConst.itemSubTypeName[static_data.sub_ype];
        if (t_level)
            t_level.text = LevelConfigData.GetBigName(static_data.level);

        if (roleData == null || !isBag) {
            can_drag = false;
            Tools.SetActive(useing, false);
            return;
        }

        bool isWear = roleData.GonfaIsEquip(gongfa); // 是否穿戴着
        Tools.SetActive(useing, isWear);
        can_drag = roleData == RoleData.mainRole && !isWear;
    }
}