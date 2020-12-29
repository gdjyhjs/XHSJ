using UnityEngine;


namespace AI.FSM {
    /// <summary>
    /// 发现目标条件
    /// </summary>
    public class SawPlayerTrigger : FSMTrigger {

        protected override void Init() {
            triggerId = FSMTriggerID.SawPlayer;
        }

        public override bool HandleTrigger(BaseFSM fsm) {
            return fsm.targetObject != null;
        }
    }
}
