using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace UMAWorld {
    public class UIWorldMain : UIBase {
        public UnitBase unit;
        public Image hpFill;
        public Image mpFill;
        public Text hpText;
        public Text mpText;

        public LanguageText nameText;
        public LanguageText dateText;
        public LanguageText weatherText;
        public LanguageText timeText;


        private void Awake() {
            g.uiWorldMain = this;
        }

        private void Start() {
            One();
        }

        public void One() {
            UpdateUI();
            Invoke("One", 1);
        }

        public void UpdateUI() {
            if (unit == null)
                return;
            nameText.Text(unit.id, false);
            UpdateHP();
            UpdateMP();
            UpdateTime();
        }

        public void UpdateHP() {
            hpText.text = unit.attribute.hp + "/" + unit.attribute.maxHp;
            hpFill.fillAmount = unit.attribute.health_cur / unit.attribute.health_max;
        }

        public void UpdateMP() {
            mpText.text = unit.attribute.mp + "/" + unit.attribute.maxMp;
            mpFill.fillAmount = unit.attribute.magic_cur / unit.attribute.magic_max;
        }

        public void UpdateTime() {
            System.DateTime date = g.date.Time;
            dateText.ChangeParam(date.Year, new LanguageText.LanguageParam(DateMgr.ToMonth(date.Month), true), date.Day);

            weatherText.text = g.date.weather.ToString();

            timeText.ChangeParam(date.Hour, date.Minute);

        }
    }
}