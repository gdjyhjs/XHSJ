using Newtonsoft.Json;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// 存在修仙世界上的单位
public class UnitBase {
    /// <summary>
    /// 角色名字
    /// </summary>
    public string id;
    [JsonIgnore]
    public Vector3 pos
    {
        get
        {
            return new Vector3(pos_x, pos_y, pos_z);
        }
        set
        {
            pos_x = value.x;
            pos_y = value.y;
            pos_z = value.z;
        }
    }
    private float pos_x, pos_y, pos_z; // 角色在世界中的位置

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
