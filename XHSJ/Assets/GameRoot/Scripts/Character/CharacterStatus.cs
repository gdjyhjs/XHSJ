using ARPGDemo.Skill;
using UnityEngine;

namespace ARPGDemo.Character
{
    public abstract class CharacterStatus :MonoBehaviour, IOnDamage
    {
        public string charName;

        /// <summary>
        /// 攻击距离
        /// </summary>
        public float attackDistance;

        /// <summary>
        /// 攻击速度
        /// </summary>
        public float attackSpeed;

        /// <summary>
        /// 伤害
        /// </summary>
        public int Damage;

        /// <summary>
        /// 防御
        /// </summary>
        public int Defence;

        /// <summary>
        /// 生命
        /// </summary>
        public int HP;

        /// <summary>
        /// 最大生命
        /// </summary>
        public int MaxHP;

        /// <summary>
        /// 最大魔法
        /// </summary>
        public int MaxSP;

        /// <summary>
        /// 魔法
        /// </summary>
        public int SP;

        /// <summary>
        /// 复活时间
        /// </summary>
        public int ReviveTime = 60;

        /// <summary>
        /// 下一次复活的时间
        /// </summary>
        public int NextReviveTime = 0;

        public abstract void Dead();


        /// <summary>
        /// 受到伤害 
        /// </summary>
        public virtual void OnDamage(int damageVal, SkillData skillData)
        {
            // 实现 有一部分相同 有一部分不同 > 虚的
            damageVal = Mathf.Max(damageVal - Defence, 0);
            var min = damageVal * 0.8f;
            var max = damageVal * 1.2f;
            damageVal = (int)Mathf.Max(Mathf.Floor(Random.Range(min, max)), 0);

            YellowEvents.SendEvent(YellowEventName.chatacterDamage, new object[] { gameObject, damageVal });
            HP = Mathf.Max(HP - damageVal, 0);
            if (HP <= 0) {
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