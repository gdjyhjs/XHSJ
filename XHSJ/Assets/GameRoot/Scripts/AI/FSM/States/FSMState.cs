 using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

namespace AI.FSM
{

    //具体状态类名称 编号+State  如 DeadState
    //具体条件类名称 编号+Trigger   如 SawPlayerTrigger
    /// <summary>
    /// 抽象状态类
    /// </summary>
    public abstract class FSMState
    {
        /// <summary>状态编号 </summary>
        public FSMStateID stateId;
        /// <summary>条件列表</summary>
        private List<FSMTrigger> triggers = new List<FSMTrigger>();
        /// <summary>转换映射表</summary>
        private Dictionary<FSMTriggerID, FSMStateID> map = new Dictionary<FSMTriggerID, FSMStateID>();

        /// <summary>构造方法</summary>
        public FSMState()
        {
            Init();
        }

        /// <summary>初始化</summary>
        protected abstract void Init();

        /// <summary>添加条件映射</summary>
        public void AddTrigger(FSMTriggerID triggerId, FSMStateID outputStateId)
        {
            if (!map.ContainsKey(triggerId))
            {
                map.Add(triggerId, outputStateId);
                //添加映射的同时，并添加条件对象
                AddTriggerObject(triggerId);
            }
        }

        private void AddTriggerObject(FSMTriggerID triggerId)
        {
            //根据triggerId使用反射动态创建trigger的对象
            var type = Type.GetType("AI.FSM." + triggerId + "Trigger");
            if (type != null)
            {
                var obj = Activator.CreateInstance(type) as FSMTrigger;
                //将创建好的对象加入triggers
                if (obj != null)
                    triggers.Add(obj);
            }
        }

        /// <summary>删除条件映射</summary>
        public void DeleteTrigger(FSMTriggerID triggerId)
        {
            //删除映射的同时，并删除条件对象
            if (map.ContainsKey(triggerId))
            {
                map.Remove(triggerId);
                DeleteTriggerObject(triggerId);
            }
        }

        private void DeleteTriggerObject(FSMTriggerID triggerId)
        {
            triggers.RemoveAll(p => p.triggerId == triggerId);
        }


        /// <summary>查找映射</summary>
        public FSMStateID GetOutputState(FSMTriggerID triggerId)
        {
            //查找映射表，根据条件编号，返回输出状态的编号
            if (map.ContainsKey(triggerId))
            {
                return map[triggerId];
            }
            return FSMStateID.None;
        }

        /// <summary>进入状态</summary>
        public abstract void EnterState(BaseFSM fsm);
        /// <summary>离开状态</summary>
        public abstract void ExitState(BaseFSM fsm);
        /// <summary>持续状态</summary>
        public abstract void Action(BaseFSM fsm);
        /// <summary>条件检测</summary>
        public void Reason(BaseFSM fsm)
        {
            //检测每一个条件对象
            for(int i = 0;i < triggers.Count;i++)
            {  
                //如果有条件达成
                if (triggers[i].HandleTrigger(fsm))
                {
                    //通知状态机，准备做状态转换
                    fsm.ChangeActiveState(triggers[i].triggerId);
                    return;
                }
            }
        }

    }
}
