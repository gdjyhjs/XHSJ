using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ItemTip : MonoBehaviour {
    public Text item_name;
    public Text item_type;
    public Text item_sub_type;
    public Text item_need_lv;
    public Text item_describe;
    public Text item_attr;
    public Image item_bg;
    public Image item_color;
    public Image item_icon;
    public GameObject item_use;

    public void ShowTip(ItemData item) {
        gameObject.SetActive(true);
        UpdateItem(item);
    }

    private void UpdateItem(ItemData item) {
        ItemStaticData staticData = GameData.instance.item_static_data[item.id];

        item_name.text = staticData.name;
        item_type.text = GameConst.itemTypeName[staticData.type];
        item_sub_type.text = GameConst.itemSubTypeName[staticData.sub_ype];
        item_need_lv.text = LevelConfigData.GetBigName(staticData.level);
        item_describe.text = staticData.des;
        item_attr.text = "";
        item_bg.sprite = UIAssets.instance.bgColor[staticData.color];
        item_color.sprite = UIAssets.instance.itemColor[staticData.color];
        item_icon.sprite = UIAssets.instance.itemIcon[staticData.icon];
        item_use.SetActive(false);
    }
}
