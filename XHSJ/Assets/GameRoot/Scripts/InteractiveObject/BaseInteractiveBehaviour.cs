using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Yellow.Interactive
{
    public class BaseInteractiveBehaviour : MonoBehaviour
    {
        /// <summary>
        /// 数据对象
        /// </summary>
        public BaseInteractiveObject dataObj;

        public void OnMouseDown() {
            
        }

        public void OnTriggerEnter(Collider other) {
            
        }

        public void OnTriggerExit(Collider other) {
            
        }

        /// <summary>
        /// 创建所有子对象
        /// </summary>
        private void LoadAllChilds() {

        }

        /// <summary>
        /// 卸载所有子对象
        /// </summary>
        private void UnLoadAllChilds() {

        }
    }
}