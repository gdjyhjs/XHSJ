using UnityEngine;
using ARPGDemo.Character;
using System.Collections;

namespace ARPGDemo.Skill {
    /// <summary>
    /// 技能对目标造成伤害
    /// </summary>
    public class DamageTargetImpact : ITargetImpact {
        public void TargetImpact(SkillDeployer deployer, SkillData skillData, GameObject targetGo) {
            // 2 执行伤害
            deployer.StartCoroutine(RepeatDamage(deployer, skillData));
        }

        private IEnumerator RepeatDamage(SkillDeployer deployer, SkillData skillData) {
            float attackTime = 0;
            do {
                // 1 对多个目标执行伤害
                if (skillData.attackTargets != null && skillData.attackTargets.Length > 0) {
                    for (int i = 0; i < skillData.attackTargets.Length; i++) {
                        OnceDamage(skillData, skillData.attackTargets[i]);
                    }
                }
                // 2 等待一个伤害间隔
                yield return new WaitForSeconds(skillData.damageInterval);
                attackTime = attackTime + skillData.damageInterval;
                // ! 那么 damageInterval 不能为0
                if (skillData.damageInterval <= 0) {
                    YellowEvents.SendEvent(YellowEventName.error, YellowErrorText.errorSkilldamageInterval + skillData.name);
                    skillData.damageInterval = 0.1f;
                }
                // 3 攻击完一次后，重新选取目标
                skillData.attackTargets = deployer.ResetTargets();

            } while (attackTime <= skillData.durationTime);
        }

        private void OnceDamage(SkillData skillData, GameObject targetGo) {
            var status = targetGo.GetComponent<CharacterStatus>();
            // 1 调用角色状态 收到伤害的方法
            int baseDamage = CalculationBaseDamage(skillData);
            int damageVal = (int)(baseDamage * skillData.damage);
            status.OnDamage(damageVal, skillData);
            // 2 将受击特效挂载在挂载点上
            GameObjectPool.instance.CreateObject(skillData.hitFxName, skillData.hitFxPrefab, status.HitFxPos.position, status.HitFxPos.rotation);
            // 2 特效播放后回收
        }

        private int CalculationBaseDamage(SkillData skillData) {
            int baseDamage = 1;
            if (null != skillData.Owner) {
                var status = skillData.Owner.GetComponent<CharacterStatus>();
                if (null != status) {
                    baseDamage = skillData.Owner.GetComponent<CharacterStatus>().Damage;
                }
            }
            return baseDamage;
        }
    }
}