using ARPGDemo.Skill;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace ARPGDemo.Character
{
    /// <summary>
    /// 小怪状态
    /// </summary>
    public class MonsterStatus : CharacterStatus
    {


        public byte maxEnemy = 99;
        public List<CharacterStatus> enemys;
        public int GiveExp;


        /// <summary>
        /// 死亡
        /// </summary>
        public override void Dead()
        {
            OnDie(gameObject);
        }


        /// <summary>
        /// 受到伤害
        /// </summary>
        public override void OnDamage(int damageVal, SkillData skillData) {
            // 有一部分相同 已经实现 直接调用
            base.OnDamage(damageVal, skillData);
            // 有一部分不同的 在下面实现

            OnHit(gameObject);

            GameObject enemy = skillData.Owner;
            if (null != enemy && enemy != gameObject) {
                CharacterStatus status = enemy.GetComponent<CharacterStatus>();
                if (null != status && !enemys.Contains(status)) {
                    if (enemys.Count >= maxEnemy) {
                        enemys.RemoveAt(0);
                    }
                    enemys.Add(status);
                }
            }
        }


        void OnHit(GameObject obj) {
            if (chBase.HP > 0) {
                obj.GetComponentInChildren<Renderer>().material.color = Color.red;
                StartCoroutine(OnHidEnd(obj));
            }
        }

        IEnumerator OnHidEnd(GameObject obj) {
            yield return new WaitForSeconds(0.2f);
            if (chBase.HP > 0) {
                obj.GetComponentInChildren<Renderer>().material.color = Color.white;
            }
        }

        void OnDie(GameObject obj) {
            obj.GetComponentInChildren<Renderer>().material.color = Color.gray;
        }
    }
}
