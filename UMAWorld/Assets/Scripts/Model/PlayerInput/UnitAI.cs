using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityStandardAssets.Characters.ThirdPerson;
using UnityStandardAssets.CrossPlatformInput;

[RequireComponent(typeof(AICharacterControl))]
// 属性
public class UnitAI:MonoBehaviour {
    public UnitMono unitMono;
    public ThirdPersonCharacter person;
    public AICharacterControl ai;

    public UnitMono target;
    

    private void Awake() {
        person = GetComponent<ThirdPersonCharacter>();
        unitMono = GetComponent<UnitMono>();
        ai = GetComponent<AICharacterControl>();
    }

    private void Update() {
        target = null;
        for (int i = unitMono.unitData.enemys.Count - 1; i >= 0; i--) {
            UnitBase enemy = g.units.GetUnit(unitMono.unitData.enemys[i]);
            if (enemy.mono) {
                target = enemy.mono;
                break;
            }
            if (enemy.isDie) {
                unitMono.unitData.RemoveEnemy(enemy.id);
            }
        }

        if (target) {
            float dis = Vector3.Distance(transform.position, target.transform.position);
            if (dis < 10) {
                ai.SetTarget(Vector3.zero);
                transform.LookAt(target.transform);
                if (StaticTools.Random(0, 2) == 0) { person.PlayTrigger("Attack1"); } else { person.PlayTrigger("Attack2"); }
            } else {
                ai.SetTarget(transform.position + (target.transform.position - transform.position).normalized * (dis - 8));
            }
        }
    }
}
