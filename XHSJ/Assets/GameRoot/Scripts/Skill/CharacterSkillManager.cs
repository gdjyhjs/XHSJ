using UnityEngine;
using System.Collections.Generic;
using ARPGDemo.Character;
using System.Collections;

namespace ARPGDemo.Skill
{
    /// <summary>
    /// 技能管理类
    /// </summary>
    class CharacterSkillManager:MonoBehaviour
    {
        /// <summary>
        /// 技能列表
        /// </summary>
        public List<SkillData> skills = new List<SkillData>();

        /// <summary>
        /// 初始化 技能列表中的技能
        /// </summary>
        private void Start()
        {
            foreach (var skill in skills)
            {
                // 1
                if (!string.IsNullOrEmpty(skill.prefabName) && null == skill.skillPrefab) {
                    skill.skillPrefab = LoadPrefab(skill.prefabName);
                }
                // 2
                if (!string.IsNullOrEmpty(skill.hitFxName) && null == skill.hitFxPrefab) {
                    skill.hitFxPrefab = LoadPrefab(skill.hitFxName);
                }
                // 3
                skill.Owner = this.gameObject;
            }
        }

        private GameObject LoadPrefab(string resName)
        {
            // 使用对象池创建预制件对象，放在池中
            // （技能 常用，提前放在池中，使用时呈现；避免第一次使用时才创建，可能会出现卡顿）
            var refabGo = Resources.Load<GameObject>(resName);
            if (null == refabGo) {
                Debug.LogError("技能资源为空 " + resName);
            }
            return refabGo;
        }

        public SkillData PrepareSkill(int id)
        {
            // 1 按照编号在技能列表中查找
            var skillData = skills.Find(s => s.skillID == id);
            // 2 如果找到 同事 技能冷却结束 而且SP足够 。返回
            if (skillData != null) {
                if (skillData.coolRemain <= 0) {
                    if (skillData.costSP <= skillData.Owner.GetComponent<CharacterStatus>().SP) {
                        return skillData;
                    }
                    YellowEvents.SendEvent(YellowEventName.warningTip, YellowConstText.notSp);
                    return null;
                }
                YellowEvents.SendEvent(YellowEventName.warningTip, YellowConstText.notCool);
                return null;
            }
            YellowEvents.SendEvent(YellowEventName.warningTip, YellowConstText.notKill);
            // 否则 返回null
            return null;
        }

        /// <summary>
        /// 释放技能
        /// </summary>
        /// <param name="skillData">要释放的技能</param>
        public void DeploySkill(SkillData skillData)
        {
            // 1 创建技能预制件对象 使用对象池创建
            var tempGo = GameObjectPool.instance.CreateObject(skillData.prefabName, skillData.skillPrefab, transform.position, transform.rotation);
            // 2 为技能预制件对象 上找 释放器对象
            var deployer = tempGo.GetComponent<SkillDeployer>();
            // 3 调用释放器 的释放的方法
            deployer.skillData = skillData;
            deployer.DeploySkill();
            // 4 开始冷却计时
            StartCoroutine(CollTimeDown(skillData));
            // 5 回收技能对象 交给释放器完成
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="skillData"></param>
        /// <returns></returns>
        private IEnumerator CollTimeDown(SkillData skillData) {
            skillData.coolRemain = skillData.coolTime;
            while (skillData.coolRemain > 0) {
                yield return YellowConst.waitOneSecond;
                skillData.coolRemain -= 1;
            }
            skillData.coolRemain = 0; // 防止出现不是0； 二进制
        }

        public float GetSkillCoolRemain(int id)
        {
            return skills.Find(s => s.skillID == id).coolRemain;
        }

    }
}
