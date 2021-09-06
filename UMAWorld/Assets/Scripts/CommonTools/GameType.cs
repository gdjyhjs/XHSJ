
//回调
using System.Collections.Generic;

namespace UMAWorld {

    public delegate T ReturnAction<T>();
    public delegate T1 ReturnAction<T1, T2>(T2 v);
    public delegate T1 ReturnAction<T1, T2, T3>(T2 v1, T3 v2);
    public delegate T1 ReturnAction<T1, T2, T3, T4>(T2 v1, T3 v2, T4 v3);
    public delegate T1 ReturnAction<T1, T2, T3, T4, T5>(T2 v1, T3 v2, T4 v3, T5 v4);
    public delegate T1 ReturnAction<T1, T2, T3, T4, T5, T6>(T2 v1, T3 v2, T4 v3, T5 v4, T6 v5);
    public delegate T1 ReturnAction<T1, T2, T3, T4, T5, T6, T7>(T2 v1, T3 v2, T4 v3, T5 v4, T6 v5, T7 v6);
    public delegate T1 ReturnAction<T1, T2, T3, T4, T5, T6, T7, T8>(T2 v1, T3 v2, T4 v3, T5 v4, T6 v5, T7 v6, T8 v7);
    public delegate T1 ReturnAction<T1, T2, T3, T4, T5, T6, T7, T8, T9>(T2 v1, T3 v2, T4 v3, T5 v4, T6 v5, T7 v6, T8 v7, T9 v8);
    public delegate T1 ReturnAction<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(T2 v1, T3 v2, T4 v3, T5 v4, T6 v5, T7 v6, T8 v7, T9 v8, T10 v9);

    //动态数据结构
    public class DataStruct<T1> {
        public T1 t1;
        public DataStruct(T1 t1) { this.t1 = t1; }
    }
    public class DataStruct<T1, T2> {
        public T1 t1;
        public T2 t2;
        public DataStruct(T1 t1, T2 t2) { this.t1 = t1; this.t2 = t2; }
    }
    public class DataStruct<T1, T2, T3> {
        public T1 t1;
        public T2 t2;
        public T3 t3;
        public DataStruct(T1 t1, T2 t2, T3 t3) { this.t1 = t1; this.t2 = t2; this.t3 = t3; }
    }
    public class DataStruct<T1, T2, T3, T4> {
        public T1 t1;
        public T2 t2;
        public T3 t3;
        public T4 t4;
        public DataStruct(T1 t1, T2 t2, T3 t3, T4 t4) { this.t1 = t1; this.t2 = t2; this.t3 = t3; this.t4 = t4; }
    }
    public class DataStruct<T1, T2, T3, T4, T5> {
        public T1 t1;
        public T2 t2;
        public T3 t3;
        public T4 t4;
        public T5 t5;
        public DataStruct(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5) { this.t1 = t1; this.t2 = t2; this.t3 = t3; this.t4 = t4; this.t5 = t5; }
    }
    public class DataStruct<T1, T2, T3, T4, T5, T6> {
        public T1 t1;
        public T2 t2;
        public T3 t3;
        public T4 t4;
        public T5 t5;
        public T6 t6;
        public DataStruct(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5, T6 t6) { this.t1 = t1; this.t2 = t2; this.t3 = t3; this.t4 = t4; this.t5 = t5; this.t6 = t6; }
    }

    //游戏配置
    public static class GameConf {
        public static bool isThread
        {
            get
            {
                if (isDebug)
                    return false;
                else
                    return true;
            }
        }             //是否开启多线程
        public static bool isDebug = true;             //是否测试模式
        public static int version = 1;             //游戏版本

        public static string unitTag = "WorldUnit";
        public static string spacename = "UMAWorld";
    }
}