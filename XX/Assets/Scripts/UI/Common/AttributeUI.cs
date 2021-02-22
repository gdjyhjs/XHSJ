using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Wanderer.EmojiText;

public class AttributeUI : MonoBehaviour {

    public Text modao;
    public Text zhengdao;
    public Image modaoImg;
    public Image zhengdaoImg;
    UIProgress modaoP;
    UIProgress zhengdaoP;
    struct AttributeItem {
        public Image add1;
        public Image add2;
        public InlineText name;
        public Text value;
        public Text addvalue;
        public UIProgress progress;
        public UIHide hide;
    }

   AttributeItem[] attrs;
    private void Awake() {
        Transform tf = transform.GetChild(0);
        int childcount = tf.childCount;
        attrs = new AttributeItem[childcount];
        for (int i = 0; i < childcount; i++) {
            Transform child = tf.GetChild(i);
            int itemcount = child.childCount;
            Transform nametf = child.GetChild(0);
            InlineText name = nametf.GetComponent<InlineText>();
            Image add1 = nametf.GetChild(0).GetComponent<Image>();
            Image add2 = nametf.GetChild(1).GetComponent<Image>();
            add1.sprite = add2.sprite;
            add2.transform.position = add1.transform.position;

            Text value;
            Text addvalue;
            UIHide hide;
            UIProgress progress;
            if (itemcount == 3) {
                Transform rtf = child.GetChild(1);
                progress = rtf.gameObject.AddComponent<UIProgress>();
                addvalue = rtf.GetChild(0).GetComponent<Text>();
                hide = addvalue.gameObject.AddComponent<UIHide>();
                hide.speed = 0.4f;
                value = child.GetChild(2).GetComponent<Text>();
            } else {
                progress = null;
                addvalue = null;
                hide = null;
                value = child.GetChild(1).GetComponent<Text>();
            }
            attrs[i] = new AttributeItem() { name= name, add1 = add1, add2 = add2 , value = value ,
                addvalue = addvalue , progress = progress , hide = hide };
        }

        modaoP = modaoImg.gameObject.AddComponent<UIProgress>();
        zhengdaoP = zhengdaoImg.gameObject.AddComponent<UIProgress>();
    }

    RoleData showRoleData;
    bool onEnable = false;
    private void OnEnable() {
        onEnable = true;
        if (RoleData.mainRole != null) {
            ShowRoleAttr(RoleData.mainRole);
        }
        onEnable = false;
        EventManager.AddEvent(EventTyp.AttrChange, OnChange);
        EventManager.AddEvent(EventTyp.MinValueChange, OnChange);
    }

    private void OnDisable() {
        EventManager.RemoveEvent(EventTyp.AttrChange, OnChange);
        EventManager.RemoveEvent(EventTyp.MinValueChange, OnChange);
        EnterPointTips.instance.HideTips();
        showRoleData = null;
    }

    void OnChange(object roleData) {
        if ((RoleData)roleData == showRoleData) {
            ShowRoleAttr((RoleData)roleData);
        }
    }

    public void ShowRoleAttr(RoleData roleData) {
        showRoleData = roleData;
        ShowAttr(showRoleData.GetAllAttr(), showRoleData.GetAllMaxAttr(), RoleAttrConfigData.GetAttrConfig(), showRoleData.sex);
    }

