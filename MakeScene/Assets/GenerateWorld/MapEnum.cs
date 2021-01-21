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
        East,
        West,
        South,
        North,
    }
}