using UnityEngine;
using System.Collections;

/// Transform助手
public static class TransformHelper 
{
    /// <summary>
    /// 转向前往的方向
    /// </summary>
    static public void LookAtTarget(Vector3 target, Transform transform, float rotationSpeed)
    {
        if (target != Vector3.zero)
        {
            Quaternion dir = Quaternion.LookRotation(target);
            transform.rotation =
                Quaternion.Lerp(transform.rotation,
                dir, rotationSpeed);
        }
    }
    
    /// 在所有子级中查找子物体
    public static Transform FindChild(Transform parent,string goName)//递归
    {
        var child = parent.Find(goName);
        if (child != null) return child;

        for (int i = 0; i < parent.childCount; i++)
        {
            child = parent.GetChild(i);
            var go = FindChild(child, goName);
            if (go != null)
                return go;
        }
        return null;
    }
}
