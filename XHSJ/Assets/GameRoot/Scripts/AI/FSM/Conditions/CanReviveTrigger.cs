using UnityEngine;


namespace AI.FSM {
    /// <summary>
    /// 发现目标条件
    /// </summary>
    public class CanReviveTrigger : FSMTrigger {

        protected override void Init() {
            triggerId = FSMTriggerID.CanRevive;
        }

        public override bool HandleTrigger(BaseFSM fsm) {
            return false;
        }
    }
}
