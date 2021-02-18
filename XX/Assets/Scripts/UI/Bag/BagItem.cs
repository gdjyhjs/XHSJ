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
    public BagItemType itemType;

    ItemData item;
    private void Awake() {
        var ent = color.gameObject.AddComponent<EventTrigger>();
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
    bool onItem;
    Vector2 beginDragPos;
    private void OnEnter(BaseEventData data) {
        if (item != null) {
            onItem = true;
            ItemTips.instance.ShowTips(item.id, (RectTransform)transform);
        }
    }
    private void OnExit(BaseEventData data) {
        onItem = false;
        ItemTips.instance.HideTips();
    }
    private void OnClickUp(BaseEventData data) {
        if (onItem) {
            ItemTips.instance.ShowTips(item.id, (RectTransform)transform, GetItemBtns());
        }
    }
    private void OnDrag(BaseEventData data) {
        if (item!=null) {
            EventManager.SendEvent(EventTyp.DragItem, item);
        }
    }
    private void OnBeginDrag(BaseEventData data) {
        beginDragPos = ((RectTransform)transform).anchoredPosition;
        EventManager.SendEvent(EventTyp.BeginDragItem, item);
    }
    private void OnEndDrag(BaseEventData data) {
        EventManager.SendEvent(EventTyp.EndDragItem, item);
    }

    private ItemTipsBtn[] GetItemBtns() {
        List<ItemTipsBtn> btns = new List<ItemTipsBtn>();
        // ¶ªÆú°´Å¥
        btns.Add(new ItemTipsBtn() { btn_name= 24, btn_func = BtnDiscard });
        return btns.ToArray();
    }

    private void BtnDiscard() {
        if (item != null) {
            Debug.Log("todu  ¶ªÆú " + item.id);
        }
    }

    public void SetItem(ItemData item, bool canDrag = false) {
        this.item = item;
        if (item == null) {
            color.sprite = UIAssets.instance.itemColor[0];
            icon.enabled = false;
            count.enabled = false;
            Tools.SetActive(useing, false);
        } else {
            icon.enabled = true;
            count.enabled = true;
            ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
            icon.sprite = UIAssets.instance.itemIcon[static_data.icon];
            color.sprite = UIAssets.instance.itemColor[static_data.color];
            switch (static_data.type) {
                case ItemType.Gongfa:
                    count.text = static_data.name;
                    break;
                case ItemType.Equip:
                case ItemType.Other:
                case ItemType.Remedy:
                case ItemType.Material:
                case ItemType.Toy:
                default:
                    if (static_data.maxcount > 1) {
                        count.text = item.count.ToString();
                    } else {
                        count.text = "";
                    }
                    break;
            }
            Tools.SetActive(useing, false);
        }
        can_drag = canDrag;
    }
}
