 using UnityEngine;


namespace AI.FSM
{
	/// <summary>
	/// 
	/// </summary>
	public class DeadState :FSMState 
	{

        protected override void Init()
        {
            stateId = FSMStateID.Dead;
        }

        public override void EnterState(BaseFSM fsm)
        {
            fsm.PlayAnimation(fsm.animParams.Dead);
        }

        public override void ExitState(BaseFSM fsm)
        {
            fsm.chStatus.chBase.HP = fsm.chStatus.chBase.MaxHP;
        }

        public  override void Action(BaseFSM fsm)
        {
        }
    }
}
