[System.Serializable]
/*
 * 心法
 * 需要道点
 * 增加属性类型
 * 增加属性数值
 */
public class HeartGongfaStaticData : GongfaStaticData {

    /// <summary>
    /// 道点
    /// </summary>
    public int need_daodian;

    /// <summary>
    /// 增加的属性类型
    /// </summary>
    public RoleAttribute attr_typ;

    /// <summary>
    /// 属性id，用于获取对应的描述
    /// </summary>
    public int gongfa_attr_id;

    /// <summary>
    /// 增加的属性值
    /// </summary>
    public int attr_value;
}
