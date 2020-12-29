using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnterTriggerRecord : MonoBehaviour
{
    [SerializeField]
    SphereCollider trigger;
    [SerializeField]
    List<GameObject> enterObjs = new List<GameObject>();
    [SerializeField]
    List<GameObject> ignoreObjs = new List<GameObject>();

    public List<GameObject> EnterObjs { get { return enterObjs; } }
    public void SetTriggerRadius(float radius) {
        trigger.radius = radius;
    }

    void Awake()
    {
        trigger.isTrigger = true;
        SetTriggerRadius(20);
        AddIgnoreObj(gameObject);
    }

    private void OnTriggerEnter(Collider other) {
        GameObject obj = other.gameObject;
        if (!ignoreObjs.Contains(obj) && !enterObjs.Contains(obj))
            enterObjs.Add(obj);
    }

    private void OnTriggerExit(Collider other) {
        GameObject obj = other.gameObject;
        if (!ignoreObjs.Contains(obj) && enterObjs.Contains(obj))
            enterObjs.Remove(obj);
    }

    public void AddIgnoreObj(GameObject obj) {
        if (!ignoreObjs.Contains(obj)) {
            ignoreObjs.Add(obj);
        }
        if (enterObjs.Contains(obj)) {
            enterObjs.Remove(obj);
        }
    }

    public void RemoveIgnoreObj(GameObject obj) {
        Debug.Log("RemoveIgnoreObj:" + obj);
        if (!ignoreObjs.Contains(obj)) {
            ignoreObjs.Add(obj);
        }
        Debug.Log("trigger:" + obj);
        if (Vector3.Distance(obj.transform.position, transform.position) <= trigger.radius) {
            if (!enterObjs.Contains(obj)) {
                enterObjs.Add(obj);
            }
        }
    }
}