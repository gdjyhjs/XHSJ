using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
///  建筑管理器
/// </summary>
public class BuildMgr {
    public Dictionary<string, BuildBase> allBuild = new Dictionary<string, BuildBase>();

    public void InitData() {
        int count = g.conf.schoolBuild.allConfList.Count;
        for (int i = 0; i < count; i++) {
            NewUnit<BuildSchool>("宗门" + i);
        }
    }

    public BuildBase GetUnit(string id) {
        if (allBuild.ContainsKey(id)) {
            return allBuild[id];
        }
        return null;
    }
    
    public T NewUnit<T>(string buildName) where T : BuildBase, new() {
        if (allBuild.ContainsKey(buildName)) {
            return null;
        }
        T unit = new T();
        unit.id = buildName;
        allBuild.Add(buildName, unit);
        return unit;
    }
}
