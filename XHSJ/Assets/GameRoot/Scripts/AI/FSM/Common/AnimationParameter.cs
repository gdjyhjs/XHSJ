 using System;

namespace AI.FSM
{
    /// <summary>
    /// 动画参数
    /// </summary>
    [Serializable]
    public class AnimationParameter
    {
        public string Idle = "idle";
        public string Dead = "dead";
        public string Run = "run";
    }
}
