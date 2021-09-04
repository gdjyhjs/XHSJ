using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace UMAWorld {
    // 存在修仙世界上的单位
    public class SkillMono : MonoBehaviour {
        public UnitBase ownerUnit;
        public UnitMono ownerMono;
        public SkillBase skillData;
        public ConfSkillItem skillConf;
        public Vector3 targetPos;
        public float duration; // 持续时间
        public float through; // 穿透次数


        public void Init(UnitBase ownerUnit, UnitMono ownerMono, SkillBase skillData, Vector3 targetPos) {
            this.ownerUnit = ownerUnit;
            this.ownerMono = ownerMono;
            this.skillData = skillData;
            this.targetPos = targetPos;
            skillConf = g.conf.skill.GetItem(skillData.ID);
            duration = skillConf.duration;
            through = skillConf.through;
        }

        protected virtual void Start() {

        }

        protected virtual void Update() {
            duration -= Time.deltaTime;
            if (duration <= 0) {
                Destroy();
            }
        }

        protected virtual void Destroy() {
            Destroy(gameObject);
        }

        protected virtual void OnTriggerEnter(Collider other) {
            if (ownerMono.gameObject == other.gameObject) {
                //撞到自己不算数
                return;
            }
            if (other.tag == GameConf.unitTag) {
                UnitMono enemy = other.GetComponent<UnitMono>();
                if (enemy && !enemy.unitData.isDie) {
                    OnHit(enemy);
                }
            }
        }

        protected virtual void OnHit(UnitMono[] target) {

            for (int i = 0; i < target.Length; i++) {

            }
        }

        protected virtual void OnHit(UnitMono target) {

            ConfSkillItem conf = g.conf.skill.GetItem(skillData.ID);
            SkillQuale skillQuale = (SkillQuale)conf.skillQuale;
            SkillType skillType = (SkillType)conf.skillType;

            float value = conf.might * ownerUnit.attribute.attack;
            value *= CommonTools.Random(0.8f, 1.2f);
            target.unitData.SkillEffect(value, ownerUnit, skillQuale, skillType);

            if (--through < 0) {
                Destroy();
            }
        }
    }
}