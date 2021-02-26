using GuiBaseUI;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class GongfaUI : MonoBehaviour {
    public BigDataScroll bigDataScroll;
    public ScrollRect scrollView;
    public GameObject viewport;
    public ItemCell itemCell;
    public float mouseSpeed = 100;
    public GameObject atk_root;
    public GameObject heart_root;
    public GongfaItem[] atk_items;
    public GongfaItem[] heart_items;

    public GameObject yuan;
    public GameObject yuan1;
    public GameObject yuan2;
    public GameObject yuan3;
    public GameObject yuan4;
    public RectTransform dragItem;

    int max_item;
    int child_count;
    ItemSubType show_pack = ItemSubType.Attack;
    List<GongfaData> show_items;
    bool onBagView;
    int line_count;

    public Text t_daodian;

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
        OnAttrUpdate(null);
        EventManager.AddEvent(EventTyp.GongfaChange, OnGongfaChange);
        EventManager.AddEvent(EventTyp.BeginDragItem, OnItemBeginDragItem);
        EventManager.AddEvent(EventTyp.DragItem, OnItemDragItem);
        EventManager.AddEvent(EventTyp.EndDragItem, OnItemEndDragItem);
        EventManager.AddEvent(EventTyp.AttrChange, OnAttrUpdate);

        Tools.SetActive(yuan, false);
        Tools.SetActive(yuan1, false);
        Tools.SetActive(yuan2, false);
        Tools.SetActive(yuan3, false);
        Tools.SetActive(yuan4, false);
    }

    private void OnDisable() {
        onBagView = false;
        ItemTips.instance.ClickClose();
        EventManager.RemoveEvent(EventTyp.GongfaChange, OnGongfaChange);
        EventManager.RemoveEvent(EventTyp.BeginDragItem, OnItemBeginDragItem);
        EventManager.RemoveEvent(EventTyp.DragItem, OnItemDragItem);
        EventManager.RemoveEvent(EventTyp.EndDragItem, OnItemEndDragItem);
        EventManager.RemoveEvent(EventTyp.AttrChange, OnAttrUpdate);
    }

    private void OnItemBeginDragItem(object param) {
        GongfaData gongfa = (GongfaData)param;
        dragItem.GetComponent<GongfaItem>().SetItem(gongfa);
        dragItem.gameObject.SetActive(true);

        int item_id = gongfa.item_id;
        ItemData item = GameData.instance.all_item[item_id];
        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        ShowMask(static_data, true);
    }

    private void OnItemDragItem(object param) {
        Vector2 size = ((RectTransform)MainUI.instance.transform).sizeDelta;
        Vector2 pos = Input.mousePosition;
        Vector2 result = new Vector2(pos.x / Screen.width * size.x, pos.y / Screen.height * size.y);
        dragItem.anchoredPosition = result;
    }

    private void OnItemEndDragItem(object param) {
        dragItem.gameObject.SetActive(false);
        GongfaData gongfa = (GongfaData)param;
        int item_id = gongfa.item_id;
        ItemData item = GameData.instance.all_item[item_id];
        ItemStaticData static_data = GameData.instance.item_static_data[item.static_id];
        ShowMask(static_data, false);

        switch (static_data.sub_ype) {
            case ItemSubType.Heart:
                for (int i = 0; i < heart_items.Length; i++) {
                    if (heart_items[i].onItem) {
                        RoleData.mainRole.EquipGongfa(gongfa, i);
                        break;
                    }
                }
                break;
            case ItemSubType.Attack:
                if (atk_items[0].onItem) {
                    RoleData.mainRole.EquipGongfa(gongfa);
                }
                break;
            case ItemSubType.Skill:
                if (atk_items[1].onItem) {
                    RoleData.mainRole.EquipGongfa(gongfa);
                }
                break;
            case ItemSubType.Body:
                if (atk_items[2].onItem) {
                    RoleData.mainRole.EquipGongfa(gongfa);
                }
                break;
            case ItemSubType.Magic:
                if (atk_items[3].onItem) {
                    RoleData.mainRole.EquipGongfa(gongfa);
                }
                break;
        }
    }

    private void ShowMask(ItemStaticData static_data, bool show) {
        switch (static_data.sub_ype) {
            case ItemSubType.Heart:
                yuan.SetActive(show);
                break;
            case ItemSubType.Attack:
                yuan1.SetActive(show);
                break;
            case ItemSubType.Skill:
                yuan2.SetActive(show);
                break;
            case ItemSubType.Body:
                yuan3.SetActive(show);
                break;
            case ItemSubType.Magic:
                yuan4.SetActive(show);
                break;
        }
    }

    public void OnTypeToggle(Toggle Tog) {
        show_pack = (ItemSubType)int.Parse(Tog.name);
        UpdateUI();
    }

    public void OnSubTypeToggle(int idx) {
    }

    void OnGongfaChange(object param) {
        UpdateUI();
    }

    void OnAttrUpdate(object prarm) {
        if (RoleData.mainRole == null)
            return;
        t_daodian.text = string.Format("{0}/{1}", RoleData.mainRole.GetAttr(RoleAttribute.daodian), RoleData.mainRole.GetMaxAttr(RoleAttribute.daodian));
    }

    private void UpdateUI() {
        if (RoleData.mainRole == null)
            return;


        show_items = new List<GongfaData>();
        foreach (GongfaData gongfa in RoleData.mainRole.all_gongfa) {
            int item_id = gongfa.item_id;
            if (GameData.instance.item_static_data[GameData.instance.all_item[item_id].static_id].sub_ype == show_pack) {
                show_items.Add(gongfa);
            }
        }
        max_item = show_items.Count;

        line_count = (int)Mathf.Ceil(max_item * 1f / child_count);
        // 设置背包
        scrollView.verticalNormalizedPosition = 1;
        bigDataScroll.cellCount = line_count;


        bool show_heart = show_pack == ItemSubType.Heart;
        Tools.SetActive(atk_root, !show_heart);
        Tools.SetActive(heart_root, show_heart);
        if (show_heart) {
            // 显示心法
            GongfaData[] hearts = RoleData.mainRole.heart_gongfa;
            for (int i = 0; i < hearts.Length; i++) {
                heart_items[i].SetItem(hearts[i], RoleData.mainRole);
            }
        } else {
            // 显示武功
            atk_items[0].SetItem(RoleData.mainRole.attack_gongfa, RoleData.mainRole);
            atk_items[1].SetItem(RoleData.mainRole.skill_gongfa, RoleData.mainRole);
            atk_items[2].SetItem(RoleData.mainRole.body_gongfa, RoleData.mainRole);
            atk_items[3].SetItem(RoleData.mainRole.magic_gongfa, RoleData.mainRole);
        }
    }

    private void SetData(ItemCell go, int index) {
        index = index - 1;
        int item_count = show_items.Count;
        for (int i = 0; i < child_count; i++) {
            int idx = index * child_count + i;
            go.transform.GetChild(i).gameObject.SetActive(idx < max_item);
            GongfaData item;
            if (idx < item_count) {
                item = show_items[idx];
            } else {
                item = null;
            }
            go.transform.GetChild(i).GetComponent<GongfaItem>().SetItem(item, RoleData.mainRole, true);
        }
    }

    private void Update() {
        if (onBagView) {
            float value = Input.GetAxisRaw("Mouse ScrollWheel");
            if (value != 0) {
                scrollView.verticalNormalizedPosition += mouseSpeed * value * Time.deltaTime / Mathf.Max(1, line_count - 5);
            }
        }
    }
}
