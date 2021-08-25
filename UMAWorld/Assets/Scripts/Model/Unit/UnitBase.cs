using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// 存在修仙世界上的单位
public class UnitBase {
    public string id; // 角色名字
    public Vector3 pos; // 角色在世界中的位置

    public Appearance appearance;
    public Attribute attribute;
    public SkillManager skillManager;
    public BuffManager buffManager;

    public UnitBase() {
        appearance = new Appearance();
        attribute = new Attribute();
        skillManager = new SkillManager();
        buffManager = new BuffManager();
    }


}
