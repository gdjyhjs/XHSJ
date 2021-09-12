using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = System.Random;
namespace UMAWorld {
    public class RandomRotate : MonoBehaviour {
        public int AngleCount = 1;
        public Vector3 axis = Vector3.up;
        void Start() {
            Random rand = new Random((int)transform.position.x + (int)transform.position.y);
            transform.localEulerAngles = axis * rand.Next(0, AngleCount) * 360;
        }
    }
}