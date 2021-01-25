using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GenerateWorld
{
    [System.Serializable]
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

        public SpaceData[] GetGrounds() {
            GenerateMap generate = GenerateMap.instance;
            SpaceData[] result;
            if (space_id < generate.citys.Length) {
                // 是城市
                result = new SpaceData[2];
                result[1] = generate.citys[space_id];
            } else {
                // 森林
                result = new SpaceData[1];
            }
            result[0] = generate.grounds[space_id * 2 + 1];
            return result;
        }
    }
}