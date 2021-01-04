using ARPGDemo.Skill;
using System.Collections.Generic;
using UnityEngine;

namespace ARPGDemo.Character
{
    public abstract class CharacterStatus :MonoBehaviour, IOnDamage
    {
        public CharacterBase chBase;

        public abstract void Dead();

        /// <summary>
        /// 受到伤害 
        /// </summary>
        public virtual void OnDamage(int damageVal, SkillData skillData)
        {
            // 实现 有一部分相同 有一部分不同 > 虚的
            damageVal = Mathf.Max(damageVal - chBase.Defence, 0);
            var min = damageVal * 0.8f;
            var max = damageVal * 1.2f;
            damageVal = (int)Mathf.Max(Mathf.Floor(Random.Range(min, max)), 0);

            YellowEvents.SendEvent(YellowEventName.chatacterDamage, new object[] { gameObject, damageVal });
            chBase.HP = Mathf.Max(chBase.HP - damageVal, 0);
            if (chBase.HP <= 0) {
                Dead();
            }

            // 有部分不同的 在子类实现
        }

        // 受到伤害后，播放受击特效，首先要找到受击特效 挂载点
        public Transform HitFxPos;
        protected void Start() {
            if (null == HitFxPos) {
                HitFxPos = TransformHelper.FindChild(transform, "HitFxPos");
                if (null == HitFxPos) {
                    YellowEvents.SendEvent(YellowEventName.error, YellowErrorText.notHitFxPos + gameObject.name);
                    HitFxPos = transform;
                }
            }
        }

        private void OnEnable() {
            YellowEvents.SendEvent(YellowEventName.enableStatus, gameObject);
        }

        private void OnDisable() {
            YellowEvents.SendEvent(YellowEventName.disableStatus, gameObject);
        }
    }
}