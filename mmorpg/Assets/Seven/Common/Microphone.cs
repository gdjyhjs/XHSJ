using System;
namespace Seven
{
	[SLua.CustomLuaClass]
	public static class Microphone
	{
		public static string[] devices{
			get { return UnityEngine.Microphone.devices; }
		}
		public static UnityEngine.AudioClip Start(string deviceName,bool loop,int lengthSec,int frequency){
			return UnityEngine.Microphone.Start(deviceName,loop,lengthSec,frequency);
		}
		public static void End(string deviceName){
			UnityEngine.Microphone.End(deviceName);
		}
		public static bool IsRecording(string deviceName){
			return UnityEngine.Microphone.IsRecording(deviceName);
		}
		public static int GetPosition(string deviceName){
			return UnityEngine.Microphone.GetPosition (deviceName);
		}
		public static void GetDeviceCaps(string deviceName, out int minFreq, out int maxFreq){
			UnityEngine.Microphone.GetDeviceCaps (deviceName, out minFreq, out maxFreq);
		}
	}
}