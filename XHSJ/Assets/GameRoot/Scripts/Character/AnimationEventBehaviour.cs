using UnityEngine;
namespace ARPGDemo.Character
{

    /// <summary>
    /// 动画事件行为
    /// </summary>
    public class AnimationEventBehaviour:MonoBehaviour
    {
        /// <summary>
        /// 动画组件
        /// </summary>
        public CharacterAnimation anim;

        private void Start() {
            anim = GetComponentInParent<CharacterAnimation>();
        }

        /// <summary>
        /// 撤销动画播放
        /// </summary>
        public void OnCancelAnim(string animName)
        {
            anim.PlayAnimation("idle");
        }
        // 时间 两个行为 联动性 F1播放攻击动画 F2攻击敌人


        /// <summary>
        /// 攻击委托：代表 方法，攻击时使用的方法
        /// </summary>
        public delegate void AttackHandler();

        //1>定义事件
        public event AttackHandler attackHandler;
        //2>在使用的时候注册，在调用端完成
        //3>触发事件

        /// <summary>
        /// 攻击时使用
        /// </summary>
        public void OnAttack() {
            // OnAttack 行为1 攻击发生时 行为2
            if (attackHandler != null)
                attackHandler(); 
        }
    }
}
