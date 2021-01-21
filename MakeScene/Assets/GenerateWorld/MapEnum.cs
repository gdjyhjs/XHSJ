namespace GenerateWorld {
    public enum CreateType {
        Node,
        Tree,
        Decorate,
        City,
    }

    public enum SpaceType {
        /// <summary>
        /// 森林
        /// </summary>
        Forest,
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
}