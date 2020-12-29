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
            fsm.chStatus.NextReviveTime = (int)(Time.time + fsm.chStatus.ReviveTime);
        }

        public override void ExitState(BaseFSM fsm)
        {
            fsm.chStatus.HP = fsm.chStatus.MaxHP;
            fsm.chStatus.NextReviveTime = 0;
        }

        public  override void Action(BaseFSM fsm)
        {
        }
    }
}
