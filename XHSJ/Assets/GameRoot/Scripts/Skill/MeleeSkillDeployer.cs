using UnityEngine;
using System.Collections.Generic;
using ARPGDemo.Character;
namespace ARPGDemo.Skill {
    public class MeleeSkillDeployer : SkillDeployer {
        public override void DeploySkill() {
            base.DeploySkill();
            if (null == skillData) {
                Debug.LogError("skillData is null");
                return;
            }
            skillData.attackTargets = ResetTargets();
            listSelfImpact.ForEach(p => p.SelfImpact(this, skillData, skillData.Owner));
            listTargetImpact.ForEach(p => p.TargetImpact(this, skillData, skillData.Owner));
            CollectSkil();
        }
    }
} 
