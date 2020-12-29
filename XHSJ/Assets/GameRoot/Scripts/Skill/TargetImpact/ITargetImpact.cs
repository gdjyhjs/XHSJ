using UnityEngine;
namespace ARPGDemo.Skill {
    /// <summary>
    /// 技能对目标影响的接口
    /// </summary>
    public interface ITargetImpact {
        /// <summary>
        /// 对目标影响的方法
        /// </summary>
        /// <param name="deployer">技能释放器</param>
        /// <param name="skillData">技能对象</param>
        /// <param name="targetGo">目标对象</param>
        void TargetImpact(SkillDeployer deployer, SkillData skillData, GameObject targetGo);
    }
}