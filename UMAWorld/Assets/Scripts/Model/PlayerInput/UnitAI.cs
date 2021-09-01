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

    public UnitMono targetUnit;
    public Vector3 targetPoint;


    private void Awake() {
        person = GetComponent<ThirdPersonCharacter>();
        unitMono = GetComponent<UnitMono>();
        ai = GetComponent<AICharacterControl>();
    }

    private void Update() {
        targetUnit = null;
        for (int i = unitMono.unitData.enemys.Count - 1; i >= 0; i--) {
            UnitBase enemy = g.units.GetUnit(unitMono.unitData.enemys[i]);
            if (enemy.mono) {
                targetUnit = enemy.mono;
                break;
            }
            if (enemy.isDie) {
                unitMono.unitData.RemoveEnemy(enemy.id);
            }
        }

        if (targetUnit) {
            float dis = Vector3.Distance(transform.position, targetUnit.transform.position);
            if (dis < 10) {
                ai.SetTarget((Vector3)default);
                transform.LookAt(targetUnit.transform);
                if (StaticTools.Random(0, 2) == 0) { person.PlayTrigger("Attack1"); } else { person.PlayTrigger("Attack2"); }
            } else {
                ai.SetTarget(targetUnit.transform);
            }
        } else {
            IdleRun();
        }
    }

    private void IdleRun() {
        if (Vector3.Distance(transform.position, targetPoint) < 2 || ai.target != targetPoint || targetPoint == default) {
            targetPoint = StaticTools.GetGroundPoint(new Vector3(StaticTools.Random(-100, 100), 0, StaticTools.Random(-100, 100)));
            ai.SetTarget(targetPoint);
        }
    }
}
