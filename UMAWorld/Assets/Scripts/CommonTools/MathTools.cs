using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine;
using Newtonsoft.Json;
using System;
using System.Reflection;

public static class MathTools {

    /// <summary>
    /// 判断点是否在多边形内
    /// </summary>
    public static bool PointIsInPolygon(List<Vector2> vertexPoints, Vector2 point) {
        bool c = false;
        for (int i = 0, j = vertexPoints.Count - 1; i < vertexPoints.Count; j = i++) {
            if (((vertexPoints[i].y > point.y) != (vertexPoints[j].y > point.y)) && (point.x < (vertexPoints[j].x - vertexPoints[i].x) * (point.y - vertexPoints[i].y) / (vertexPoints[j].y - vertexPoints[i].y) + vertexPoints[i].x)) {
                c = !c;
            }
        }
        return c;
    }

    /// <summary>
    /// 判断点是否在多边形内
    /// </summary>
    public static bool PointIsInPolygon(Vector2[] vertexPoints, Vector2 point) {
        bool c = false;
        for (int i = 0, j = vertexPoints.Length - 1; i < vertexPoints.Length; j = i++) {
            if (((vertexPoints[i].y > point.y) != (vertexPoints[j].y > point.y)) && (point.x < (vertexPoints[j].x - vertexPoints[i].x) * (point.y - vertexPoints[i].y) / (vertexPoints[j].y - vertexPoints[i].y) + vertexPoints[i].x)) {
                c = !c;
            }
        }
        return c;
    }

    /// <summary>
    /// 判断两条直线是否相交
    /// </summary>
    public static Vector2 LineIntersection(Vector2 lineFirstStar, Vector2 lineFirstEnd, Vector2 lineSecondStar, Vector2 lineSecondEnd) {
        /*
             * L1，L2都存在斜率的情况：
             * 直线方程L1: ( y - y1 ) / ( y2 - y1 ) = ( x - x1 ) / ( x2 - x1 ) 
             * => y = [ ( y2 - y1 ) / ( x2 - x1 ) ]( x - x1 ) + y1
             * 令 a = ( y2 - y1 ) / ( x2 - x1 )
             * 有 y = a * x - a * x1 + y1   .........1
             * 直线方程L2: ( y - y3 ) / ( y4 - y3 ) = ( x - x3 ) / ( x4 - x3 )
             * 令 b = ( y4 - y3 ) / ( x4 - x3 )
             * 有 y = b * x - b * x3 + y3 ..........2
             * 
             * 如果 a = b，则两直线平等，否则， 联解方程 1,2，得:
             * x = ( a * x1 - b * x3 - y1 + y3 ) / ( a - b )
             * y = a * x - a * x1 + y1
             * 
             * L1存在斜率, L2平行Y轴的情况：
             * x = x3
             * y = a * x3 - a * x1 + y1
             * 
             * L1 平行Y轴，L2存在斜率的情况：
             * x = x1
             * y = b * x - b * x3 + y3
             * 
             * L1与L2都平行Y轴的情况：
             * 如果 x1 = x3，那么L1与L2重合，否则平等
             * 
            */
        float a = 0, b = 0;
        int state = 0;
        if (lineFirstStar.x != lineFirstEnd.x) {
            a = (lineFirstEnd.y - lineFirstStar.y) / (lineFirstEnd.x - lineFirstStar.x);
            state |= 1;
        }
        if (lineSecondStar.x != lineSecondEnd.x) {
            b = (lineSecondEnd.y - lineSecondStar.y) / (lineSecondEnd.x - lineSecondStar.x);
            state |= 2;
        }
        switch (state) {
            case 0: //L1与L2都平行Y轴
                {
                    if (lineFirstStar.x == lineSecondStar.x) {
                        //throw new Exception("两条直线互相重合，且平行于Y轴，无法计算交点。");
                        return new Vector2(0, 0);
                    } else {
                        //throw new Exception("两条直线互相平行，且平行于Y轴，无法计算交点。");
                        return new Vector2(0, 0);
                    }
                }
            case 1: //L1存在斜率, L2平行Y轴
                {
                    float x = lineSecondStar.x;
                    float y = (lineFirstStar.x - x) * (-a) + lineFirstStar.y;
                    return new Vector2(x, y);
                }
            case 2: //L1 平行Y轴，L2存在斜率
                {
                    float x = lineFirstStar.x;
                    //网上有相似代码的，这一处是错误的。你可以对比case 1 的逻辑 进行分析
                    //源code:lineSecondStar * x + lineSecondStar * lineSecondStar.x + p3.y;
                    float y = (lineSecondStar.x - x) * (-b) + lineSecondStar.y;
                    return new Vector2(x, y);
                }
            case 3: //L1，L2都存在斜率
                {
                    if (a == b) {
                        // throw new Exception("两条直线平行或重合，无法计算交点。");
                        return new Vector2(0, 0);
                    }
                    float x = (a * lineFirstStar.x - b * lineSecondStar.x - lineFirstStar.y + lineSecondStar.y) / (a - b);
                    float y = a * x - a * lineFirstStar.x + lineFirstStar.y;
                    return new Vector2(x, y);
                }
        }
        return default;
    }

}
