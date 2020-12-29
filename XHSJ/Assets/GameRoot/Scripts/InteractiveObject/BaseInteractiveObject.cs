using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace Yellow.Interactive
{
    public class BaseInteractiveObject
    {
        /// <summary>
        /// 名字
        /// </summary>
        public string name;
        /// <summary>
        /// 所属主人
        /// </summary>
        public int master;
        /// <summary>
        /// 坐落位置
        /// </summary>
        public Vector3 position;
        /// <summary>
        /// 朝向
        /// </summary>
        public Vector3 vector3;
        /// <summary>
        /// 资源路径
        /// </summary>
        public string resPath;

        /// <summary>
        /// 行为对象
        /// </summary>
        public BaseInteractiveBehaviour target;

        /// <summary>
        /// 所属的可交互对象 比如桌子可以属于一个房子，房子可以属于一个城市
        /// 触发区域 - 城市 - 建筑 - 物件 - 物件 -- 物件
        /// 物件的子级可能包含其他物件，比如书架可以放书，桌子可以放瓶子，瓶子可以放丹药
        /// </summary>
        public BaseInteractiveObject parent;

        /// <summary>
        /// 所属于自己的子对象
        /// </summary>
        public BaseInteractiveObject[] childs;
    }
}
