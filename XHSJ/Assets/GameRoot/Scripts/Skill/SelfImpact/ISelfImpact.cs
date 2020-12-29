using UnityEngine;
namespace ARPGDemo.Skill {
    /// <summary>
    /// 技能对自身影响的接口
    /// </summary>
    public interface ISelfImpact {
        /// <summary>
        /// 对自身影响的方法
        /// </summary>
        /// <param name="deployer">技能释放器</param>
        /// <param name="skillData">技能对象</param>
        /// <param name="selfGo">技能拥有者</param>
        void SelfImpact(SkillDeployer deployer, SkillData skillData, GameObject selfGo);
    }
}