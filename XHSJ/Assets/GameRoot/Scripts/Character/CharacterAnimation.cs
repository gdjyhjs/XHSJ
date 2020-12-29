using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
namespace ARPGDemo.Character
{
    /// <summary>
    /// 角色动画系统
    /// </summary>
    public class CharacterAnimation:MonoBehaviour
    {
        /// <summary>
        /// 动画组件
        /// </summary>
        private Animator anim;
        private void Start()
        {
            anim = GetComponentInChildren<Animator>();//!!!???
        }
        /// <summary>
        /// 播放动画:一个方法实现两个功能 开始 停止
        /// </summary>
        private string animPreName = "idle";
        public void PlayAnimation(string animNowName)//run
        {
            anim.SetBool(animPreName, false);
            anim.SetBool(animNowName, true);
            animPreName = animNowName;
        }
    }
}
