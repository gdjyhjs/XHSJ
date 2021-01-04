using ARPGDemo.Character;
using UnityEngine;

namespace ARPGDemo.Skill {
    class CostSPSelfImpact : ISelfImpact {
        /// <summary>
        /// 对自身影响的方法
        /// </summary>
        /// <param name="deployer">技能释放器</param>
        /// <param name="skillData">技能对象</param>
        /// <param name="selfGo">技能拥有者</param>
        public void SelfImpact(SkillDeployer deployer, SkillData skillData, GameObject selfGo) {
            if (skillData.Owner == null)
                return;
            var status = skillData.Owner.GetComponent<CharacterStatus>();
            status.chBase.SP -= skillData.costSP;
        }
    }
}
