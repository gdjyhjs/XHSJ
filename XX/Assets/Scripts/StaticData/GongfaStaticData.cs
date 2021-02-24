[System.Serializable]
/*
 * 功法
 * 名字
 * 等级
 * 品质
 * 价值
 * 功法类型
 * 主属性词条id
 * 主属性词条属性值[]
 * 词条id[]
 * 词条属性数值[][] 第一个idx是指第几条属性，第二个idx是指该属性第几个数值
 * 学习条件需求属性[][] 第一个idx=x表示第几个条件（需要同时达成） 第二个idx=y表示第x个条件达成任意一条y条件即可
 * 学习条件需求数值[]
 * 学习难度
 */
public class GongfaStaticData
{
    public GongfaStaticData(int lv, GongfaType gongfa_typ, int color, int create_id) {

        id = create_id;
        level = lv;
        this.color = color;
        price = 20 * (lv + 1) * (color + 1);
        type = gongfa_typ;

        // 主属性
        GongfaAttrData[] main_attr_data = GongfaAttrConfig.GetMainAttr(gongfa_typ | GongfaType.main);
        int attr_count = main_attr_data.Length;
        attr_id = new int[attr_count];
        attr_value = new int[attr_count][];
        for (int i = 0; i < attr_count; i++) {
            attr_id[i] = main_attr_data[i].id;
            attr_value[i] = main_attr_data[i].GetRandomAttr(lv, color);
        }

        string name = "";
        // 随机功法词条
        int ex_count = lv + color;
        ex_id = new int[ex_count];
        ex_values = new int[ex_count][];
        ex_color = new int[ex_count];
        for (int i = 0; i < ex_count; i++) {
            ex_color[i] = UnityEngine.Random.Range(0, GameConst.max_color + 1);
            GongfaAttrData congfa_attr_data = GongfaAttrConfig.GetRandomExAttr(gongfa_typ);
            ex_id[i] = congfa_attr_data.id;
            ex_values[i] = congfa_attr_data.GetRandomAttr(lv, color);
            if (i < 2) {
                name += congfa_attr_data.name;
            }
        }
        this.name = name + main_attr_data[0].name;

        difficult = lv * lv + color;

        SetGongfaCondition();
    }

    public virtual void SetGongfaCondition() {

        // 功法需求
        attr_condition = new RoleAttribute[1][];
        value_condition = new int[1] { level * level * 6 + level * color + level * 2 + color }; // 等级*等级*6+等级*品质+等级*2+品质

        int max = RoleAttribute.linggen_wood - RoleAttribute.gongfa_knife;
        for (int i = 0; i <= max; i++) {
            GongfaType typ = (GongfaType)(1 << i);
            if ((type & typ) == typ) {
                attr_condition[0] = new RoleAttribute[] { RoleAttribute.gongfa_knife + i };
                break;
            }
        }
        UnityEngine.Debug.Log("  A属性条件  " + attr_condition);
        UnityEngine.Debug.Log("  A属性条件  " + attr_condition[0][0]);
    }

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
    /// 主属性词条id
    /// </summary>
    public int[] attr_id;

    /// <summary>
    /// 主属性词条属性值
    /// </summary>
    public int[][] attr_value;

    /// <summary>
    /// 词条id
    /// </summary>
    public int[] ex_id;
    /// <summary>
    /// 词条属性数值
    /// </summary>
    public int[][] ex_values;
    /// <summary>
    /// 词条属性品质
    /// </summary>
    public int[] ex_color;

    /// <summary>
    /// 功法需求条件 第一个索引是表示第几个条件（需要同时达成）  第二个索引是表示达成任何一个即可
    /// </summary>
    public RoleAttribute[][] attr_condition;
    /// <summary>
    /// 功法需求数值
    /// </summary>
    public int[] value_condition;

    /// <summary>
    /// 难度
    /// </summary>
    public int difficult;
}
