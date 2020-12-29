 namespace AI.FSM
{
    /// <summary>
    /// 状态编号
    /// </summary>
    public enum FSMStateID {
        /// <summary> 无 </summary>
        None,

        /// <summary>待机</summary>
        Idle,

        /// <summary>死亡</summary>
        Dead,

        /// <summary>追逐</summary>
        Pursuit,

        /// <summary>攻击</summary>
        Attacking,

        /// <summary>默认</summary>
        Default,

        ///// <summary>巡逻</summary>
        //Patrolling,

        ///// <summary>徘徊</summary>
        //Wander,

        ///// <summary>到达</summary>
        //Arrival,

    }
}
