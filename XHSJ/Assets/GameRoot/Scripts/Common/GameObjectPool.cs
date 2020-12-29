using UnityEngine;
using System.Collections;
using System.Collections.Generic;
/// <summary>
/// 游戏对象池： 可以管理很多游戏对象
/// </summary>
public class GameObjectPool: MonoSingleton<GameObjectPool>
{
    private GameObjectPool()
    { 
    
    }
    //1创建池
    private Dictionary<string, List<GameObject>>
        cache = new Dictionary<string, List<GameObject>>();
   
    //2创建一个游戏对象并使用 :
    public GameObject CreateObject(string key,GameObject
        go, Vector3 position, Quaternion quaternion)
    {
        //1,从池中查找可用对象、
        GameObject tempGo = FindUsable(key);
        //2,池中有，从池中返回【出现在画面】
        if (tempGo != null)
        {
            tempGo.transform.position = position;
            tempGo.transform.rotation = quaternion;
            tempGo.SetActive(true);//
        }
        else//3,池中没有，加载，放入池中，再返回
        {
            tempGo = Instantiate(go, position, quaternion) as GameObject;
            Add(key,tempGo);
        }
        tempGo.transform.SetParent(this.transform);
        return tempGo;        
    }
    //查找可用对象
    private GameObject FindUsable(string key)
    {
        if (cache.ContainsKey(key))
        {
           return cache[key].Find(p => !p.activeSelf);
        }
        return null;
    }
    //放入池中
    private void Add(string key, GameObject go)
    {
        if (!cache.ContainsKey(key))
        {
            cache.Add(key, new List<GameObject>());
        }
        //
        cache[key].Add(go);
    }   

    //3释放资源：从池中删除对象
    //3.1释放部分：按key释放
    public void Clear(string key)
    {
        if(cache.ContainsKey(key))
        {
            for(int i=0;i<cache[key].Count;i++)
            {
                Destroy(cache[key][i]);//游戏物体
            }
            cache.Remove(key);//移除对象的引用
        }
    }
    //3.2释放全部
    public void ClearAll()
    {
        //1找到所有的key
        List<string> keys = new List<string>(cache.Keys);
        //2循环调用 lear(string key)
        foreach (var key in keys)
        {
            Clear(key);
        }
    }
    //4回收对象：使用完游戏对象返回池中【从画面中消失】
    //4.1即时回收对象
    public void CollectObject(GameObject go)
    {
        go.SetActive(false);
    }
    //4.2延时回收对象
    public void CollectObject(GameObject go,float delay)
    {
        StartCoroutine(CollectDelay(go, delay));
    }
    private IEnumerator CollectDelay(GameObject go, float delay)
    {
        yield return new WaitForSeconds(delay);
        CollectObject(go);
    }
    //

   
	
}
