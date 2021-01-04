using UnityEngine;
using System.Collections.Generic;
using ARPGDemo.Character;
using System;
using UnityEngine.AI;

namespace AI.FSM
{
    /// <summary>
    /// 有限状态机
    /// </summary>
    public class BaseFSM : MonoBehaviour {
        public bool isVisible;

        /// <summary>1 2当前状态 </summary>
        public FSMStateID currentStateID = FSMStateID.None;
        private FSMState currentState;

        /// <summary>3 4默认状态 </summary>
        public FSMStateID defaultStateID = FSMStateID.None;
        private FSMState defaultState;

        /// <summary>5状态库 </summary>
        private List<FSMState> states = new List<FSMState>();

        /// <summary>6角色动画 </summary>
        private CharacterAnimation chAnim;

        /// <summary> 动画参数 </summary>
        public AnimationParameter animParams;
 
        /// <summary> 角色状态 </summary>
        public CharacterStatus chStatus;

        /// <summary>技能系统 </summary>
        private CharacterSkillSystem chSkillSys;

        /// <summary> 智能配置文件：写状态转换表 方便修改 </summary>
        public string aiConfigFile = "AI_01.txt";

        /// <summary> 目标标签列表 </summary>
        public string[] targetTags = { "Boss" };

        /// <summary> 视野距离 </summary>
        public float sightDistance = 10;

        private NavMeshAgent navAngent;

        public float moveSpeed = 5;

        public Transform targetObject;

        /// <summary> 重置目标 </summary>
        private void ResetTarget() {
            targetObject = null;

            List<GameObject> list = new List<GameObject>();
            //1 在场景中找指定tag的所有物体
            for (int i = 0; i < targetTags.Length; i++) {
                var allTargets = GameObject.FindGameObjectsWithTag(targetTags[i]);
                if (null != allTargets && allTargets.Length > 0) {
                    list.AddRange(allTargets);
                }
            }
            if (list.Count <= 0) {
                return;
            }
            //2 选出视距内，且活着的物体
            list = list.FindAll(go => Vector3.Distance(go.transform.position, transform.position) < sightDistance && go.GetComponent<CharacterStatus>().chBase.HP > 0);
            if (null == list || list.Count <= 0) {
                return;
            }

            //3 取最近的
            GameObject obj = ArrayHelper.Min(list.ToArray(), go => Vector3.Distance(go.transform.position, transform.position));
            if (obj) {
                targetObject = obj.transform;
            }
        }

        /// <summary>切换状态</summary>
        public void ChangeActiveState(FSMTriggerID triggerId) {
            //1 现在是什么情况 --当前状态 当前条件 --> 下一个状态是谁
            var nextStateId = currentState.GetOutputState(triggerId);
            if (nextStateId == FSMStateID.None) {
                return;
            }

            FSMState nextState = null;


            if (nextStateId != FSMStateID.Default) {
                nextState = states.Find(p => p.stateId == nextStateId);
            } else {
                // 默认状态
                currentState = defaultState;
            }
            //2 当前状态 -- 出
            currentState.ExitState(this);

            //3 做出下一步的安排
            if (null != nextState) {
                currentState = nextState;
            } else {
                currentState = defaultState;
            }

            //4 下一个状态 -- 进
            currentStateID = currentState.stateId;
            currentState.EnterState(this);
        }

        public void PlayAnimation(string animName) {
            chAnim.PlayAnimation(animName);
        }

        /// <summary> 初始化状态机 </summary>
        private void Awake() {
            ConfigFSM();
        }

        /// <summary> 配置状态机 </summary>
        private void ConfigFSM() {
            // 读取状态机配置
            var config = AIConfiguration.Load(aiConfigFile);
            foreach (var item in config) {
                // 反射创建状态对象
                FSMState state;
                string path = "AI.FSM." + item.Key + "State";
                Type typeObj = Type.GetType(path);
                object obj = Activator.CreateInstance(typeObj);
                state = (FSMState)obj;

                foreach (var it in item.Value) {
                    // 添加条件映射
                    FSMTriggerID triggerIDenum = (FSMTriggerID)Enum.Parse(typeof(FSMTriggerID), it.Key, true);
                    FSMStateID stateIDenum = (FSMStateID)Enum.Parse(typeof(FSMStateID), it.Value, true);
                    state.AddTrigger(triggerIDenum, stateIDenum);
                }
                // 放入状态库中
                states.Add(state);
            }
        }

        private void OnEnable() {
            InitDefaultState();
            // 状态启用时：重置目标
            InvokeRepeating("ResetTarget", 0, 0.2f);
        }

        private void OnDisable() {
            CancelInvoke("ResetTarget");
        }

        private void InitDefaultState() {
            // 使用默认状态编号 为其他状态数据赋值
            defaultState = states.Find(p => p.stateId == defaultStateID);
            currentState = defaultState;
            currentStateID = defaultStateID;
        }

        private void Start() {
            chStatus = GetComponent<CharacterStatus>();
            chAnim = GetComponent<CharacterAnimation>();
            navAngent = GetComponent<NavMeshAgent>();
            chSkillSys = chStatus.GetComponent<CharacterSkillSystem>();
        }

        private void Update() {
            currentState.Reason(this);
            currentState.Action(this);
        }

        public void MoveToTarget(Vector3 pos, float peed, float stopDistance) {
            navAngent.speed = moveSpeed;
            navAngent.stoppingDistance = stopDistance;
            navAngent.SetDestination(pos);
        }


        public void StopMove() {
            navAngent.enabled = false;
            navAngent.enabled = true;
        }

        public void UseSkill() {
            chSkillSys.UseRandomSkill();
        }

        protected void OnBecameVisible() {
            isVisible = true;
        }

        protected void OnBecameInvisible() {
            isVisible = false;
        }
    }
}
