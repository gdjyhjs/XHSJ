using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace UMAWorld {
    /// <summary>
    ///  建筑管理器
    /// </summary>
    public class BuildMgr {
        public Dictionary<string, BuildSchool> allSchool = new Dictionary<string, BuildSchool>();

        public void InitData() {
            allSchool.Clear();
            g.data.buildData.Clear();
            int count = g.conf.schoolBuild.allConfList.Count;
            for (int i = 0; i < count; i++) {
                string schoolName = "宗门" + i;
                g.data.buildData.Add(NewSchool(schoolName).InitBuild(schoolName));
            }
        }

        public void LoadData()
        {
            allSchool.Clear();
            List<SchoolBuildData> data = g.game.data.buildData;
            for (int i = 0; i < data.Count; i++)
            {
                NewSchool(data[i].id).InitData(data[i]);
            }
        }

        public BuildSchool GetBuild(string id) {
            if (allSchool.ContainsKey(id)) {
                return allSchool[id];
            }
            return null;
        }

        private BuildSchool NewSchool(string schoolName) {
            if (allSchool.ContainsKey(schoolName)) {
                return null;
            }
            BuildSchool unit = new BuildSchool();
            allSchool.Add(schoolName, unit);
            return unit;
        }
    }
}