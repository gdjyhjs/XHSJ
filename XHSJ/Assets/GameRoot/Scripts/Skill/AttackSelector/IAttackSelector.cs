using UnityEngine;
namespace ARPGDemo.Skill {
    /// <summary>
    /// 攻击选择接口【算法】
    /// </summary>
    public interface IAttackSelector {
        /// <summary>
        /// 选择目标方法：在攻击的时候，选择{什么范围中的敌人作为}攻击的目标
        /// </summary>
        /// <param name="skillData">技能对象</param>
        /// <param name="skillDeployer">技能拥有者的transform</param>
        /// <returns>选中的目标</returns>
        GameObject[] SelectTarget(SkillData skillData, SkillDeployer skillDeployer);
    }
}