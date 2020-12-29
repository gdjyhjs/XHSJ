using UnityEngine;
using System.Collections;
using System;

public class _3DCamera : MonoSingleton<_3DCamera>
{
    public static Camera mainCamera;
    public Transform eye;
    public Vector3 offset;
    public float scrollSpeed = 5;
    public float rotateSpeed = 5;
    public float minDis = 1;
    public float maxDis = 10;
    public float minAngle = -10;
    public float maxAngle = 45;
    public float distance;
    public int hitLayer;
    RaycastHit hit;

    private void Awake() {
        mainCamera = GetComponent<Camera>();
        distance = offset.magnitude;
        offset = transform.position - eye.position;
        hitLayer = 1 << 8;
        transform.SetParent(null);
    }

    private void LateUpdate() {
        if (Physics.Raycast(eye.position, offset, out hit, distance + 0.1f, hitLayer)) {
            distance = (hit.point - eye.position).magnitude;
            offset = offset.normalized * (distance - 0.1f);
        }
        transform.position = Vector3.Lerp(transform.position, eye.transform.position + offset, Time.deltaTime * 100);
        transform.LookAt(eye);
    }

    public void ScrollView(float x) {
        //获取鼠标中键滚动的值，向上滚为正值，向下为负值
        distance += x * scrollSpeed * -1 * Time.deltaTime;
        //超出指定范围将不做变化
        bool bug = false;
        if (distance < minDis) {
            if (x > 0) {
                distance = 0.01f;
            } else {
                distance = minDis;
            }
            bug = true;
        } else if (distance > maxDis) {
            distance = maxDis;
        }
        offset = offset.normalized * distance;
        if (bug)
            transform.position = eye.transform.position + offset;
    }

    public void RotateView(float x, float y) {
        //得到鼠标在鼠标在x轴和y轴滑动的axis值
        transform.RotateAround(eye.transform.position, Vector3.up, rotateSpeed * x); //正值为向右，负值为向左
        Vector3 pos = transform.position;
        Quaternion qua = transform.rotation;
        //旋转的轴为人物的x轴，而不是世界的x轴
        transform.RotateAround(eye.transform.position, transform.right, -1 * rotateSpeed * y);
        //如果超出范围，就还原
        if ((transform.eulerAngles.x <= minAngle + 360 && transform.eulerAngles.x >= maxAngle) || transform.eulerAngles.x < minAngle) {
            transform.position = pos;
            transform.rotation = qua;
            return;
        }
        offset = (transform.position - eye.transform.position).normalized * distance;
    }
}