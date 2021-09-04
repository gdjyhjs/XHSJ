using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityStandardAssets.Characters.ThirdPerson;
using UnityStandardAssets.CrossPlatformInput;


namespace UMAWorld {
    [RequireComponent(typeof(ThirdPersonUserControl))]
    // 属性
    public class UserInput : MonoBehaviour {
        public UnitMono unitMono;
        public ThirdPersonCharacter person;

        private void Awake() {
            person = GetComponent<ThirdPersonCharacter>();
            unitMono = GetComponent<UnitMono>();
        }


        private void Update() {
            if (CrossPlatformInputManager.GetButtonDown("Fire1")) {
                person.PlayTrigger("Attack1");
            } else if (CrossPlatformInputManager.GetButtonDown("Fire2")) {
                person.PlayTrigger("Attack2");
            }
        }


    }
}