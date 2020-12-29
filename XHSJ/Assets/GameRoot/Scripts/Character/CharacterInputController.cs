using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using ARPGDemo.Skill;

namespace ARPGDemo.Character
{
    /// <summary>
    /// 角色输入控制
    /// </summary>
    public class CharacterInputController:MonoBehaviour
    {
        bool lockMouse = true;

        /// <summary>
        /// 马达
        /// </summary>
        private CharacterMotor chMotor;

        private CharacterSkillSystem chSkillSys;
        /// <summary>
        /// 初始化字段：复杂类型【自定义类型】的字段
        /// </summary>
        private void Start()
        {
            chMotor = GetComponent<CharacterMotor>();
            chSkillSys = GetComponent<CharacterSkillSystem>();
            RestMouse();
        }

        /// <summary>
        /// 摇杆移动执行的方法  移动摇杆=执行下边这个方法 【联动】
        /// 如何通过【事件交互的方式】使用遥杆 1,2,注册事件
        /// </summary>
        public void JoystickMove(Vector2 move) {
            float angle = -_3DCamera.instance.transform.eulerAngles.y;
            if (angle < 0) {
                angle += 360;
            }
            float radians = angle * Mathf.Deg2Rad;
            float x = move.x;
            float y = move.y;
            Vector2 dir = new Vector2(
            // [x*cosA-y*sinA  x*sinA+y*cosA]
                    x * Mathf.Cos(radians) - y * Mathf.Sin(radians),
                    x * Mathf.Sin(radians) + y * Mathf.Cos(radians)
                );
            chMotor.Move(dir.x, dir.y);
        }

        /// <summary>
        /// 摇杆停止时执行的方法
        /// </summary>
        public void JoystickMoveEnd(Vector2 move)
        {
            chMotor.Move(move.x, move.y);
        }


        public void OnFire(string buttonName) {
            switch (buttonName) {
                case "Skill1":
                    chSkillSys.AttackUseSkill(11);
                    break;
                case "Skill2":
                    chSkillSys.AttackUseSkill(12);
                    break;
            }
        }

        bool onMove = false;
        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.LeftControl) || Input.GetKeyDown(KeyCode.RightControl)) {
                lockMouse = !lockMouse;
                RestMouse();
            }


            Vector2 dir = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
            if (dir != default) {
                onMove = true;
                JoystickMove(dir);
            }
            else if(onMove) {
                onMove = false;
                JoystickMoveEnd(dir);
            }

            if (lockMouse) {
                if (Input.GetButtonDown("Fire1")) {
                    OnFire("Skill1");
                }
                if (Input.GetButtonDown("Fire2")) {
                    OnFire("Skill2");
                }

                float X = Input.GetAxisRaw("Mouse X");
                float Y = Input.GetAxisRaw("Mouse Y");
                if (X != 0 || Y != 0) {
                    //CameraMovement.instance.OnRota(rota);
                    _3DCamera.instance.RotateView(X, Y);
                }


                float s = Input.GetAxis("Mouse ScrollWheel");
                if (s!=0) {
                    //CameraMovement.instance.OnRota(rota);
                    _3DCamera.instance.ScrollView(s);
                }
            }
        }

        private void OnEnable()//事件注册
        {

        }
        private void OnDisable()//事件取消注册
        {

        }

        void RestMouse() {
            if (lockMouse) {
                Cursor.visible = true;
                Cursor.lockState = CursorLockMode.Locked;
            } else {
                Cursor.visible = false;
                Cursor.lockState = CursorLockMode.Confined;
            }
        }

    }
}
