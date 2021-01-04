using UnityEngine;


namespace AI.FSM {
    /// <summary>
    /// 目标离开攻击范围
    /// </summary>
    public class WithoutAttackRangeTrigger : FSMTrigger {

        protected override void Init() {
            triggerId = FSMTriggerID.WithoutAttackRange;
        }

        public override bool HandleTrigger(BaseFSM fsm) {
            if (fsm.targetObject != null) {
                var distance = Vector3.Distance(
                        fsm.transform.position,
                        fsm.targetObject.transform.position);
                return distance > fsm.chStatus.chBase.attackDistance && distance < fsm.sightDistance;
            }
            return false;
        }
    }
}
