using UnityEngine;


namespace AI.FSM {
    /// <summary>
    /// 攻击状态
    /// </summary>
    public class AttackingState : FSMState {
        private float nextAttackTime = 0;

        protected override void Init() {
            stateId = FSMStateID.Attacking;
        }

        public override void EnterState(BaseFSM fsm) {
            fsm.StopMove();
            fsm.PlayAnimation(fsm.animParams.Idle);
        }

        public override void ExitState(BaseFSM fsm) {
        }

        public override void Action(BaseFSM fsm) {
            if (fsm.targetObject != null)
                fsm.transform.LookAt(fsm.targetObject.transform);

            if (nextAttackTime <= Time.time) {
                fsm.UseSkill(); nextAttackTime = Time.time + fsm.chStatus.chBase.attackSpeed;
            }
        }
    }
}
