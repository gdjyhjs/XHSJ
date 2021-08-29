using System.Collections;
using System.Collections.Generic;
using System;
// 日期管理器
public class DateMgr {
    public enum Weather {
        /// <summary>
        /// 晴
        /// </summary>
        sunny,
        /// <summary>
        /// 多云
        /// </summary>
        cloudy,
        /// <summary>
        /// 小雨
        /// </summary>
        drizzle,
        /// <summary>
        /// 大雨
        /// </summary>
        downpour,
        /// <summary>
        /// 暴雨
        /// </summary>
        storm,
        /// <summary>
        /// 小雪
        /// </summary>
        fineSnow,
        /// <summary>
        /// 大雪
        /// </summary>
        majorSnow,
        /// <summary>
        /// 暴雪
        /// </summary>
        blizzard,
        /// <summary>
        /// 沙暴
        /// </summary>
        sandstorm,
        /// <summary>
        /// 雾霾
        /// </summary>
        haze,

        end,
    }
    
    private float timeScale = 20;
    private double m_time;
    public Weather weather;

    public DateMgr() {
        weather = (Weather)StaticTools.Random((int)Weather.sunny, (int)Weather.end);
        m_time = StaticTools.Random(130218841, 1630218841);
    }

    public double time { get { return m_time; } }
    public DateTime Time { get { return new DateTime( (long)m_time * 10000000); } }

    public void AddTime(float addTime) {
        m_time += addTime * timeScale;
    }



    public static string ToMonth(int month) {
        switch (month) {
            case 1:
                return "Jan";
            case 2:
                return "Feb";
            case 3:
                return "Mar";
            case 4:
                return "Apr";
            case 5:
                return "May";
            case 6:
                return "Jun";
            case 7:
                return "Jul";
            case 8:
                return "Aug";
            case 9:
                return "Sept";
            case 10:
                return "Oct";
            case 11:
                return "Nov";
            case 12:
                return "Dec";
            default:
                return "Jan";
        }
    }
}
