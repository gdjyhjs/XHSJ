using UnityEngine;
using System.Collections;

namespace AI.FSM {
    /// <summary>
    /// 目标进入攻击范围条件类
    /// </summary>
    public class ReachPlayerTrigger : FSMTrigger {

        protected override void Init() {
            triggerId = FSMTriggerID.ReachPlayer;
        }

        public override bool HandleTrigger(BaseFSM fsm) {
            if (fsm.targetObject != null)
                return Vector3.Distance(
                    fsm.transform.position,
                    fsm.targetObject.transform.position) < fsm.chStatus.attackDistance;
            return false;
        }
    }
}
