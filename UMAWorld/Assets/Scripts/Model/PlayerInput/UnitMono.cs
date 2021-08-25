using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// 存在修仙世界上的单位
public class PlayerInput:MonoBehaviour
{
    public UnitMono unit;
    public CharacterController controller;
    public Rigidbody rigi;

    private void Awake() {
        controller = StaticTools.GetOrAddComponent<CharacterController>(gameObject);
        rigi = StaticTools.GetOrAddComponent<Rigidbody>(gameObject);
        unit = GetComponent<UnitMono>();
    }

    private void LateUpdate() {
       Vector2 move = new Vector3( Input.GetAxis("Horizontal"),0,Input.GetAxis("Vertical"));
        // 移动了
        transform.Translate(move * unit.unitData.attribute.speed * Time.deltaTime);
    }
}
