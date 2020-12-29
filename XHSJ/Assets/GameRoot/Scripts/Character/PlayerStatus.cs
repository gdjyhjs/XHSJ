using UnityEngine;
using System.Collections;
using System;
using ARPGDemo.Skill;

namespace ARPGDemo.Character //格式缩进
{
    /// <summary>
    /// 主角状态
    /// </summary>
    public class PlayerStatus : CharacterStatus
    {

        //数据：
        /// <summary>
        /// 经验(Exp)
        /// </summary> 
        public int Exp;
        /// <summary>
        /// 最大经验(MaxExp) 
        /// </summary>
        public int MaxExp;
        //行为：		
        /// <summary>
        /// 收集经验
        /// </summary>
        public void CollectExp()
        {
            throw new System.NotImplementedException();
        }
        /// <summary>
        /// 升级
        /// </summary>
        public void LevelUp()
        {
        }

        /// <summary>
        /// 死亡
        /// </summary>
        public override void Dead()
        {
            HP = MaxHP;
            //throw new System.NotImplementedException();
        }


        /// <summary>
        /// 受到伤害
        /// </summary>
        public override void OnDamage(int damageVal, SkillData skillData)
        {
            // 有一部分相同 已经实现 直接调用
            base.OnDamage(damageVal,skillData);
            // 有一部分不同的 在下面实现

        }
    }

}
