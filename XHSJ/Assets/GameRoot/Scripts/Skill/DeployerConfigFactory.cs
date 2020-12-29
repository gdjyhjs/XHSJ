using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ARPGDemo.Skill {
    /// <summary>
    /// 施放器的初始化类=配置类
    /// 施放器配置工厂
    /// </summary>
    public class DeployerConfigFactory {

        //创建目标选择对象
        public static IAttackSelector CreateAttackSelector(SkillData skill) {
            IAttackSelector attackSelector = null;
            #region  switch 实现方式：条件不同对象不同 修改量大
            //switch (skill.damageMode)
            //{ 
            //    case DamageMode.Circle:
            //        attackSelector = new CircleAttackSelector();
            //        break;
            //    case DamageMode.Sector:
            //        attackSelector = new SectorAttackSelector();
            //        break;
            //}
            #endregion
            #region  反射 实现方式：条件不同对象不同 不用修改
            //1
            //string path = "ARPGDemo.Skill.CircleAttackSelector";
            //string path = "ARPGDemo.Skill."+"Circle"+"AttackSelector";
            string path = "ARPGDemo.Skill." + skill.damageMode + "AttackSelector";
            Type typeObj = Type.GetType(path);
            //2
            object obj = Activator.CreateInstance(typeObj);
            attackSelector = (IAttackSelector)obj;
            #endregion
            return attackSelector;
        }
        //创建自身影响对象集合
        public static List<ISelfImpact> CreateSelfImpact(SkillData skill) {
            return new List<ISelfImpact>() {
             new CostSPSelfImpact()
            };
        }
        //创建目标影响对象集合
        public static List<ITargetImpact> CreateTargetImpact(SkillData skill) {
            return new List<ITargetImpact>() {
             new DamageTargetImpact()
            };
        }
    }
}
