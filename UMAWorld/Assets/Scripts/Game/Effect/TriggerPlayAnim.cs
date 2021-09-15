using System.Collections;
using System.Collections.Generic;
using UnityEngine;
// 修仙世界
namespace UMAWorld
{
    public class TriggerPlayAnim : MonoBehaviour
    {

        public AnimPlay animPlay;
        public float enterForwardParam = 1;
        public float enterBackwardParam = 1;
        public float exitForwardParam = 0;
        public float exitBackwardParam = 0;

        private int enterCount = 0;

        private void OnTriggerEnter(Collider other)
        {
            if (enterCount == 0)
            {
                animPlay.Play(IsForward(other) ? enterForwardParam : enterBackwardParam);
            }

            enterCount++;
        }

        private void OnTriggerExit(Collider other)
        {
            enterCount--;

            if (enterCount == 0)
            {
                animPlay.Play(IsForward(other) ? exitForwardParam : exitBackwardParam);
            }
        }


        private bool IsForward(Collider other)
        {
            var dir = other.transform.position - transform.position;
            var value = Vector3.Dot(dir.normalized, transform.forward);
            return value < 0;
        }
    }
}