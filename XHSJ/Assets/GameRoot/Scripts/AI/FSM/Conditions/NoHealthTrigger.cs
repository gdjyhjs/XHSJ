using UnityEngine;


namespace AI.FSM {
    /// <summary>
    /// 生命为0条件
    /// </summary>
    public class NoHealthTrigger : FSMTrigger {

        protected override void Init() {
            triggerId = FSMTriggerID.NoHealth;
        }

        public override bool HandleTrigger(BaseFSM fsm) {
            return fsm.chStatus.HP <= 0;
        }
    }
}
