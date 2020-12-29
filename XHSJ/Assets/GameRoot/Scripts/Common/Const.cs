using UnityEngine;

public static class YellowConst {
    // 协程对象
    public static WaitForSeconds waitOneSecond = new WaitForSeconds(1);

}

public static class YellowEventName {
    // 派发事件名称
    public static string warningTip = "WarningTip";
    public static string error = "Error";
    public static string enableStatus = "OnEnableStatus";
    public static string disableStatus = "OnDisableStatus";
    public static string chatacterDamage = "OnChatacterDamage";
}

public static class YellowConstText {
    // 提示文本
    public static string notKill = "缺少技能！";
    public static string notSp = "魂力不足！";
    public static string notCool = "技能冷却中！";
}

public static class YellowErrorText {
    // 报错文本
    public static string notSkillType = "技能类型未实现！";
    public static string notHitFxPos = "缺少特效挂载点！";
    public static string errorSkilldamageInterval = "技能间隔时间必须大于0！";
}