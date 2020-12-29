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
            if (fsm.chStatus.NextReviveTime <= 0) {
                return false;
            }
            return fsm.chStatus.NextReviveTime < Time.time;
        }
    }
}
