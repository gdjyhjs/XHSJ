using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace ARPGDemo.Character //格式缩进
{
    public interface IOnDamage
    {
        /// <summary>
        /// 受到伤害
        /// </summary>
        /// <param name="damageVal">伤害值</param>
        void OnDamage(int damageVal, Skill.SkillData skillData);
    }
}