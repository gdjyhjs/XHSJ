using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 角色属性配置数据
/// </summary>
public static class RoleAttrConfigData {
    public static Dictionary<int, RoleAttrConfig[]> dataList;
    static RoleAttrConfigData() {
        var data = Tools.ReadAllText("Config/roleAttr.txt").Split('\n');
        var attrdes = Tools.ReadAllText("Config/roleAttrDes.txt").Split('\n');
        int level = 0;
        Dictionary<int, RoleAttrConfig[]> all = new Dictionary<int, RoleAttrConfig[]>();
        List<RoleAttrConfig> levelData = null;
        int id = 0;
        foreach (var item in data) {
            if (string.IsNullOrWhiteSpace(item) || item.StartsWith("#")) {
                continue;
            }
            var line = item.Trim();
            var tmp = line.Split(':');

            switch (tmp[0]) {
                case "level":
                    if (levelData != null) {
                        all.Add(level, levelData.ToArray());
                    }
                    level = int.Parse(tmp[1]);
                    id = 0;
                    levelData = new List<RoleAttrConfig>();
                    break;
                default:
                    tmp = line.Split(',');
                    int progressMin = 0, progressMax = 0, randMin = 0, randMax = 0;
                    string randattr = tmp[1];
                    RoleAttrShowType typ = (RoleAttrShowType)int.Parse(tmp[2]);
                    string[] randattrlist = randattr.Split('-');
                    if (randattrlist.Length < 1) {
                        continue;
                    } else if (randattrlist.Length == 1) {
                        randMin = int.Parse(randattrlist[0]);
                        randMax = randMin;
                    } else {
                        randMin = int.Parse(randattrlist[0]);
                        randMax = int.Parse(randattrlist[1]);
                    }
                    if (typ == RoleAttrShowType.Progress || typ == RoleAttrShowType.RateProgress) {
                        string progressattr = tmp[3];
                        string[] progressattrlist = progressattr.Split('-');

                        progressMin = int.Parse(progressattrlist[0]);
                        progressMax = int.Parse(progressattrlist[1]);
                    }
                    string des = null;
                    if (id < attrdes.Length) {
                        des = string.Join("\n\n　　", attrdes[id].Split('|'));
                    }
                    if (typ == RoleAttrShowType.Text) {
                        levelData.Add(new RoleAttrConfig(tmp[0], id,randMin, randMax, tmp[3], des));
                    } else {
                        levelData.Add(new RoleAttrConfig() {
                            name = tmp[0], id = id, progressMin = progressMin, progressMax = progressMax
                        , randMin = randMin, randMax = randMax, type = typ, describe = des});
                    }
                    id++;
                    break;
            }
        }
        all.Add(level, levelData.ToArray());
        dataList = all;
    }

    public static RoleAttrConfig[] GetAttrConfig(int level = 1) {
        int get_level = level;
        RoleAttrConfig[] result = null;
        foreach (var item in dataList) {
            if (result == null || (get_level <= item.Key && item.Key <= level)) {
                result = item.Value;
                get_level = item.Key;
            }
        }
        return result;
    }

    public static void GetRandomAttr(out int[] attribute, out int[] max_attribute, out RoleAttrConfig[] attribute_config) {
        attribute_config = GetAttrConfig();
        attribute = new int[attribute_config.Length];
        max_attribute = new int[attribute_config.Length];
        for (int i = 0; i < attribute_config.Length; i++) {
            RoleAttrConfig config = attribute_config[i];
            attribute_config[i] = config;
            int max = Random.Range(config.randMin, config.randMax + 1);
            int min = max;
            if (config.type == RoleAttrShowType.FixedMinMax) {
                // 寿命不随机
                min = config.randMin;
                max = config.randMax;
            }
            attribute[i] = min;
            max_attribute[i] = max;
        }
    }
}

/// <summary>
/// 角色属性配置
/// </summary>
public struct RoleAttrConfig {
    public string name;
    public int id;
    public int progressMin;
    public int progressMax;
    public int randMin;
    public int randMax;
    public string param;
    public RoleAttrShowType type;
    static int[] charm_value;
    static string[] gril_showcharm;
    static string[] boy_showcharm;
    public string describe;

    public RoleAttrConfig(string name, int id, int randMin, int randMax, string param, string describe) {
        type = RoleAttrShowType.Text;
        this.name = name;
        this.id = id;
        this.randMin = randMin;
        this.randMax = randMax;
        this.param = param;
        progressMin = randMin;
        progressMax = randMax;
        this.param = param;
        string[] tmp = param.Split(';');
        int count = tmp.Length;
        charm_value = new int[count];
        gril_showcharm = new string[count];
        boy_showcharm = new string[count];
        this.describe = describe;
        for (int i = 0; i < count; i++) {
            string[] values = tmp[i].Split('-');
            charm_value[i] = int.Parse(values[0]);
            boy_showcharm[i] = values[1];
            if (values.Length == 3) {
                gril_showcharm[i] = values[2];
            } else {
                gril_showcharm[i] = values[1];
            }
        }
    }

