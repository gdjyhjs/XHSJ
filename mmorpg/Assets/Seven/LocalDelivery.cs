using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SLua;

#if UNITY_IPHONE
using NotificationServices = UnityEngine.iOS.NotificationServices;
using NotificationType = UnityEngine.iOS.NotificationType;
#endif
namespace Seven.Message
{
	[SLua.CustomLuaClass]

	public class LocalDelivery : MonoBehaviour {
	//本地推送
		public static void NotificationMessage(string message,int hour ,bool isRepeatDay)
		{
			int year = System.DateTime.Now.Year;
			int month = System.DateTime.Now.Month;
			int day= System.DateTime.Now.Day;
			System.DateTime newDate = new System.DateTime(year,month,day,hour,0,0);
			NotificationMessage(message,newDate,isRepeatDay);
		}
	//本地推送 你可以传入一个固定的推送时间
		public static void NotificationMessage(string message,System.DateTime newDate,bool isRepeatDay)
		{
		#if UNITY_IPHONE
		//推送时间需要大于当前时间
			if(newDate > System.DateTime.Now)
			{
				UnityEngine.iOS.LocalNotification localNotification = new UnityEngine.iOS.LocalNotification();
				localNotification.fireDate =newDate;	
				localNotification.alertBody = message;
				localNotification.applicationIconBadgeNumber = 1;
				localNotification.hasAction = true;
				localNotification.alertAction = "七煞";
				if(isRepeatDay)
				{
				//是否每天定期循环
					localNotification.repeatCalendar = UnityEngine.iOS.CalendarIdentifier.ChineseCalendar;
					localNotification.repeatInterval = UnityEngine.iOS.CalendarUnit.Day;
				}
				localNotification.soundName = UnityEngine.iOS.LocalNotification.defaultSoundName;
				UnityEngine.iOS.NotificationServices.ScheduleLocalNotification(localNotification);
			}
		#endif
		#if UNITY_ANDROID
			// if (newDate > System.DateTime.Now) 
			// {
			// 	LocalNotification.SendNotification(1,10,"七煞",message,new Color32(0xff, 0x44, 0x44, 255));
			// 	if (System.DateTime.Now.Hour >= 12) {
			// 	System.DateTime dataTimeNextNotify = new System.DateTime(
			// 		long delay = 24 * 60 * 60 - ((System.DateTime.Now.Hour - 12)* 60 * 60 + System.DateTime.Now.Minute * 60 + System.DateTime.Now.Second);
			// 		LocalNotification.SendRepeatingNotification(2,delay, 24 * 60 * 60,"七煞",message,new Color32(0xff, 0x44, 0x44, 255));
			// 	}
			// 	else 
			// 	{
			// 		long delay = (12 - System.DateTime.Now.Hour)* 60 * 60 - System.DateTime.Now.Minute * 60 - System.DateTime.Now.Second;
			// 		LocalNotification.SendRepeatingNotification(2,delay,24 * 60 * 60 ,"七煞","每天中午12点推送",new Color32(0xff, 0x44, 0x44, 255));	
			// 	}
			// }
		#endif
		}

		void Awake()
		{
		#if UNITY_IPHONE
			UnityEngine.iOS.NotificationServices.RegisterForNotifications (
				NotificationType.Alert |
				NotificationType.Badge |
				NotificationType.Sound);
		#endif
		//第一次进入游戏的时候清空，有可能用户自己把游戏冲后台杀死，这里强制清空
			CleanNotification();
		}
		public LuaFunction messageFn;
		void OnApplicationPause(bool paused)
		{
		//程序进入后台时
			if(paused)
			{
			// //10秒后发送
			// 	NotificationMessage("这是notificationtest的推送正文信息",System.DateTime.Now.AddSeconds(10),false);
			// //每天中午12点推送
			// 	NotificationMessage("每天中午12点推送",12,true);
				if (messageFn != null){
					messageFn.call();
				}
						
			}
			else
			{
			//程序从后台进入前台时
				CleanNotification();
			}
		}

	//清空所有本地消息
		void CleanNotification()
		{
		#if UNITY_IPHONE
			UnityEngine.iOS.LocalNotification l = new UnityEngine.iOS.LocalNotification (); 
			l.applicationIconBadgeNumber = -1; 
			UnityEngine.iOS.NotificationServices.PresentLocalNotificationNow (l); 
			UnityEngine.iOS.NotificationServices.CancelAllLocalNotifications (); 
			UnityEngine.iOS.NotificationServices.ClearLocalNotifications (); 
		#endif
		#if UNITY_ANDROID
			//LocalNotification.CancelNotification(1);
			//LocalNotification.CancelNotification(2);
		#endif
		}
	}
}