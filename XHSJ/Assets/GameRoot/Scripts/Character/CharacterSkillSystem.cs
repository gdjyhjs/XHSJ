using UnityEngine;
using ARPGDemo.Skill;
using System.Collections.Generic;

namespace ARPGDemo.Character {
    /// <summary>
    /// 角色系统 技能系统外观类【接入类】
    /// </summary>
    class CharacterSkillSystem : MonoBehaviour {
        private CharacterAnimation chAnim;
        private GameObject currentAttackTarget;
        private SkillData currentUseSkill;
        private CharacterSkillManager skillMgr;
        private EnterTriggerRecord triggerRecord;

        /// <summary>
        /// 使用某个技能进行攻击
        /// </summary>
        /// <param name="skillId">技能编号</param>
        /// <param name="isBatter">是否连续攻击</param>
        public void AttackUseSkill(int skillId, bool isBatter = false) {
            //1根据技能吧编号 找出技能数据对象
            currentUseSkill = skillMgr.PrepareSkill(skillId);
            if (null == currentUseSkill) {
                return;
            }
            //2播放技能对应的攻击动画
            chAnim.PlayAnimation(currentUseSkill.animationName);
            //3找出受击目标
            var selectedTarget = SelectTarget();
            if (null == selectedTarget) {
                return;
            }
            //4显示选择目标效果【红圈】
            ShowSelectedFx(false);// 前一个目标 选中效果 隐藏
            currentAttackTarget = selectedTarget; // 更新当前目标
            ShowSelectedFx(true);// 当前目标 选中效果 显示
            //5面向目标
            transform.LookAt(selectedTarget.transform);
            transform.eulerAngles = new Vector3(0, transform.eulerAngles.y, 0);
        }

        /// <summary>
        /// 释放技能
        /// </summary>
        public void DeploySkill() {
            if (null != currentUseSkill) {
                skillMgr.DeploySkill(currentUseSkill);
            }
        }

        private GameObject SelectTarget() {
            List<GameObject> list = new List<GameObject>();
            // 1 添加影响范围的目标
            list.AddRange(triggerRecord.EnterObjs);
            if (list.Count <= 0) {
                return null;
            }
            // 2 从所有攻击目标中 找出攻击范围中活着的敌人
            var skillData = currentUseSkill;
            list = list.FindAll(go => {
                if (null == go)
                    return false;
                var dis = Vector3.Distance(go.transform.position, transform.position);
                if (dis > skillData.attackDistance) {
                    return false;
                }
                var status = go.GetComponent<CharacterStatus>();
                if (null == status)
                    return false;
                return status.HP > 0;
                });
            if (null == list || list.Count <= 0) {
                return null;
            }
            // 3 选择一个敌人
            return ArrayHelper.Min(list.ToArray(), go => Vector3.Distance(go.transform.position, transform.position));
        }

        /// <summary>
        /// 显示当前选中 目标 的选中效果【红圈】
        /// </summary>
        /// <param name="isShow">true=显示  false=隐藏</param>
        private void ShowSelectedFx(bool isShow) {
            // 1 找出当前攻击目标 红圈 “selected”
            if (null != currentAttackTarget) {
                Transform selectObj = TransformHelper.FindChild(currentAttackTarget.transform, "selected");

                // 2 控制这个子物体的 Renderer
                if (null != selectObj) {
                    selectObj.GetComponent<Renderer>().enabled = isShow;
                }
            }

        }

        /// <summary>
        /// 初始化
        /// </summary>
        private void Start() {
            chAnim = GetComponent<CharacterAnimation>();
            skillMgr = GetComponent<CharacterSkillManager>();
            triggerRecord = GetComponent<EnterTriggerRecord>();
            // 2 注册事件 攻击 > 释放技能
            GetComponentInChildren<AnimationEventBehaviour>().attackHandler += DeploySkill;
        }

        public void UseRandomSkill() {
            // 1 找出所有可用的技能 
            // · 冷却时间=0
            // · sp足够
            List<SkillData> usableSkill = skillMgr.skills.FindAll(skill => skill.coolRemain <= 0 && skill.costSP <= skill.Owner.GetComponent<CharacterStatus>().SP);
            if (null == usableSkill || usableSkill.Count <= 0)
                return;
            // 2 从库克用技能中随机找出一个技能
            SkillData skillData = usableSkill[Random.Range(0, usableSkill.Count)];
            AttackUseSkill(skillData.skillID);
        }
    }
}