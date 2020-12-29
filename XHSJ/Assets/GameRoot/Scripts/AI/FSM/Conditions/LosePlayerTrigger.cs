using UnityEngine;


namespace AI.FSM {
    /// <summary>
    /// 
    /// </summary>
    public class LosePlayerTrigger : FSMTrigger {

        protected override void Init() {
            triggerId = FSMTriggerID.LosePlayer;
        }

        public override bool HandleTrigger(BaseFSM fsm) {
            return fsm.targetObject == null;
        }
    }
}
