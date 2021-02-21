using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GMCommand : MonoBehaviour
{
    bool on_gm;
    List<string> gm_msg;
    int max_msg=100;
    GameObject gm;
    InputField input;
    Text show;
    string command = "";
    private void Awake() {
        gm_msg = new List<string>();
    }

    private void InitUI() {
        Font font= FindObjectOfType<Text>().font;
        RectTransform canvas = (RectTransform)GuiBaseUI.CreateUI.NewCanvas().transform;
        RectTransform bg = (RectTransform)GuiBaseUI.CreateUI.NewImage().transform;
        bg.SetParent(canvas, false);
        RectTransform txt = (RectTransform)GuiBaseUI.CreateUI.NewText().transform;
        txt.SetParent(bg, false);
        input = bg.gameObject.AddComponent<InputField>();
        input.targetGraphic = input.GetComponent<Image>();
        input.textComponent = txt.GetComponent<Text>();
        txt.GetComponent<Text>().font = font;
        txt.GetComponent<Text>().color = Color.black;
        txt.GetComponent<Text>().alignment = TextAnchor.MiddleLeft;

        gm = canvas.gameObject;

        bg.anchorMin = new Vector2(0, 0);
        bg.anchorMax = new Vector2(1, 0);
        bg.pivot = new Vector2(.5f, 0);
        bg.sizeDelta = new Vector2(-40, 40);
        bg.anchoredPosition = new Vector2(0, 10);

        txt.anchorMin = new Vector2(0, 0);
        txt.anchorMax = new Vector2(1, 1);
        txt.anchoredPosition = new Vector2(0, 0);
        txt.sizeDelta = new Vector2(-10, 0);

        RectTransform show = (RectTransform)GuiBaseUI.CreateUI.NewText().transform;
        show.SetParent(canvas, false);
        this.show = show.GetComponent<Text>();
        this.show.font = font;
        this.show.color = Color.red;
        this.show.alignment = TextAnchor.LowerLeft;
        this.show.raycastTarget = false;

        show.anchorMin = new Vector2(0, 0);
        show.anchorMax = new Vector2(1, 0);
        show.pivot = new Vector2(.5f, 0);
        show.sizeDelta = new Vector2(-40, canvas.sizeDelta.y * 2);
        show.anchoredPosition = new Vector2(0, 60);

        input.onValueChanged.AddListener(OnInputChange);
    }

    private void OnInputChange(string value) {
        if (!value.EndsWith("`") && !value.EndsWith("¡¤")) {
            command = input.text;
        }
    }

    private void Update() {
        if (Input.GetKeyDown(KeyCode.BackQuote)|| Input.GetKeyDown(KeyCode.Tilde)) {
            on_gm = !on_gm;
            if (gm == null) {
                InitUI();
            }
            gm.SetActive(on_gm);
            if (on_gm) {
                input.ActivateInputField();
                input.text = command;
            }
        }
        if(on_gm){
            if (Input.GetKeyDown(KeyCode.Return)) {
                string command = input.text;
                if (!string.IsNullOrWhiteSpace(command)) {
                    try {
                        DoCommand(command);
                    } catch (System.Exception e) {
                        AddMsg(e.Message);
                        AddMsg(e.StackTrace);
                    }
                }
                input.ActivateInputField();
            }
        }
    }

    private void AddMsg(string msg) {
        if (!string.IsNullOrWhiteSpace(msg)) {
            gm_msg.Add(msg);
            if (gm_msg.Count > max_msg) {
                gm_msg.RemoveAt(0);
            }
            show.text = string.Join("\n", gm_msg.ToArray());
        }
    }

    string err_command = "please input command: additem, clearbag, clearlog, set, game";

    private void DoCommand(string command) {
        string[] str = command.Split(' ');
        if (RoleData.mainRole == null) {
            AddMsg("can't find mainRole.");
        }

        switch (str[0].ToLower().Trim()) {
            case "additem":
                if (str.Length < 2) {
                    AddMsg("please input command: additem item_id count.");
                    break;
                }
                int count = 1;
                if (str.Length > 2) {
                    count = int.Parse(str[2]);
                }
                string[] ids = str[1].Split('-');
                if (ids.Length == 2) {
                    int min_id = int.Parse(ids[0]);
                    int max_id = int.Parse(ids[1]);
                    for (int item_id = min_id; item_id <= max_id; item_id++) {
                        int c = count;
                        RoleData.mainRole.AddOrCreateItem(item_id, ref c);
                    }
                } else {
                    int item_id = int.Parse(str[1]);
                    RoleData.mainRole.AddOrCreateItem(item_id, ref count);
                }
                break;
            case "clearbag":
                List<int> rm = new List<int>(); ;
                foreach (var item in RoleData.mainRole.bag_items) {
                    if (!RoleData.mainRole.ItemIsEquip(item)) {
                        rm.Add(item);
                    }
                }
                foreach (var item in rm) {
                    RoleData.mainRole.RemoveItem(item, 0);
                }
                break;
            case "clearlog":
                gm_msg.Clear();
                show.text = string.Join("\n", gm_msg.ToArray());
                break;
            case "set":
                if (str.Length < 2) {
                    AddMsg("please input command: set attributeName value. set value.");
                    break;
                }
                int set_value;
                if (str.Length < 2) {
                    set_value = int.Parse(str[1]);
                    for (RoleAttribute i = 0; i < RoleAttribute.modao; i++) {
                        RoleData.mainRole.SetAttrebuteValue(i, set_value);
                    }
                    RoleData.mainRole.SetAttrebuteValue(RoleAttribute.max_item, set_value);
                    RoleData.mainRole.SetAttrebuteValue(RoleAttribute.xinde, set_value);
                    RoleData.mainRole.SetAttrebuteValue(RoleAttribute.daodian, set_value);
                    RoleData.mainRole.SetAttrebuteValue(RoleAttribute.coin, set_value);
                    RoleData.mainRole.SetAttrebuteValue(RoleAttribute.contributions, set_value);
                    RoleData.mainRole.SetAttrebuteValue(RoleAttribute.city_token, set_value);
                    break;
                }
                RoleAttribute attr = (RoleAttribute)Enum.Parse(typeof(RoleAttribute), str[1]);
                set_value = int.Parse(str[2]);
                RoleData.mainRole.SetAttrebuteValue(attr, set_value);
                break;
            case "game":
                if (str.Length < 3) {
                    AddMsg("please input command: set attributeName value.");
                    break;
                }if (GameData.instance!=null) {
                    GlobalAttribute gattr = (GlobalAttribute)Enum.Parse(typeof(GlobalAttribute), str[1]);
                    long gvalue = long.Parse(str[2]);
                    GameData.instance.SetGameData(gattr, gvalue);
                } else {
                    AddMsg("can't find GameData.");
                }
                break;
            case "test":
                break;
            default:
                AddMsg("please input command:" + err_command);
                break;
        }
    }
}
