using System;
using System.Collections;
using System.Collections.Generic;
using UMA.CharacterSystem;
using UnityEngine;
using UnityStandardAssets.Characters.ThirdPerson;

// 存在修仙世界上的单位
public class UnitMono:MonoBehaviour
{
    public UnitBase unitData;
    public DynamicCharacterAvatar avatar;
    public ThirdPersonCharacter persion;

    public Transform[] hands;

    Dictionary<int, SkillBase> kills;
    private void Awake() {
        hands = new Transform[]{
            transform.Find("Root/Global/Position/Hips/LowerBack/Spine/Spine1/LeftShoulder/LeftArm/LeftForeArm/LeftHand"),
            transform.Find("Root/Global/Position/Hips/LowerBack/Spine/Spine1/RightShoulder/RightArm/RightForeArm/RightHand"),
        };
        kills = new Dictionary<int, SkillBase>() {
            [1] = new SkillBase() { ID = 1 },
            [2] = new SkillBase() { ID = 2 },
        };
    }

    /// <summary>
    /// 使用技能
    /// </summary>
    /// <param name="handid">左右手 0左手 1右手</param>
    /// <param name="skill">技能id</param>
    /// <param name="target">攻击目标</param>
    public void UseSkill(int handid, int skill, UnitBase target = null) {
        if (kills.ContainsKey(skill)) {
            UseSkill(handid, kills[skill], target);
        } else {
            Debug.Log("技能不存在 " + skill);
        }
    }

    /// <summary>
    /// 使用技能
    /// </summary>
    /// <param name="handid">左右手 0左手 1右手</param>
    /// <param name="skill">技能</param>
    /// <param name="target">攻击目标</param>
    public void UseSkill(int handid, SkillBase skill, UnitBase target = null) {
        if (skill == null) {
            Debug.Log("技能为空 " + skill);
            return;
        }
        


        Transform hand = hands[handid];
        // 冷却时间

        // 扣除魔法

        // 创造技能
        Vector3 targetPos;
        if (target != null && target.mono) {
            targetPos = target.mono.transform.position;
        } else {
            targetPos = hand.position + transform.forward * 10;
        }
        ConfSkillItem conf = g.conf.skill.GetItem(skill.ID);
        GameObject go = GameObject.Instantiate(StaticTools.LoadResources<GameObject>(conf.prefab));
        go.transform.position = hand.position;

        SkillMono skillMono = (SkillMono)go.AddComponent(Type.GetType(conf.className));
        skillMono.Init(unitData, this, skill, targetPos);
    }
}