    //获取魅力名称
    public static string GetValue(int value, Sex sex) {
        string[] showcharm;
        if (sex == Sex.Girl) {
            showcharm = gril_showcharm;
        } else {
            showcharm = boy_showcharm;
        }
        string show_name = showcharm[0];
        for (int i = 0; i < charm_value.Length; i++) {
            if (value > charm_value[i]) {
                show_name = showcharm[i];
            } else {
                break;
            }
        }
        return show_name;
    }
}

public enum RoleAttrShowType {
    /// <summary>
    /// 默认显示
    /// </summary>
    None,
    /// <summary>
    /// 显示大小值 xx/xxx
    /// </summary>
    MinMax,
    /// 显示进度
    /// </summary>
    Progress,
    /// <summary>
    /// 显示文本 魅力,60,3,[0-99-非人;100-199-可憎;200-299-不扬;300-499-寻常;500-599-出众;600-699-瑾瑜-碧瑶;700-799-龙姿-凤仪;800-899-绝世-出
    /// </summary>
    Text,
    /// <summary>
    /// 数字带百分号 显示进度
    /// </summary>
    RateProgress,
    /// <summary>
    /// 固定显示大小值 xx/xxx
    /// </summary>
    FixedMinMax,
}

public enum Attribute {

    /// <summary>
    /// 寿命
    /// </summary>
    life,

    /// <summary>
    /// 心情
    /// </summary>
    mood,

    /// <summary>
    /// 健康
    /// </summary>
    health,

    /// <summary>
    /// 精力
    /// </summary>
    energy,

    /// <summary>
    /// 体力
    /// </summary>
    hp,

    /// <summary>
    /// 灵力
    /// </summary>
    mp,

    /// <summary>
    /// 念力
    /// </summary>
    spirit,

    /// <summary>
    /// 幸运
    /// </summary>
    lucky,

    /// <summary>
    /// 悟性
    /// </summary>
    intellectuality,

    /// <summary>
    /// 声望
    /// </summary>
    fame,

    /// <summary>
    /// 魅力
    /// </summary>
    charm,

    /// <summary>
    /// 攻击
    /// </summary>
    attack,

    /// <summary>
    /// 防御
    /// </summary>
    defend,

    /// <summary>
    /// 脚力
    /// </summary>
    stamina,

    /// <summary>
    /// 功法抗性
    /// </summary>
    gongfa_resistance,

    /// <summary>
    /// 灵根抗性
    /// </summary>
    linggen_resistance,

    /// <summary>
    /// 会心 暴击
    /// </summary>
    crit,

    /// <summary>
    /// 护心 抗暴
    /// </summary>
    protection,

    /// <summary>
    /// 移速
    /// </summary>
    speed,

    /// <summary>
    /// 暴击倍数
    /// </summary>
    crit_multiple,

    /// <summary>
    /// 抗暴倍数
    /// </summary>
    protection_multiple,

    /// <summary>
    /// 刀法
    /// </summary>
    gongfa_knife,

    /// <summary>
    /// 枪法
    /// </summary>
    gongfa_spear,

    /// <summary>
    /// 剑法
    /// </summary>
    gongfa_sword,

    /// <summary>
    /// 拳法
    /// </summary>
    gongfa_fist,

    /// <summary>
    /// 掌法
    /// </summary>
    gongfa_palm,

    /// <summary>
    /// 指法
    /// </summary>
    gongfa_finger,

    /// <summary>
    /// 火灵根
    /// </summary>
    linggen_fire,

    /// <summary>
    /// 水灵根
    /// </summary>
    linggen_water,

    /// <summary>
    /// 雷灵根
    /// </summary>
    linggen_thunder,

    /// <summary>
    /// 风灵根
    /// </summary>
    linggen_wind,

    /// <summary>
    /// 土灵根
    /// </summary>
    linggen_soil,

    /// <summary>
    /// 木灵根
    /// </summary>
    linggen_wood,

    /// <summary>
    /// 炼丹
    /// </summary>
    alchemy,

    /// <summary>
    /// 炼器
    /// </summary>
    forge,

    /// <summary>
    /// 风水
    /// </summary>
    geomantic,

    /// <summary>
    /// 画符
    /// </summary>
    juju,

    /// <summary>
    /// 药材
    /// </summary>
    medicinal,

    /// <summary>
    /// 矿材
    /// </summary>
    minerals,
    /// <summary>
    /// 正道
    /// </summary>
    zhengdao,

    /// <summary>
    /// 魔道
    /// </summary>
    modao,
}