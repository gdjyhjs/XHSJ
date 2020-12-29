using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TopInfoShow : MonoBehaviour
{
    public RectTransform tfHP;
    public Text txtState;
    public Text txtHp;
    private RectTransform tf;
    public GameObject hpRoot;
    bool onShow = true;
    public GameObject damagePrefab;

    void Start()
    {
        tf = (RectTransform)transform;
    }

    public void ChatacterDamage(int value) {
        GameObject obj = GameObjectPool.instance.CreateObject("ui_damagePrefab", damagePrefab, default, default);
        obj.GetComponent<DamageShow>().SetDamage(value, transform);
    }

    public void UpdateState(TopInfo top) {
        var fsm = top.fsm;
        var isVisible = true;
        if (fsm) {
            isVisible = fsm.isVisible;
        }
        if (isVisible != onShow) {
            if (isVisible) {
                transform.localScale = Vector3.one;
            } else {
                transform.localScale = default;
            }
            onShow = isVisible;
        }
        if (!onShow)
            return;

        Vector3 pos = top.charTf.position + new Vector3(0, 1.55f, 0);
        tf.anchoredPosition = WorldPointToUILocalPoint(pos);
        tfHP.sizeDelta = new Vector2(150f * top.status.HP / top.status.MaxHP, tfHP.sizeDelta.y);
        if (top.status.HP <= 0) {
            txtState.text = ((int)(top.status.NextReviveTime - Time.time)).ToString();
        } else {
            //string stateName = "";
            //switch (fsm.currentStateID) {
            //    case AI.FSM.FSMStateID.Dead:
            //        stateName = "死亡";
            //        break;
            //    case AI.FSM.FSMStateID.Pursuit:
            //        stateName = "追杀";
            //        break;
            //    case AI.FSM.FSMStateID.Attacking:
            //        stateName = "攻击";
            //        break;
            //    //case AI.FSM.FSMStateID.None:
            //    //case AI.FSM.FSMStateID.Idle:
            //    //case AI.FSM.FSMStateID.Default:
            //    default:
            //        stateName = "发呆";
            //        break;
            //}
            //txtState.text = stateName + "...";
            txtState.text = top.status.charName;
        }
        bool show = top.status.HP != top.status.MaxHP;
        if (show != hpRoot.activeSelf)
            hpRoot.SetActive(show);
        if (show) {
            txtHp.text = string.Format("{0}/{1}", top.status.HP, top.status.MaxHP);
        }
    }

    private Vector2 WorldPointToUILocalPoint(Vector3 point) {
        Vector3 screenPoint = _3DCamera.mainCamera.WorldToScreenPoint(point);
        Vector2 localPoint;
        RectTransformUtility.ScreenPointToLocalPointInRectangle((RectTransform)MainCanvas.canvas.transform, screenPoint, UICamera.uiCamera, out localPoint);
        return localPoint;
    }
}
