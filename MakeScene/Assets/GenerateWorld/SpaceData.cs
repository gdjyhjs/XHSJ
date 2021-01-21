using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GenerateWorld {

    public struct SpaceData {
        public Vector2 pos;
        public int width;
        public int length;
        public SpaceType type;
        public Rect rect;

        public SpaceData(Vector2 pos, int width, int length, SpaceType type) {
            this.pos = pos;
            this.width = width;
            this.length = length;
            this.type = type;
            float min_x = pos.x - width / 2f - 1;
            float max_x = pos.x + width / 2f + 1;
            float min_y = pos.y - length / 2f - 1;
            float max_y = pos.y + length / 2f + 1;
            rect = new Rect(min_x, min_y, max_x, max_y);
        }

        /// <summary>
        /// 位置是否交叉
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool IsOverlap(SpaceData data, int dis) {
            int min_dix = GetHypotenuse(data.length, data.width)/2 + GetHypotenuse(length, width)/2 + dis;
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
            if (pos.x > (rect.x - edge) && pos.x < (rect.width+ edge) && pos.y > (rect.y- edge) && pos.y < (rect.height + edge)) {
                return true;
            }
            return false;
        }
    }
}