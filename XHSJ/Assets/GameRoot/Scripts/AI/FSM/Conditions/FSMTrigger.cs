 using UnityEngine;
using System.Collections;

namespace AI.FSM
{
    /// <summary>
    /// 条件抽象类
    /// </summary>
    public abstract class FSMTrigger
	{
        /// <summary>
        /// 条件编号
        /// </summary>
        public FSMTriggerID triggerId;

        public FSMTrigger()
        {
            Init();
        }

        /// <summary>
        /// 初始化
        /// </summary>
        protected abstract void Init();

        /// <summary>
        /// 处理条件
        /// </summary>
        /// <param name="fsm">状态机</param>
        public abstract bool HandleTrigger(BaseFSM fsm);


	}
}
