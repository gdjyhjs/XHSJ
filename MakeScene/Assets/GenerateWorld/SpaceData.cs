using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GenerateWorld {

    public struct SpaceData {
        public Vector2 pos;
        public float width;
        public float length;
        public SpaceType type;
        public float min_x ;
        public float max_x ;
        public float min_y ;
        public float max_y ;
        public Direction dir;
        public float angle;

        public SpaceData(Vector2 pos, float width, float length, SpaceType type, Direction dir = Direction.South, float angle = 0) {
            this.pos = pos;
            this.width = width;
            this.length = length;
            this.type = type;
             min_x = pos.x - width / 2f - 1;
             max_x = pos.x + width / 2f + 1;
             min_y = pos.y - length / 2f - 1;
             max_y = pos.y + length / 2f + 1;
            this.dir = dir;
            this.angle = angle;
        }

        /// <summary>
        /// 位置是否交叉
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool IsOverlap(SpaceData data, int dis) {
            int min_dix = GetHypotenuse((int)data.length, (int)data.width)/2 + GetHypotenuse((int)length, (int)width)/2 + dis;
            return Vector2.Distance(data.pos, pos) < min_dix;
        }

        int GetHypotenuse(int x, int y) {
            return IntegerSqrt(x * x + y * y);
        }

        int IntegerSqrt(int value) {
            int result = 0;
            while (result * result < value) {
                result++;
            }
            return result;
        }

        /// <summary>
        /// 判断是否在这块区域内
        /// </summary>
        /// <param name="pos">需要判断的坐标</param>
        /// <returns>是否在这块区域内</returns>
        public bool IsTherein(Vector2 pos, int edge = 0) {
            if (pos.x > (min_x - edge) && pos.x < (max_x + edge) && pos.y > (min_y - edge) && pos.y < (max_y + edge)) {
                return true;
            }
            return false;
        }
    }
}