using System;
// 由于单例基类不能实例化，故设计为抽象类
public abstract class Singleton<T> where T : class
{
    // 这里采用实现5的方案，实际可采用上述任意一种方案
    class Nested
    {
        // 创建模板类实例，参数2设为true表示支持私有构造函数
        internal static readonly T instance = Activator.CreateInstance(typeof(T), true) as T;
    }
    private static T instance = null;
    public static T Instance { get { return Nested.instance; } }
}