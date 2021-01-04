using ARPGDemo.Character;
using System.Collections.Generic;
using UnityEngine;
namespace ARPGDemo.Skill {
    /// <summary>
    /// 扇形攻击技能选择器
    /// </summary>
    class SectorAttackSelector : IAttackSelector {
        /// <summary>
        /// 选择目标方法：在攻击的时候，选择{什么范围中的敌人作为}攻击的目标
        /// </summary>
        /// <param name="skillData">技能对象</param>
        /// <param name="skillOwner">技能拥有者的transform</param>
        /// <returns>选中的目标</returns>
        public GameObject[] SelectTarget(SkillData skillData, SkillDeployer skillDeployer) {
            List<GameObject> list = new List<GameObject>();
            // 1 添加技能影响范围的目标
            list.AddRange(skillDeployer.enterTrigger.EnterObjs);
            if (list.Count <= 0) {
                Debug.LogError("扇形攻击目标为0");
                return null;
            }
            Transform depTf = skillDeployer.transform;
            // 2 从所有攻击目标中 找出攻击范围中活着的敌人
            list = list.FindAll(go => 
                Vector3.Distance(go.transform.position, depTf.position) < skillData.attackDistance 
                && go.GetComponent<CharacterStatus>().chBase.HP > 0
                && Vector3.Angle(depTf.forward, go.transform.position - depTf.position) <= skillData.attackAngle);
            if (null == list || list.Count <= 0) {
                return null;
            }
            // 3 根据释放的技能，选择一个或多个敌人
            switch (skillData.attackType) {
                case SkillAttackType.Single:
                    GameObject obj = ArrayHelper.Min(list.ToArray(), go => Vector3.Distance(go.transform.position, depTf.position));
                    return new GameObject[] { obj };
                case SkillAttackType.Group:
                    return list.ToArray();
                default:
                    YellowEvents.SendEvent(YellowEventName.error, YellowErrorText.notSkillType);
                    return null;
            }
        }
    }
}