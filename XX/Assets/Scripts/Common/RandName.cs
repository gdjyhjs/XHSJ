using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class RandName {

    static string[] boyName;
    static string[] grilName;
    static string[] surnName;
    static int[] surnRate;
    static int maxrate;
    static RandName() {
        boyName = Tools.ReadAllText("Config/boyname.txt").Split('\n');
        grilName = Tools.ReadAllText("Config/grilname.txt").Split('\n');

        string[] surn_data = Tools.ReadAllText("Config/surn.txt").Split('\n');
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

    public static void GetRandName(ref Sex sex, out string surn, out string name, string defSurn = null) {
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
}

public enum Sex {
    Both,
    Girl,
    Boy,
}