using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GenerateWorld {

    [System.Serializable]
    public struct SpaceData {
        public Vector3 pos;
        public Vector3 scale;
        public SpaceType type;
        public float min_x ;
        public float max_x ;
        public float min_z ;
        public float max_z ;
        public float angle;
        public bool useMeshScale;
        public int id;
        public int idx;

        public SpaceData(Vector3 pos, Vector3 scale, SpaceType type, float angle = 0, bool useMeshScale = false, int id = 0, int idx = 0) {
            this.pos = pos;
            this.scale = scale;
            this.type = type;
            min_x = pos.x - scale.x / 2f - 1;
            max_x = pos.x + scale.x / 2f + 1;
            min_z = pos.z - scale.z / 2f - 1;
            max_z = pos.z + scale.z / 2f + 1;
            this.angle = angle;
            this.useMeshScale = useMeshScale;
            this.id = id;
            this.idx = idx;
        }

        /// <summary>
        /// 位置是否交叉
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool IsOverlap(SpaceData data, int dis) {
            int min_dix = GetHypotenuse((int)data.scale.z, (int)data.scale.x) /2 + GetHypotenuse((int)scale.z, (int)scale.x) /2 + dis;
            return Vector3.Distance(data.pos, pos) < min_dix;
        }

        int GetHypotenuse(int x, int y) {
            return MathTools.IntegerSqrt(x * x + y * y);
        }

        /// <summary>
        /// 判断是否在这块区域内
        /// </summary>
        /// <param name="pos">需要判断的坐标</param>
        /// <returns>是否在这块区域内</returns>
        public bool IsTherein(Vector3 pos, int edge = 0) {
            if (pos.x > (min_x - edge) && pos.x < (max_x + edge) && pos.z > (min_z - edge) && pos.z < (max_z + edge)) {
                return true;
            }
            return false;
        }
    }
}