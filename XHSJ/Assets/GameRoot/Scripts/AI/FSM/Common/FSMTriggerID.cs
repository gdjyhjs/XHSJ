 namespace AI.FSM
{
	/// <summary>
	/// 状态转换条件
	/// </summary>
    public enum FSMTriggerID {

        /// <summary>生命为0</summary>
        NoHealth,

        /// <summary>发现目标</summary>
        SawPlayer,

        /// <summary>目标进入攻击范围<summary>
        ReachPlayer,

        /// <summary>丢失玩家</summary>
        LosePlayer,

        /// <summary>完成巡逻</summary>
        CompletePatrol,

        /// <summary>打死目标</summary>
        KilledPlayer,

        /// <summary>目标不在攻击范围，玩家离开攻击范围</summary>
        WithoutAttackRange,

        /// <summary>可以复活</summary>
        CanRevive,

    }
}
