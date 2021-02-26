using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class RandName {

    static string[] boyName;
    static string[] grilName;
    static string[] surnName;
    static int[] surnRate;
    static int maxrate;
    static string[] cityName;
    static string[] popeName;
    static string[] popeSuffix;
    static RandName() {
        InitRoleName();
        InitCityName();
    }

    static void InitRoleName() {
        boyName = Tools.ReadAllText("Config/boyname.txt").Split('\n');
        grilName = Tools.ReadAllText("Config/grilname.txt").Split('\n');
        string[] surn_data = Tools.ReadAllText("Config/surn.txt").Split('\n');
#if UNITY_EDITOR
        string[] tmp = Tools.CheckSame(boyName);
        if (tmp != boyName) {
            Tools.WriteAllText("Config/boyname.txt", string.Join("\n", tmp));
        }
        tmp =Tools.CheckSame(grilName);
        if (tmp != grilName) {
            Tools.WriteAllText("Config/grilname.txt", string.Join("\n", tmp));
        }
        tmp =Tools.CheckSame(surn_data);
        if (tmp != surn_data) {
            Tools.WriteAllText("Config/surn.txt", string.Join("\n", tmp));
        }
#endif

        List<string> surn_name = new List<string>();
        List<int> rate_name = new List<int>();
        maxrate = 0;
        foreach (var item in surn_data) {
            try {
                if (string.IsNullOrEmpty(item)) {
                    continue;
                }
                var data = item.Split(' ');
                if (data.Length != 2) {
                    continue;
                }
                var surn = data[0];
                var rate = int.Parse(data[1]);

                if (string.IsNullOrEmpty(surn) || rate <= 0) {
                    continue;
                }
                maxrate += rate;
                surn_name.Add(surn);
                rate_name.Add(rate);
            } catch (System.Exception) {
                continue;
            }
        }
        surnName = surn_name.ToArray();
        surnRate = rate_name.ToArray();
    }

    static void InitCityName() {
        cityName = Tools.ReadAllText("Config/cityname.txt").Split('\n');
        popeName = Tools.ReadAllText("Config/popename.txt").Split('\n');
        popeSuffix = Tools.ReadAllText("Config/popesuffix.txt").Split('\n');
#if UNITY_EDITOR
        string[] tmp = Tools.CheckSame(cityName);
        if (tmp != cityName) {
            Tools.WriteAllText("Config/cityName.txt", string.Join("\n", tmp));
        }
        tmp = Tools.CheckSame(popeName);
        if (tmp != popeName) {
            Tools.WriteAllText("Config/popename.txt", string.Join("\n", tmp));
        }
        tmp = Tools.CheckSame(popeSuffix);
        if (tmp != popeSuffix) {
            Tools.WriteAllText("Config/popesuffix.txt", string.Join("\n", tmp));
        }
#endif
    }

    public static void GetRandRoleName(ref Sex sex, out string surn, out string name, string defSurn = null) {
        switch (sex) {
            case Sex.Girl:
                break;
            case Sex.Boy:
                break;
            default:
                sex = Random.Range(0, 2) == 1 ? Sex.Girl : Sex.Boy;
                break;
        }
        if (sex == Sex.Boy) {
            name = boyName[Random.Range(0, boyName.Length)];
        } else {
            name = grilName[Random.Range(0, grilName.Length)];
        }

        surn = surnName[0];
        if (defSurn == null) {
            var rate = Random.Range(0, maxrate);
            for (int i = 0; i < surnRate.Length; i++) {
                if (rate < surnRate[i]) {
                    if (i >= surnName.Length) {
                        break;
                    }
                    surn = surnName[i];
                    break;
                }
            }
        } else {
            surn = defSurn;
        }
    }

    public static string GetRandCityName() {
        return cityName[Random.Range(0, cityName.Length)];
    }

    public static string GetRandPopeName() {
        return popeName[Random.Range(0, popeName.Length)] + popeSuffix[Random.Range(0, popeSuffix.Length)];
    }
}
