
public enum RoleAttrShowType {
    /// <summary>
    /// 默认显示
    /// </summary>
    None = 0,
    /// <summary>
    /// 显示最大最小值
    /// </summary>
    MinMax = 1,
    /// <summary>
    /// 显示进度条
    /// </summary>
    Progress = 2,
    /// <summary>
    /// 魅力,0-999,3,0-非人;100-可憎;200-不扬;300-寻常;500-出众;600-瑾瑜-碧瑶;700-龙姿-凤仪;800-绝世-出尘;900-天人
    /// </summary>
    Text = 3,
    /// <summary>
    /// 带百分号 显示进度条
    /// </summary>
    RateProgress = 4,
    /// <summary>
    /// 固定是最大最小值
    /// </summary>
    FixedMinMax = 5,
}