using UnityEngine;
using System.Collections;

namespace AI.FSM {
    /// <summary>
    /// 
    /// </summary>
    public class IdleState : FSMState {

        protected override void Init() {
            stateId = FSMStateID.Idle;
        }

        public override void EnterState(BaseFSM fsm) {
            fsm.StopMove();
        }

        public override void ExitState(BaseFSM fsm) {
        }

        public override void Action(BaseFSM fsm) {
            // 播放相应的动画
            fsm.PlayAnimation(fsm.animParams.Idle);
        }
    }
}
