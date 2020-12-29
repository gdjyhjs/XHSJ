using UnityEngine;

public class YellowEvents : MonoSingleton<YellowEvents> {
    public static void SendEvent(string name, object message, bool dontRequireReceiver = false) {
        YellowEvents.instance.SendMessage(name, message, dontRequireReceiver ? SendMessageOptions.DontRequireReceiver : SendMessageOptions.RequireReceiver);
    }

    private void WarningTip(object message) {
        Debug.Log(message);
    }

    private void Error(object message) {
        Debug.Log(message);
    }

    private void OnEnableStatus(object message) {
        if (null != TopInfoManager.instance)
            TopInfoManager.instance.CreateStatus(message);
    }

    private void OnDisableStatus(object message) {
        if (null != TopInfoManager.instance)
            TopInfoManager.instance.RmStatus(message);
    }

    private void OnChatacterDamage(object message) {
        if (null != TopInfoManager.instance)
            TopInfoManager.instance.ChatacterDamage(message);
    }
}