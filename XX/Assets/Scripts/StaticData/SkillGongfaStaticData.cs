[System.Serializable]
/*
 * 心法
 * 需要道点
 * 增加属性类型
 * 增加属性数值
 */
public class SkillGongfaStaticData : GongfaStaticData {

    public SkillGongfaStaticData(int lv, GongfaType gongfa_typ, int color, int create_id) : base(lv, gongfa_typ, color, create_id) {
        // 主属性
        GongfaAttrData main_attr_data = GongfaAttrConfig.GetRandomExAttr(gongfa_typ | GongfaType.main);
        cool = main_attr_data.cool;
        cost = main_attr_data.cost;
    }

    /// <summary>
    /// 冷却时间
    /// </summary>
    public float cool;

    /// <summary>
    /// 消耗MP
    /// </summary>
    public int cost;
}
