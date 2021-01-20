using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class TerrainTools : Editor
{
    [MenuItem("GameObject/MyMenu/Test", priority = 0)]
    public static void Test() {
        UnityEngine.Object[] gameObjects = Selection.objects;
        for (int i = 0; i < gameObjects.Length; i++) {
            Terrain terrain = gameObjects[i] as Terrain;
            if (terrain) {

            }
        }
    }
    private static void TerrainFunc(Terrain terrain) {
        TerrainData terrainData = terrain.terrainData;
        Vector3 terrainPos = terrain.transform.position;


    }
}