    int last_charm;
    public void ShowAttr(int[] min_attribute, int[] max_attribute, RoleAttrConfig[] attribute_config, Sex sex) {
        if (attrs == null)
            return;
        int count = attrs.Length;
        for (int i = 0; i < count; i++) {
            attrs[i].name.text = attribute_config[i].name;
            attrs[i].name.name = attribute_config[i].describe;

            int last_value=0, new_value=0;
            int add2value = attribute_config[i].randMin + (int)((attribute_config[i].randMax - attribute_config[i].randMin) * 0.9f);
            int add1value = attribute_config[i].randMin + (int)((attribute_config[i].randMax - attribute_config[i].randMin) * 0.75f);
            int changevalue = 0;
            string text = default;
            bool show1 = default,show2 = default;
            string last_text = attrs[i].value.text;
            if (last_text == null) {
                last_text = "0";
            }
            new_value = max_attribute[i];
            if (new_value < 0) {
                new_value = 0;
            }
            switch (attribute_config[i].type) {
                case RoleAttrShowType.None:
                    int.TryParse(attrs[i].value.text, out last_value);
                    text = string.Format("{0}", new_value);
                    show1 = false;
                    show2 = false;
                    changevalue = (new_value - last_value);
                    break;
                case RoleAttrShowType.FixedMinMax:
                case RoleAttrShowType.MinMax:
                    int.TryParse(attrs[i].value.text.Split('/')[0], out last_value);
                    text = string.Format("{0}/{1}", min_attribute[i], new_value);
                    show1 = min_attribute[i] >= add1value;
                    show2 = min_attribute[i] >= add2value;
                    changevalue = (new_value - last_value);
                    break;
                case RoleAttrShowType.Progress:
                    int.TryParse(attrs[i].value.text, out last_value);
                    text = string.Format("{0}", new_value);
                    show1 = min_attribute[i] >= add1value;
                    show2 = min_attribute[i] >= add2value;
                    changevalue = (new_value - last_value);
                    break;
                case RoleAttrShowType.RateProgress:
                    int.TryParse(attrs[i].value.text.Substring(0, attrs[i].value.text.Length-1), out last_value);
                    text = string.Format("{0}%", new_value);
                    show1 = min_attribute[i] >= add1value;
                    show2 = min_attribute[i] >= add2value;
                    changevalue = (new_value - last_value);
                    break;
                case RoleAttrShowType.Text:
                    last_value = last_charm;
                    text = RoleAttrConfig.GetValue(new_value, sex);
                    show1 = min_attribute[i] >= add1value;
                    show2 = min_attribute[i] >= add2value;
                    changevalue = (new_value - last_value);
                    last_charm = max_attribute[i];
                    break;
            }

            if (attrs[i].progress) {
                attrs[i].progress.name = string.Format("({0}-{1})*100/({2}-{3})", min_attribute[i], attribute_config[i].progressMin, attribute_config[i].progressMax, attribute_config[i].progressMin);
                float progress = (new_value - attribute_config[i].progressMin) * 100f / (attribute_config[i].progressMax - attribute_config[i].progressMin);
                float old_progress = (last_value - attribute_config[i].progressMin) * 100f / (attribute_config[i].progressMax - attribute_config[i].progressMin);

                if (progress > 0) {
                    progress += 4;
                }
                if (old_progress > 0) {
                    old_progress += 4;
                }

                old_progress = Mathf.Min(Mathf.Max(old_progress, 0), 100);
                progress = Mathf.Min(Mathf.Max(progress, 0), 100);
                if (onEnable) {
                    attrs[i].progress.SetMove(progress, progress);
                } else {
                    attrs[i].progress.SetMove(old_progress, progress);
                }
            }

            attrs[i].value.text = text;
            if (RoleData.mainRole != null) {
                attrs[i].add1.enabled = false;
                attrs[i].add2.enabled = false;
            } else {
                attrs[i].add1.enabled = !show2 && show1;
                attrs[i].add2.enabled = show2;
            }


            if (!onEnable) {
                if (changevalue != 0 && attrs[i].addvalue) {
                    if (changevalue > 0) {
                        attrs[i].addvalue.color = new Color(0x00 / 255f, 0x93 / 255f, 0x16 / 255f);
                        attrs[i].addvalue.text = "+" + changevalue.ToString();
                    } else {
                        attrs[i].addvalue.color = new Color(0xFF / 255f, 0x00 / 255f, 0x0C / 255f);
                        attrs[i].addvalue.text = changevalue.ToString();
                    }
                    attrs[i].hide.Rest();
                }
            }
        }

        int zheng = max_attribute[(int)RoleAttribute.zhengdao];
        int mo = max_attribute[(int)RoleAttribute.modao];
        int ozheng = int.Parse(zhengdao.text);
        int omo = int.Parse(modao.text);
        float max = zheng + mo;
        float old_max = ozheng + omo;
        float old_zheng = int.Parse(zhengdao.text) / old_max;
        float old_mo = int.Parse(modao.text) / old_max;
        float new_zheng = zheng / max;
        float new_mo = mo / max;

        zhengdaoP.SetMove(old_zheng * 180 + 1, new_zheng * 180 + 1);
        modaoP.SetMove(old_mo * 180 + 1, new_mo * 180 + 1);
        zhengdao.text = zheng.ToString();
        modao.text = mo.ToString();
        zhengdao.name = attribute_config[40].describe;
        modao.name = attribute_config[41].describe;
    }


    public void EnterAttrName(int idx) {
        EnterPointTips.instance.ShowTips(attrs[idx].name.name, (RectTransform)attrs[idx].name.transform);
    }

    public void ExitAttrName(int idx) {
        EnterPointTips.instance.HideTips();
    }


    public void EnterDao(int idx) {
        if (idx == 0) {
            EnterPointTips.instance.ShowTips(zhengdao.name, (RectTransform)zhengdaoImg.transform);
        } else {
            EnterPointTips.instance.ShowTips(modao.name, (RectTransform)modaoImg.transform);
        }
    }

}
