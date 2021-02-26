
[System.Serializable]
public enum WorldUnit {
    /// <summary>
    /// 空
    /// </summary>
    None = 0,
    /// <summary>
    /// 障碍
    /// </summary>
    Impede = 1 << 0,
    /// <summary>
    /// 野怪
    /// </summary>
    Monster = 1 << 1,
    /// <summary>
    /// 城市
    /// </summary>
    City = 1 << 2,
    /// <summary>
    /// 凡人无法逾越的高山
    /// </summary>
    Mountain = 1 << 3,
    /// <summary>
    /// 新手村
    /// </summary>
    NewVillage = 1 << 4,

    /// <summary>
    /// 等待灵气
    /// </summary>
    WaitLingqi = 1 << 5,
    /// <summary>
    /// 等待药材
    /// </summary>
    WaitYaocai = 1 << 6,
    /// <summary>
    /// 等待金石
    /// </summary>
    WaitJinshi = 1 << 7,


    /// <summary>
    /// 等级区域1
    /// </summary>
    Level1 = 1 << 10,
    /// <summary>
    /// 等级区域2
    /// </summary>
    Level2 = 1 << 11,
    /// <summary>
    /// 等级区域3
    /// </summary>
    Level3 = 1 << 12,
    /// <summary>
    /// 等级区域4
    /// </summary>
    Level4 = 1 << 13,
    /// <summary>
    /// 等级区域5
    /// </summary>
    Level5 = 1 << 14,
}
