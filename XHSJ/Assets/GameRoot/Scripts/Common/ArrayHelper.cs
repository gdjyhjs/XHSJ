using System;
using System.Collections.Generic;

public class ArrayHelper
{        
    
    /// <summary>
    /// 1升序排列： 通用的+方便的+跨平台
    /// </summary>
    /// <typeparam name="T">数据类型 ：学生类</typeparam>
    /// <typeparam name="TKey">数据类型的某个属性：学生的年龄或身高</typeparam>
    /// <param name="array">数据类型的数组</param>
    /// <param name="handler">从某个对象中 选取某个属性的值返回的委托</param>
    public static void OrderBy<T,TKey>
        (T[] array,SelectHandler<T,TKey> handler)
        where TKey : IComparable
    {
        for (int i = 0; i < array.Length; i++)
        {
            for (int k = i + 1; k < array.Length; k++)
            {                
                if ((handler(array[i]).CompareTo(handler(array[k]))) > 0)             
                {
                    var temp = array[i];
                    array[i] = array[k];
                    array[k] = temp;
                }
            }
        }
    }
    /// <summary>
    /// 2 降序排列： 通用的+方便的+跨平台
    /// </summary>
    /// <typeparam name="T">数据类型 ：学生类</typeparam>
    /// <typeparam name="TKey">数据类型的某个属性：学生的年龄或身高</typeparam>
    /// <param name="array">数据类型的数组</param>
    /// <param name="handler">从某个对象中 选取某个属性的值返回的委托</param>
    public static void OrderByDescending<T, TKey>
        (T[] array, SelectHandler<T, TKey> handler)
        where TKey : IComparable
    {
        for (int i = 0; i < array.Length; i++)
        {
            for (int k = i + 1; k < array.Length; k++)
            {               
               
                if ((handler(array[i]).CompareTo(handler(array[k]))) < 0) 
                {
                    var temp = array[i];
                    array[i] = array[k];
                    array[k] = temp;
                }
            }
        }
    }
    /// <summary>
    /// 3 找最大 返回： 通用的+方便的+跨平台
    /// </summary>
    /// <typeparam name="T">数据类型 ：学生类</typeparam>
    /// <typeparam name="TKey">数据类型的某个属性：学生的年龄或身高</typeparam>
    /// <param name="array">数据类型的数组</param>
    /// <param name="handler">从某个对象中 选取某个属性的值返回的委托</param>
    public static T Max<T, TKey>
        (T[] array, SelectHandler<T, TKey> handler)
        where TKey : IComparable
    {
        T t = array[0];
        for (int i = 1; i < array.Length; i++)
        {
                
            if ((handler(t).CompareTo(handler(array[i]))) < 0) //(?)
            {
                t = array[i];                   
            }               
        }
        return t;
    }

    /// <summary>
    /// 4 找最小 返回： 通用的+方便的+跨平台
    /// </summary>
    /// <typeparam name="T">数据类型 ：学生类</typeparam>
    /// <typeparam name="TKey">数据类型的某个属性：学生的年龄或身高</typeparam>
    /// <param name="array">数据类型的数组</param>
    /// <param name="handler">从某个对象中 选取某个属性的值返回的委托</param>
    public static T Min<T, TKey>
        (T[] array, SelectHandler<T, TKey> handler)
        where TKey : IComparable
    {
        T t = array[0];
        for (int i = 1; i < array.Length; i++)
        {

            if ((handler(t).CompareTo(handler(array[i]))) > 0) 
            {
                t = array[i];
            }
        }
        return t;
    }              
    /// <summary>
    /// 查找满足条件的单个
    /// </summary>
    /// <typeparam name="T">数据类型</typeparam>
    /// <param name="array">数据类型的数组</param>
    /// <param name="handler">委托类型代表 查找条件 【多种多样】</param>
    /// <returns>单个对象</returns>
    public static T Find<T>(T[] array, FindHandler<T> handler)
    {
        T t = default(T);
        for (int i = 0; i < array.Length; i++)
        {                
            if (handler(array[i])) 
            {                     
                t = array[i];
                return t; 
            }
        }
        return t;
    }    
    /// <summary>
    /// 查找满足条件的查找全部
    /// </summary>
    /// <typeparam name="T">数据类型</typeparam>
    /// <param name="array">数据类型的数组</param>
    /// <param name="handler">委托类型代表 查找条件 【多种多样】</param>
    /// <returns>满足条件的全部</returns>
    public static T[] FindAll<T>(T[] array, FindHandler<T> handler)
    {
        List<T> list = new List<T>();
        for (int i = 0; i < array.Length; i++)
        {
            if (handler(array[i]))
            {
                list.Add(array[i]);                 
            }
        }
        return list.ToArray();
    }
    /// <summary>
    /// 选取数组中对象的某些成员形成一个独立的数组
    /// </summary>
    /// <typeparam name="T">数据类型</typeparam>
    /// <typeparam name="TKey">数据类型的某个属性</typeparam>
    /// <param name="array">数据类型的数组</param>
    /// <param name="handler">选取某个属性的委托</param>
    /// <returns>新的数组</returns>
    public static TKey[] Select<T, TKey>(T[] array, SelectHandler<T, TKey> handler)
    {
        TKey[] keys = new TKey[array.Length];
        for (int i = 0; i < array.Length; i++)
        {
            keys[i]=handler(array[i]);            
        }
        return keys;        
    }
}
/// <summary>
/// 这个委托数据类型 代表方法：从某个对象中 选取某个属性的值返回
/// </summary>
/// <typeparam name="T">对象的数据类型 </typeparam>
/// <typeparam name="TKey">对象的某个属性的类型</typeparam>
/// <param name="t">对象</param>
/// <returns>对象的某个属性的值</returns>
public delegate TKey SelectHandler<T,TKey>(T t);//t 老师，学生，
//从对象t中取某个属性的值返回 zs.id,zs.age,zs.name
/// <summary>
/// 表示查找条件的委托 ： bool  T [?]
/// </summary>
/// <typeparam name="T">数据类型</typeparam>
/// <param name="t">数据类型的对象</param>
/// <returns>返回条件bool值</returns>
public delegate bool FindHandler<T>(T t);
//

