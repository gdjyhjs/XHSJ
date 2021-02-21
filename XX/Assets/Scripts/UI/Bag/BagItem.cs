using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class BagItem : MonoBehaviour {

    public Image color;
    public Image icon;
    public Text count;
    public GameObject useing;
    public UIItemType uiType;
    RoleData roleData;
    ItemData item;
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

        EventTrigger trigger = color.gameObject.AddComponent<EventTrigger>();
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
        if (item != null) {
            ItemTips.instance.ShowTips(item.id, (RectTransform)transform);
        }
    }
    private void OnExit(BaseEventData data) {
        onItem = false;
        ItemTips.instance.HideTips();
    }
    private void OnClickUp(BaseEventData data) {
        if (!onItem)
            return;
        if (item != null && roleData == RoleData.mainRole && isBag) {
            ItemTips.instance.ShowTips(item.id, (RectTransform)transform, GetItemBtns());
        }
        clickFunc?.Invoke();
    }
    private void OnDrag(BaseEventData data) {
        if (can_drag && item != null&&roleData == RoleData.mainRole) {
            EventManager.SendEvent(EventTyp.DragItem, item);
        }
    }
    private void OnBeginDrag(BaseEventData data) {
        if (can_drag && item != null && roleData == RoleData.mainRole) {
            EventManager.SendEvent(EventTyp.BeginDragItem, item);
        }
    }
    private void OnEndDrag(BaseEventData data) {
        if (can_drag && item != null && roleData == RoleData.mainRole) {
            EventManager.SendEvent(EventTyp.EndDragItem, item);
        }
    }

    private ItemTipsBtn[] GetItemBtns() {
        if (item == null || roleData == null || !isBag) {
            return new ItemTipsBtn[0];
        }
        bool item_is_equip = roleData.ItemIsEquip(item.id);
        List<ItemTipsBtn> btns = new List<ItemTipsBtn>();
        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        if (static_data.sub_ype == ItemSubType.recoverRemedy || static_data.sub_ype == ItemSubType.buffRemedy
            || static_data.sub_ype == ItemSubType.Ring || static_data.sub_ype == ItemSubType.Ride) {
            if (item_is_equip) {
                // 卸载按钮
                btns.Add(new ItemTipsBtn() { btn_name = 28, btn_func = BtnEquip });
            } else {
                if (static_data.sub_ype == ItemSubType.Ride) {
                    // 乘骑按钮
                    btns.Add(new ItemTipsBtn() { btn_name = 31, btn_func = BtnEquip });
                } else {
                    // 装备按钮
                    btns.Add(new ItemTipsBtn() { btn_name = 22, btn_func = BtnEquip });
                }
            }
        }
        if (static_data.sub_ype == ItemSubType.recoverRemedy || static_data.sub_ype == ItemSubType.aptitudesRemedy) {
            // 食用按钮
            btns.Add(new ItemTipsBtn() { btn_name = 23, btn_func = BtnUse });
        }
        if (static_data.type == ItemType.Gongfa) {
            // 学习按钮
            btns.Add(new ItemTipsBtn() { btn_name = 25, btn_func = BtnUse });
        }
        if (!item_is_equip) {
            // 丢弃按钮
            btns.Add(new ItemTipsBtn() { btn_name = 24, btn_func = BtnDiscard });
        }
        return btns.ToArray();
    }

    public void BtnDiscard() {
        if (item != null && roleData != null) {
            roleData.RemoveItem(item.id);
        }
    }

    public void BtnEquip() {
        if (item != null && roleData != null) {
            roleData.EquipItem(item.id);
        }
    }

    public void BtnUse() {
        if (item != null && roleData != null) {
            roleData.UseItem(item.id);
        }
    }

    public void BtnStudy() {
        if (item != null && roleData != null) {
            roleData.UseItem(item.id);
        }
    }

    public void SetItem(ItemData item, RoleData role = null, bool isBag = false, bool isRound = false,string show_count = null, System.Action clickFunc = null) {
        roleData = role;
        this.item = item;
        this.isBag = isBag;
        this.clickFunc = clickFunc;
        if (item == null) {
            if (isRound)
                color.sprite = UIAssets.instance.gongfaColor[0];
            else
                color.sprite = UIAssets.instance.itemColor[0];
            icon.enabled = false;
            if (show_count != null) {
                count.enabled = true;
                count.text = show_count;
            } else {
                count.enabled = false;
            }
            Tools.SetActive(useing, false);
            can_drag = false;
            return;
        }


        icon.enabled = true;
        count.enabled = true;
        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        icon.sprite = UIAssets.instance.itemIcon[static_data.icon];
        if (isRound)
            color.sprite = UIAssets.instance.gongfaColor[static_data.color];
        else
            color.sprite = UIAssets.instance.itemColor[static_data.color];

        if (show_count != null) {
            count.text = show_count;
        } else if (static_data.maxcount > 1) {
            count.text = item.count.ToString();
        } else {
            count.text = "";
        }


        if (roleData == null || !isBag) {
            can_drag = false;
            Tools.SetActive(useing, false);
            return;
        }

        bool isWear = roleData.ItemIsEquip(item.id); // 是否穿戴者
        Tools.SetActive(useing, isWear);
        can_drag = roleData == RoleData.mainRole && !isWear &&
            (static_data.type == ItemType.Equip || // 装备
            static_data.sub_ype == ItemSubType.recoverRemedy || static_data.sub_ype == ItemSubType.buffRemedy); // 恢复丹药或增益丹药

    }
}