using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using GuiBaseUI;
using UnityEngine.EventSystems;
using UnityEngine.Events;

public class BagUI : MonoBehaviour
{
    public BigDataScroll bigDataScroll;
    public ScrollRect scrollView;
    public GameObject viewport;
    public ItemCell itemCell;
    public float mouseSpeed = 100;
    public BagItem[] equip_items;
    public BagItem[] battle_items;

    public GameObject yuan1;
    public GameObject yuan2;
    public GameObject fang;
    public RectTransform dragItem;

    int max_item;
    int child_count;
    ItemType show_pack = ItemType.end;
    List<int> show_items;
    bool onBagView;
    int line_count;

    private void Awake() {
        child_count = itemCell.transform.childCount;
        bigDataScroll.Init(scrollView, itemCell, SetData);
        bigDataScroll.cellHeight = 65;
        var ent = viewport.gameObject.AddComponent<EventTrigger>();
        UnityAction<BaseEventData> enter = new UnityAction<BaseEventData>(OnEnter);
        EventTrigger.Entry enterev = new EventTrigger.Entry();
        enterev.eventID = EventTriggerType.PointerEnter;
        enterev.callback.AddListener(enter);

        UnityAction<BaseEventData> exit = new UnityAction<BaseEventData>(OnExit);
        EventTrigger.Entry exitev = new EventTrigger.Entry();
        exitev.eventID = EventTriggerType.PointerExit;
        exitev.callback.AddListener(exit);

        EventTrigger trigger = viewport.gameObject.AddComponent<EventTrigger>();
        trigger.triggers.Add(enterev);
        trigger.triggers.Add(exitev);
    }
    private void OnEnter(BaseEventData data) {
        onBagView = true;
    }
    private void OnExit(BaseEventData data) {
        onBagView = false;
    }
    
    private void OnEnable() {
        UpdateUI();
        EventManager.AddEvent(EventTyp.ItemChange, OnItemChange);
        EventManager.AddEvent(EventTyp.BeginDragItem, OnItemBeginDragItem);
        EventManager.AddEvent(EventTyp.DragItem, OnItemDragItem);
        EventManager.AddEvent(EventTyp.EndDragItem, OnItemEndDragItem);

        Tools.SetActive(fang, false);
        Tools.SetActive(yuan1, false);
        Tools.SetActive(yuan2, false);
    }

    private void OnDisable() {
        onBagView = false;
        ItemTips.instance.ClickClose();
        EventManager.RemoveEvent(EventTyp.ItemChange, OnItemChange);
        EventManager.RemoveEvent(EventTyp.BeginDragItem, OnItemBeginDragItem);
        EventManager.RemoveEvent(EventTyp.DragItem, OnItemDragItem);
        EventManager.RemoveEvent(EventTyp.EndDragItem, OnItemEndDragItem);
    }

    private void OnItemBeginDragItem(object param) {
        ItemData item = (ItemData)param;
        dragItem.GetComponent<BagItem>().SetItem(item);
        dragItem.gameObject.SetActive(true);
        ShowMask(item, true);
    }

    private void OnItemDragItem(object param) {
        Vector2 size = ((RectTransform)MainUI.instance.transform).sizeDelta;
        Vector2 pos = Input.mousePosition;
        Vector2 result = new Vector2(pos.x / Screen.width * size.x, pos.y / Screen.height * size.y);
        dragItem.anchoredPosition = result;
    }

    private void OnItemEndDragItem(object param) {
        dragItem.gameObject.SetActive(false);
        ItemData item = (ItemData)param;
        ShowMask(item, false);

        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        if (static_data.sub_ype == ItemSubType.Ring && equip_items[0].onItem) {
            RoleData.mainRole.EquipItem(item.id);
        } else if (static_data.sub_ype == ItemSubType.Ride && equip_items[1].onItem) {
            RoleData.mainRole.EquipItem(item.id);
        } else if (static_data.sub_ype == ItemSubType.recoverRemedy || static_data.sub_ype == ItemSubType.buffRemedy) {
            for (int idx = 0; idx < battle_items.Length; idx++) {
                if (battle_items[idx].onItem) {
                    RoleData.mainRole.EquipItem(item.id, idx);
                    break;
                }
            }
        }
    }

    private void ShowMask(ItemData item, bool show) {
        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        switch (static_data.sub_ype) {
            case ItemSubType.Ring:
                yuan1.SetActive(show);
                break;
            case ItemSubType.Ride:
                yuan2.SetActive(show);
                break;
            case ItemSubType.recoverRemedy:
            case ItemSubType.buffRemedy:
                fang.SetActive(show);
                break;
        }
    }

    public void OnTypeToggle(Toggle Tog) {
        show_pack = (ItemType)int.Parse(Tog.name);
        UpdateUI();
    }

    public void OnSubTypeToggle(int idx) {
    }

    void OnItemChange(object param) {
        UpdateUI(true);
    }

    private void UpdateUI(bool isChange = false) {
        if (RoleData.mainRole == null)
            return;
        max_item = RoleData.mainRole.GetAttr(RoleAttribute.max_item);
        if (show_pack == ItemType.end) {
            show_items = RoleData.mainRole.bag_items;
        } else {
            show_items = new List<int>();
            foreach (int item_id in RoleData.mainRole.bag_items) {
                if (GameData.instance.item_static_data[GameData.instance.all_item[item_id].static_id].type == show_pack) {
                    show_items.Add(item_id);
                }
            }
            max_item = show_items.Count;
        }
        line_count = (int)Mathf.Ceil(max_item * 1f / child_count);
        // 设置背包
        if (!isChange) {
            scrollView.verticalNormalizedPosition = 1;
        }
        bigDataScroll.cellCount = line_count;

        // 设置装备
        for (int i = 0; i < equip_items.Length; i++) {
            int item_id = RoleData.mainRole.equip_items[i];
            ItemData item;
            if (item_id >= 0) {
                item = GameData.instance.all_item[item_id];
            } else {
                item = null;
            }
            BagItem bagItem = equip_items[i];
            bagItem.SetItem(item, RoleData.mainRole, isRound: true, show_count: MessageData.GetMessage(29 + i), clickFunc: bagItem.BtnEquip);
        }

        // 设置战斗药
        for (int i = 0; i < battle_items.Length; i++) {
            int item_id = RoleData.mainRole.remedy_items[i];
            ItemData item;
            if (item_id >= 0) {
                item = GameData.instance.all_item[item_id];
            } else {
                item = null;
            }
            BagItem bagItem = battle_items[i];
            bagItem.SetItem(item, RoleData.mainRole, show_count: item == null?"":(item.count > 5 ? 5 : item.count).ToString(), clickFunc: bagItem.BtnEquip);
        }
    }

    private void SetData(ItemCell go, int index) {
        index = index - 1;
        int item_count = show_items.Count;
        for (int i = 0; i < child_count; i++) {
            int idx = index * child_count + i;
            go.transform.GetChild(i).gameObject.SetActive(idx < max_item);
            ItemData item;
            if (idx < item_count) {
                item = GameData.instance.all_item[show_items[idx]];
            } else {
                item = null;
            }
            go.transform.GetChild(i).GetComponent<BagItem>().SetItem(item, RoleData.mainRole, true);
        }
    }

    private void Update() {
        if (onBagView) {
            float value = Input.GetAxisRaw("Mouse ScrollWheel");
            if (value != 0) {
                scrollView.verticalNormalizedPosition += mouseSpeed * value * Time.deltaTime/ Mathf.Max(1, line_count - 5);
            }
        }
    }
}
