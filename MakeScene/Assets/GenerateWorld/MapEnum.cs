using System.ComponentModel;

namespace GenerateWorld {
    public enum CreateType {
        Node,
        Tree,
        Decorate,
        City,
    }

    [System.Serializable]
    public enum SpaceType {
        /// <summary>
        /// 森林
        /// </summary>
        Forest,
        /// <summary>
        /// 地面
        /// </summary>
        Ground,
        /// <summary>
        /// 城市
        /// </summary>
        City,
        /// <summary>
        /// 房子
        /// </summary>
        House,
        /// <summary>
        /// 商店
        /// </summary>
        Shop,
        /// <summary>
        /// 道路
        /// </summary>
        Way,
        /// <summary>
        /// 墙
        /// </summary>
        Wall,
        /// <summary>
        /// 墙的节点
        /// </summary>
        WallNode,
        /// <summary>
        /// 树木
        /// </summary>
        Tree,
        /// <summary>
        /// 地面装饰物
        /// </summary>
        Decorate,
        /// <summary>
        /// 门
        /// </summary>
        Door,
        /// <summary>
        /// 海
        /// </summary>
        Sea,
        /// <summary>
        /// 水
        /// </summary>
        Water,
        /// <summary>
        /// 区域触发器
        /// </summary>
        AreaTrriger,
    }

    public enum Direction {
        /// <summary>
        /// 东
        /// </summary>
        East,
        /// <summary>
        /// 西
        /// </summary>
        West,
        /// <summary>
        /// 南
        /// </summary>
        South,
        /// <summary>
        /// 北
        /// </summary>
        North,
    }

    public enum BuildHouseState {
        /// <summary>
        /// 主要建筑
        /// </summary>
        Main,
        /// <summary>
        /// 商店
        /// </summary>
        Shop,
        /// <summary>
        /// 住宅
        /// </summary>
        Residence,

    }

    /// <summary>
    /// 生成世界数据状态
    /// </summary>
    public enum GenerateState {
        AreaTriiger,
        Ground,
        Wall,
        House,
        Tree,
        Decorate,
    }
}