using UnityEngine;
using System.Collections.Generic;
using ARPGDemo.Character;
using System.Collections;

namespace ARPGDemo.Skill {
    /// <summary>
    /// 技能释放器
    /// </summary>
    public abstract class SkillDeployer : MonoBehaviour {
        private SkillData m_SkillData;
        public EnterTriggerRecord enterTrigger;

        public SkillData skillData
        {
            get
            {
                return m_SkillData;
            }
            set
            {
                if (null == value)
                    return;
                // 为了提高性能

                m_SkillData = value;
                attackSelector = DeployerConfigFactory.CreateAttackSelector(m_SkillData);
                listSelfImpact = DeployerConfigFactory.CreateSelfImpact(m_SkillData);
                listTargetImpact = DeployerConfigFactory.CreateTargetImpact(m_SkillData);
            }
        }

        protected IAttackSelector attackSelector;
        protected List<ISelfImpact> listSelfImpact = new List<ISelfImpact>();
        protected List<ITargetImpact> listTargetImpact = new List<ITargetImpact>();

        public GameObject[] ResetTargets() {
            enterTrigger.AddIgnoreObj(m_SkillData.Owner);
            var targets = attackSelector.SelectTarget(skillData, this);
            if (null != targets && targets.Length > 0) {
                return targets;
            }
            return null;
        }

        /// <summary> 
        /// 释放技能
        /// </summary>
        public virtual void DeploySkill() {
            enterTrigger.AddIgnoreObj(m_SkillData.Owner);
        }

        /// <summary>
        /// 回收技能
        /// </summary>
        public void CollectSkil() {
            StartCoroutine(CollectSkil(skillData.durationTime));
        }

        IEnumerator CollectSkil(float time) {
            yield return new WaitForSeconds(time);
            GameObjectPool.instance.CollectObject(this.gameObject);
            enterTrigger.RemoveIgnoreObj(m_SkillData.Owner);
        }

        private void Awake() {
            enterTrigger = GetComponent<EnterTriggerRecord>();
        }
    }
}