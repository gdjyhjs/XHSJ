using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
namespace ARPGDemo.Character
{
    /// <summary>
    /// 角色马达
    /// </summary>
    public class CharacterMotor:MonoBehaviour
    {
        /// <summary>
        /// 移动速度
        /// </summary>
        public float moveSpeed=5f;
        /// <summary>
        /// 转向速度
        /// </summary>
        public float rotationSpeed=0.5f;//经验 试一试
        /// <summary>
        /// 动画系统
        /// </summary>
        private CharacterAnimation chAnim;
        /// <summary>
        /// 角色控制器
        /// </summary>
        private CharacterController chController;

        private void Start()
        {
            chAnim = GetComponent<CharacterAnimation>();
            chController = GetComponent<CharacterController>();
        }
        /// <summary>
        /// 移动  游戏场景中的移动的做法=积累 经验
        /// </summary>
        public void Move(float h,float v)
        {
            if (h != 0 || v != 0)
            {
                //1转向前往的方向
                TransformHelper.LookAtTarget(new Vector3(h,0,v), transform, rotationSpeed);
                //2生成一个移动的方向 
                //山地：凹凸不平，y=-1 模拟重力 =试一试
                Vector3 dir = new Vector3(transform.forward.x,
                    -1,transform.forward.z);
                //3调用角色控制器的Move的方法
                chController.Move(dir*Time.deltaTime*moveSpeed);
                //4播放运动动画
                chAnim.PlayAnimation("move");
            }
            else
            {   //播放闲置动画
                chAnim.PlayAnimation("idle");
            }
            
        }
    }
}
