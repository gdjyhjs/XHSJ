using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GenerateWorld {
    /// <summary>
    /// 区域数据
    /// </summary>
    public struct AreaData  {
        int space_id;
        SpaceData[] tree_datas; // 树木
        SpaceData[] decorate_datas; // 装饰物
        SpaceData[] wall_datas; // 围墙和道路
        SpaceData[] house_datas; // 住宅和商店

        public AreaData(int spaceID, SpaceData[] treeDatas, SpaceData[] decorateDatas) {
            this.space_id = spaceID;
            this.tree_datas = treeDatas;
            this.decorate_datas = decorateDatas;
            this.wall_datas = null;
            this.house_datas = null;
        }
        public AreaData(int spaceID, SpaceData[] treeDatas, SpaceData[] decorateDatas, SpaceData[] wallDatas, SpaceData[] houseDatas) {
            this.space_id = spaceID;
            this.tree_datas = treeDatas;
            this.decorate_datas = decorateDatas;
            this.wall_datas = wallDatas;
            this.house_datas = houseDatas;
        }
    }
}