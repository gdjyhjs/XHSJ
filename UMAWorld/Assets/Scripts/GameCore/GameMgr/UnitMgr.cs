using System.Collections;
using System.Collections.Generic;
// 单位管理器
public class UnitMgr{
    public string playerUnitID = "";
    public Dictionary<string, UnitBase> allUnit = new Dictionary<string, UnitBase>();

    public UnitBase player { get { return GetUnit(playerUnitID); } }

    public UnitBase GetUnit(string id) {
        if (allUnit.ContainsKey(id)) {
            return allUnit[id];
        }
        foreach (var item in allUnit) {
            UnityEngine.Debug.Log(item.Key + " >> " + item.Value);
        }
        return null;
    }

    public UnitBase NewUnit(string unitName) {
        if (allUnit.ContainsKey(unitName)) {
            return null;
        }
        UnitBase unit = new UnitBase();
        unit.id = unitName;
        allUnit.Add(unitName, unit);
        return unit;
    }
}
