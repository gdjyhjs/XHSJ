using System.Collections;
using System.Collections.Generic;
using UnityEngine;
// 修仙世界
namespace UMAWorld
{
    [RequireComponent(typeof(Animator))]
    public class AnimPlay : MonoBehaviour
    {
        private Animator anim;
        private float play = 0;
        private float toPlay = 0;
        public float playSpeed = 5;
        public AnimationClip openClip;
        public AnimationClip closeClip;
        private void Awake()
        {
            anim = GetComponent<Animator>();
        }

        public void Play(float play)
        {
            if (play == 0)
            {
                toPlay = 0;
            }
            else if (toPlay == 0)
            {
                toPlay = play;
            }
        }

        private void Update()
        {
            if (play != toPlay)
            {
                play = Mathf.Lerp(play, toPlay, Time.deltaTime * playSpeed);
                anim.SetFloat("Open", play);
            }
        }

    }
}