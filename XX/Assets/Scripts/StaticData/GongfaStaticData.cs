[System.Serializable]
/*
 * 功法
 * 名字
 * 等级
 * 品质
 * 价值
 * 功法类型
 * 词条编号[]
 * 词条属性[]
 * 词条属性[][] 第一个idx是指第几条属性，第二个idx是指该属性第几个数值
 * 学习条件需求属性[][] 第一个idx=x表示第几个条件（需要同时达成） 第二个idx=y表示第x个条件达成任意一条y条件即可
 * 学习条件需求数值[]
 */
public class GongfaStaticData
{
    /// <summary>
    /// 功法id 功法中唯一
    /// </summary>
    public int id;
    /// <summary>
    /// 功法名称
    /// </summary>
    public string name;
    /// <summary>
    /// 功法等级
    /// </summary>
    public int level;
    /// <summary>
    /// 功法品质
    /// </summary>
    public int color;
    /// <summary>
    /// 功法价值
    /// </summary>
    public int price;
    /// <summary>
    /// 功法类型
    /// </summary>
    public GongfaType type;
    /// <summary>
    /// 功法词条id
    /// </summary>
    public int[] ex_gongfa_attr_data_id;
    /// <summary>
    /// 词条属性类型
    /// </summary>
    public RoleAttribute[] ex_attrs;
    /// <summary>
    /// 词条属性数值
    /// </summary>
    public int[][] ex_values;
    /// <summary>
    /// 功法需求条件
    /// </summary>
    public RoleAttribute[][] attr_condition;
    /// <summary>
    /// 功法需求数值
    /// </summary>
    public int[] value_condition;
}
