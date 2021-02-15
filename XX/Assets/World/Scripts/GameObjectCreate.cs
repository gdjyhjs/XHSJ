using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameObjectCreate : MonoBehaviour {

    /// <summary>
    /// 阻碍物
    /// </summary>
    public WorldGameObject[] impede;
    /// <summary>
    /// 城市
    /// </summary>
    public WorldGameObject[] city;
    /// <summary>
    /// 大城市
    /// </summary>
    public WorldGameObject[] bigCity;
    /// <summary>
    /// 宗门
    /// </summary>
    public WorldGameObject[] pope;
    /// <summary>
    /// 秘境
    /// </summary>
    public WorldGameObject[] secret;
    /// <summary>
    /// 遗迹
    /// </summary>
    public WorldGameObject[] vestige;
    /// <summary>
    /// 石阵
    /// </summary>
    public WorldGameObject[] mysteriousStone;
    /// <summary>
    /// 药园
    /// </summary>
    public WorldGameObject[] garden;
    /// <summary>
    /// 元素区域
    /// </summary>
    public WorldGameObject[] element;
    /// <summary>
    /// 传送阵
    /// </summary>
    public WorldGameObject[] transmit;
    /// <summary>
    /// 路标
    /// </summary>
    public WorldGameObject[] sign;
    /// <summary>
    /// 高山
    /// </summary>
    public WorldGameObject[] mountain;

    public void CreateWorld() {
        Transform worldObj = transform.parent.Find("worldObj");
        if (worldObj) {
            Destroy(worldObj.gameObject);
        }
        worldObj = new GameObject().transform;
        worldObj.name = "worldObj";
        worldObj.transform.SetParent(transform.parent);

        var world = GetComponent<WorldCreate>();
        for (int z = 0; z < world.size; z++) {
            for (int x = 0; x < world.size; x++) {
                WorldUnit unit = world.get_units(x, z);
                if ((unit & WorldUnit.Impede) == WorldUnit.Impede) {
                    CreateObj(impede[0].obj, worldObj, new Vector3(x, 0, z), world.scale, impede[0].size);
                } else if((unit & WorldUnit.Mountain) == WorldUnit.Mountain) {
                    CreateObj(mountain[0].obj, worldObj, new Vector3(x, 0, z), world.scale, mountain[0].size);
                }
            }
        }
    }

    public void CreatePoint() {
        Transform pointObj = transform.parent.Find("pointObj");
        if (pointObj) {
            Destroy(pointObj.gameObject);
        }
        pointObj = new GameObject().transform;
        pointObj.name = "pointObj";
        pointObj.transform.SetParent(transform.parent);

        var world = GetComponent<WorldCreate>();
        var point = GetComponent<PointCreate>();

        CreateObj(city[0].obj, pointObj, point.newHand, world.scale, city[0].size); // 新手村

        CreateObj(city[0].obj, pointObj, point.foolish, world.scale, city[0].size); // 愚村

        for (int i = 0; i < point.pope.Length; i++) {
            int idx = i % pope.Length;
            CreateObj(pope[idx].obj, pointObj, point.pope[i], world.scale, pope[idx].size); // 宗门
        }

        for (int i = 0; i < point.city.Length; i++) {
            int idx = i % 7;
            if (idx % 7 == 0) {
                idx = i % bigCity.Length;
                CreateObj(bigCity[idx].obj, pointObj, point.city[i], world.scale, bigCity[idx].size); // 大城市
            } else {
                idx = i % city.Length;
                CreateObj(city[idx].obj, pointObj, point.city[i], world.scale, city[idx].size); // 小镇
            }
        }


        for (int i = 0; i < point.vestige.Length; i++) {
            int idx = i % 18;
            if (idx < 6) {
                idx = i % secret.Length;
                CreateObj(secret[idx].obj, pointObj, point.vestige[i], world.scale, secret[idx].size); // 秘境
            } else if (idx < 10) {
                idx = i % vestige.Length;
                CreateObj(vestige[idx].obj, pointObj, point.vestige[i], world.scale, vestige[idx].size); // 上古遗迹
            } else if (idx < 14) {
                idx = i % mysteriousStone.Length;
                CreateObj(mysteriousStone[idx].obj, pointObj, point.vestige[i], world.scale, mysteriousStone[idx].size); // 石阵
            } else if (idx < 17) {
                idx = i % garden.Length;
                CreateObj(garden[idx].obj, pointObj, point.vestige[i], world.scale, garden[idx].size); // 药园
            }
        }
        for (int i = 0; i < point.element.Length; i++) {
            int idx = i % 6;
            CreateObj(element[idx].obj, pointObj, point.element[i], world.scale, element[idx].size); // 元素领域
        }
        for (int i = 0; i < point.transmit.Length; i++) {
            CreateObj(transmit[0].obj, pointObj, point.transmit[i], world.scale, transmit[0].size); // 传送阵
        }
        for (int i = 0; i < point.sign.Length; i++) {
            CreateObj(sign[0].obj, pointObj, point.sign[i], world.scale, sign[0].size); // 路标
        }


    }

    void CreateObj(GameObject obj, Transform parent, PointGameObject point, int scale, Vector2 size) {
        CreateObj(obj, parent, point.position, scale, size, point.name);
    }


    void CreateObj(GameObject obj, Transform parent, Vector3 position,int scale, Vector2 size, string name = "") {
        GameObject go = GameObject.Instantiate(obj);
        go.transform.SetParent(parent, false);
        float offset_x = 0;
        float offset_z = 0;
        if (Mathf.Round(size.x) % 2 == 1) {
            offset_x = 0.5f;
        }
        if (Mathf.Round(size.y) % 2 == 1) {
            offset_z = 0.5f;
        }
        go.transform.position = (position + new Vector3(offset_x, 0, offset_z)) * scale;
        TextMesh t = go.GetComponentInChildren<TextMesh>();
        if (t) {
            t.text = name;
        }
    }









}
