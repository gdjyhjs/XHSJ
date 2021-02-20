[System.Serializable]
/*
 * 心法
 * 需要道点
 */
public class HeartGongfaStaticData : GongfaStaticData {
    public HeartGongfaStaticData(int lv, GongfaType gongfa_typ, int color, int create_id) : base(lv, gongfa_typ, color, create_id) {
        need_daodian = (int)((level * level * 6 + level * color + level * 2 + color) * 0.1f * color + 2 * color); // (等级*等级*6+等级*品质+等级*2+品质)*0.1*品质+2*品质
    }

    public override void SetGongfaCondition() {
        if ((type & GongfaType.gong) == GongfaType.gong || (type & GongfaType.juan) == GongfaType.juan) {
            base.SetGongfaCondition();
        } else {
            attr_condition = new RoleAttribute[1][];
            value_condition = new int[1] { level * level * 6 + level * color + level * 2 + color }; // 等级*等级*6+等级*品质+等级*2+品质
            attr_condition[0] = new RoleAttribute[] { RoleAttribute.gongfa_knife, RoleAttribute.gongfa_spear, RoleAttribute.gongfa_sword,
            RoleAttribute.gongfa_fist,RoleAttribute.gongfa_palm,RoleAttribute.gongfa_finger,};
        }
    }

    /// <summary>
    /// 道点
    /// </summary>
    public int need_daodian;

}