using UnityEngine;


namespace AI.FSM {
    /// <summary>
    /// 追逐状态
    /// </summary>
    public class PursuitState : FSMState {

        protected override void Init() {
            stateId = FSMStateID.Pursuit;
        }

        public override void EnterState(BaseFSM fsm) {
        }

        public override void ExitState(BaseFSM fsm) {
            fsm.StopMove();
        }

        public override void Action(BaseFSM fsm) {
            if (fsm.targetObject != null) {
                fsm.MoveToTarget(
                    fsm.targetObject.transform.position,
                    fsm.moveSpeed,
                    fsm.chStatus.chBase.attackDistance);
                // 播放响应的动画
                fsm.PlayAnimation(fsm.animParams.Run);
            }
        }
    }
}
