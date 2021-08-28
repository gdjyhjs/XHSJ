using Newtonsoft.Json;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// 存在修仙世界上的单位
public class UnitBase {
    /// <summary>
    /// 角色名字
    /// </summary>
    public string id;
    public bool isDie = false;
    [JsonIgnore]
    public UnitMono mono;
    [JsonIgnore]
    public Vector3 pos
    {
        get
        {
            return new Vector3(pos_x, pos_y, pos_z);
        }
        set
        {
            pos_x = value.x;
            pos_y = value.y;
            pos_z = value.z;
        }
    }
    private float pos_x, pos_y, pos_z; // 角色在世界中的位置

    public Appearance appearance;
    public Attribute attribute;
    public SkillManager skillManager;
    public BuffManager buffManager;

    public List<string> enemys = new List<string>();

    public UnitBase() {
        appearance = new Appearance();
        attribute = new Attribute();
        skillManager = new SkillManager();
        buffManager = new BuffManager();
    }

    /// <summary>
    /// 收到技能效果
    /// </summary>
    /// <param name="value">技能威力值</param>
    /// <param name="attacker">技能释放者</param>
    /// <param name="skillQuale">技能性质</param>
    /// <param name="skillType">技能类型</param>
    public void SkillEffect(float value, UnitBase attacker, SkillQuale skillQuale, SkillType skillType) {

        if (skillType >= SkillType.EffectSkillStart && skillType <= SkillType.EffectSkillEnd) {
            // 特殊技能的效果
            if (skillType == SkillType.Recover) {
                attribute.health_cur = Mathf.Min(attribute.health_max, attribute.health_cur + value);
            }
        } else if (skillType >= SkillType.DamageSkillStart && skillType <= SkillType.DamageSkillEnd) {
            // 造成伤害的技能
            switch (skillQuale) {
                case SkillQuale.Without:
                    value -= attribute.defence;
                    break;
                case SkillQuale.Fire:
                    value -= value * attribute.resist_fire / 100;
                    break;
                case SkillQuale.Forzen:
                    value -= value * attribute.resist_forzen / 100;
                    break;
                case SkillQuale.Lighting:
                    value -= value * attribute.resist_lighting / 100;
                    break;
                case SkillQuale.Poison:
                    value -= value * attribute.resist_poison / 100;
                    break;
                case SkillQuale.Holy:
                    value -= value * attribute.resist_holy / 100;
                    break;
                case SkillQuale.Dark:
                    value -= value * attribute.resist_dark / 100;
                    break;
                default:
                    break;
            }
            value = Mathf.Max(1, value);
            attribute.health_cur = attribute.health_cur - value;
        } else {
            Debug.Log("意外的技能类型：" + skillType);
        }
        if (attribute.health_cur <= 0) {
            Die();
        }
        if (id == g.units.playerUnitID) {
            g.uiWorldMain.UpdateHP();
        } else {
            AddEnemy(attacker.id);
        }
    }

    public void AddEnemy(string id) {
        if (!enemys.Contains(id)) {
            enemys.Add(id);
        }
    }

    public void RemoveEnemy(string id) {
        if (enemys.Contains(id)) {
            enemys.Remove(id);
        }
    }

    /// <summary>
    /// 死亡
    /// </summary>
    public void Die() {
        isDie = true;
        if (mono != null) {
            mono.persion.PlayDie();
        }
    }

    /// <summary>
    ///  复活
    /// </summary>
    public void Revive() {
        isDie = false;
        if (mono != null) {
            mono.persion.PlayRevive();
        }
    }
}