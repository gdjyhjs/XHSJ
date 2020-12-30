using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using gcloud_voice;
using SLua;
using System.IO;
using Hugula.Utils;

namespace Seven{
	[CustomLuaClass]
	public class GVoiceComponent : MonoBehaviour {

		#region 私有变量
		private IGCloudVoice m_voiceengine = null;	//接入腾讯GVoice
		private byte[] m_ShareFileID = null;	//
		private bool bIsStart = false;	//
		private bool bIsGetAuthKey = false;	//

		private string m_recordpath;//保存录音路径
		private string m_downloadpath;//下载录音的路径
		private string m_downloadfolder;//下载文件夹
		private string m_fileid="";
		#endregion

		#region lua方法
		/// <summary>
		/// 语音接入结果
		/// </summary>
		public LuaFunction onApplyMessagekeyCompleteFn{get;set;}
		/// <summary>
		/// 语音上传结果
		/// </summary>
		public LuaFunction onUploadReccordFileCompleteFn{get;set;}
		/// <summary>
		/// 语音下载结果
		/// </summary>
		public LuaFunction onDownloadRecordFileCompleteFn{get;set;}
		/// <summary>
		/// 语音播放完成
		/// </summary>
		public LuaFunction onPlayRecordFilCompleteFn{get;set;}
		/// <summary>
		/// 语音转文字
		/// </summary>
		public LuaFunction onSpeechToTextFn{get;set;}
		#endregion

		#region 常量
		public string appID = "1383059197";
		public string appKey = "36c38834e4f8c2db482cbdc76672c229";
		public string openID = "20170613";
		#endregion

		#region 初始化
		private void Init(){
			if (m_voiceengine == null) {
				m_voiceengine = GCloudVoice.GetEngine();
				m_voiceengine.SetAppInfo(appID,appKey,openID);
				m_voiceengine.Init();//初始化接入
				m_voiceengine.SetMode (GCloudVoiceMode.Translation); //这种模式是 离线消息+语音转文字
			}
			if (!bIsStart) {
				bIsStart = true;
				//请求语音消息回调
				m_voiceengine.OnApplyMessageKeyComplete += OnApplyMessageKeyCompleteR; 
				//上传语音文件后回调
				m_voiceengine.OnUploadReccordFileComplete += OnUploadReccordFileCompleteR;
				//下载语音文件后回调
				m_voiceengine.OnDownloadRecordFileComplete += OnDownloadRecordFileCompleteR;
				//播放语音完成后回调
				m_voiceengine.OnPlayRecordFilComplete += OnPlayRecordFilCompleteR;
				//语音转文字完成后回调
				m_voiceengine.OnSpeechToText += OnSpeechToTextR; 
			}
			//录音文件存储的地址路径，路径中需要"/"作分隔，不能用"\"
			m_downloadfolder = GetReadWritePath();
			m_recordpath = m_downloadfolder + "recording.dat";
			m_downloadpath =  m_downloadfolder + "download.dat";
		}

		private string GetReadWritePath(){
			string path = Application.persistentDataPath;
			#if UNITY_STANDALONE_WIN || UNITY_EDITOR
			path = path.Substring(0,path.LastIndexOf('/')+1)+"qishaluyin";
			#else
			path = CUtils.PathCombine(path, "qishaluyin/");
			#endif
			if (!Directory.Exists (path))
				Directory.CreateDirectory (path);
			return path;
		}

		private void Update () {
			//			print ("语音系统"+m_voiceengine);
			if (m_voiceengine != null) {
				m_voiceengine.Poll();
			}
		}
		[DoNotToLua]
		public void OnApplicationPause(bool pauseStatus)
		{
			if (pauseStatus)
			{
				if (m_voiceengine == null)
				{
					return;
				}
				m_voiceengine.Pause();
			}
			else
			{
				if (m_voiceengine == null)
				{
					return;
				}
				m_voiceengine.Resume();
			}
		}
		#endregion

		#region 录音接口
		//在语音消息的模式下，可以限制最大语音消息的长度，目前默认是2分钟，最大不超过2分钟。
		public int SetMaxMessageLength(int msTime){
			return m_voiceengine.SetMaxMessageLength (msTime);
		}

		//注册语音
		public int RegisterGVoice(){
			Init ();
			if (!bIsGetAuthKey) {
				//msTimeout	itn	超时时间，单位毫秒
				int ret = m_voiceengine.ApplyMessageKey(6000);
				if (ret != 0)
					Debug.LogError ("语音系统出错"+ret);
				return ret;
			}else{
				return 404;
			}
		}

		//开始录音 ret=0表示成功
		public int Click_btnStartRecord(){
			int ret = m_voiceengine.StartRecording (m_recordpath);
			if (ret != 0)
				Debug.LogError ("语音系统出错"+ret+" "+m_recordpath);
			return ret;
		}

		//停止录音 ret=0表示成功
		public int Click_btnStopRecord()
		{		
			int ret = m_voiceengine.StopRecording ();
			if (ret != 0)
				Debug.LogError ("语音系统出错"+ret+" "+m_recordpath);
			return ret;
		}

		//上传录音文件 ret=0表示成功
		public int Click_btnUploadFile()
		{
			int ret = m_voiceengine.UploadRecordedFile (m_recordpath, 60000);
			if (ret != 0)
				Debug.LogError ("语音系统出错"+ret+" "+m_recordpath);
			return ret;
		}

		//下载录音文件 ret=0表示成功
		public int Click_btnDownloadFile()
		{
			int ret = m_voiceengine.DownloadRecordedFile (m_fileid, m_downloadpath, 60000);
			if (ret != 0)
				Debug.LogError ("语音系统出错"+ret+" "+m_downloadpath);
			return ret;
		}
		//下载录音文件 ret=0表示成功
		public int Click_btnDownloadFile(string m_fileid,string m_downloadpath)
		{
			m_downloadpath = m_downloadfolder + m_downloadpath+".dat";
			int ret = m_voiceengine.DownloadRecordedFile (m_fileid, m_downloadpath, 60000);
			if (ret != 0)
				Debug.LogError ("语音系统出错"+ret+" "+m_downloadpath);
			return ret;
		}

		//播放录音 ret=0表示成功
		public int Click_btnPlayReocrdFile()
		{
			int err;
			if (m_ShareFileID == null) {
				err = m_voiceengine.PlayRecordedFile(m_recordpath);
				if (err != 0)
					Debug.LogError ("语音系统出错"+err+" "+m_recordpath);
				return err;
			}
			err = m_voiceengine.PlayRecordedFile(m_downloadpath);
			if (err != 0)
				Debug.LogError ("语音系统出错"+err+" "+m_downloadpath);
			return err;
		}
		//播放录音 ret=0表示成功
		public int Click_btnPlayReocrdFile(string path)
		{
			int err;
			err = m_voiceengine.PlayRecordedFile(path);
			if (err != 0)
				Debug.LogError ("语音系统出错"+err+" "+path);
			return err;
		}


		//	停止播放 ret=0表示成功
		public int Click_btnStopPlayRecordFile()
		{
			int ret = m_voiceengine.StopPlayFile ();
			if (ret != 0)
				Debug.LogError ("语音系统出错"+ret);
			return ret;
		}

		//声音转文字 ret=0表示成功
		public int Click_btnSpeechToText()
		{
			//	第2参数	language	int	需要的文字类型，默认0中文
			int ret = m_voiceengine.SpeechToText(m_fileid,0,6000);
			if (ret != 0)
				Debug.LogError ("语音系统出错"+ret);
			return ret;
		}
		//声音转文字 ret=0表示成功
		public int Click_btnSpeechToText(string m_fileid)
		{
			//	第2参数	language	int	需要的文字类型，默认0中文
			int ret = m_voiceengine.SpeechToText(m_fileid,0,6000);
			if (ret != 0)
				Debug.LogError ("语音系统出错"+ret);
			return ret;
		}
		//获取录音长度
		public float Click_getVoiceLength(string path){
			int [] bytes = new int[1];
			bytes [0] = 0;
			float [] seconds = new float[1];
			seconds [0] = 0;
			m_voiceengine.GetFileParam (path, bytes, seconds);
			return seconds [0];
		}
		//获取录音长度
		public float Click_getVoiceLength(){
			int [] bytes = new int[1];
			bytes [0] = 0;
			float [] seconds = new float[1];
			seconds [0] = 0;
			m_voiceengine.GetFileParam (m_recordpath, bytes, seconds);
			return seconds [0];
		}
		//获取录音声音波动
		public int get_voice_sound_wave{
			get{ return m_voiceengine.GetMicLevel(); }
		}
		//设置语音音量
		public void set_sound_volume(int volume){
			m_voiceengine.SetSpeakerVolume (volume);
		}
		#endregion

		#region 回调接口
		/// <summary>
		/// 请求语音消息Key回调
		/// </summary>
		/// <param name="code">GCloudVoiceCompleteCode	参见GCloudVoiceCompleteCode定义</param>
		private void OnApplyMessageKeyCompleteR(IGCloudVoice.GCloudVoiceCompleteCode code){
			if (code == IGCloudVoice.GCloudVoiceCompleteCode.GV_ON_MESSAGE_KEY_APPLIED_SUCC) {
				bIsGetAuthKey = true;
			} else {
				Debug.LogError ("语音系统出错"+code);
				Invoke ("RegisterGVoice", 10);
			}
			if (onApplyMessagekeyCompleteFn != null)
				onApplyMessagekeyCompleteFn.call (code);
		}

		/// <summary>
		/// 上传语音文件后的结果
		/// </summary>
		/// <param name="code">GCloudVoiceCompleteCode	参见GCloudVoiceCompleteCode定义</param>
		/// <param name="filepath">上传的文件路径</param>
		/// <param name="fileid">文件的id</param>
		private void OnUploadReccordFileCompleteR(IGCloudVoice.GCloudVoiceCompleteCode code, string filepath, string fileid){
			if (code == IGCloudVoice.GCloudVoiceCompleteCode.GV_ON_UPLOAD_RECORD_DONE) {
				if(onUploadReccordFileCompleteFn!=null)
					onUploadReccordFileCompleteFn.call(0, filepath,fileid);
			} else {
				Debug.LogError ("语音系统出错"+code+" "+filepath+" "+fileid);
				if(onUploadReccordFileCompleteFn!=null)
					onUploadReccordFileCompleteFn.call((int)code);
			}
		}

		/// <summary>
		/// 下载语音文件后的结果
		/// </summary>
		/// <param name="code">GCloudVoiceCompleteCode	参见GCloudVoiceCompleteCode定义</param>
		/// <param name="filepath">下载的路径</param>
		/// <param name="fileid">文件的id</param>
		private void OnDownloadRecordFileCompleteR(IGCloudVoice.GCloudVoiceCompleteCode code, string filepath, string fileid){
			if (code == IGCloudVoice.GCloudVoiceCompleteCode.GV_ON_DOWNLOAD_RECORD_DONE) {
				if(onDownloadRecordFileCompleteFn!=null)
					onDownloadRecordFileCompleteFn.call(0, filepath,fileid);
			} else {
				Debug.LogError ("语音系统出错"+code+" "+filepath+" "+fileid);
				if(onDownloadRecordFileCompleteFn!=null)
					onDownloadRecordFileCompleteFn.call((int)code);
			}
		}

		/// <summary>
		/// 播放完成后
		/// </summary>
		/// <param name="code">GCloudVoiceCompleteCode	参见GCloudVoiceCompleteCode定义</param>
		/// <param name="filepath">播放的文件路径</param>
		private void OnPlayRecordFilCompleteR(IGCloudVoice.GCloudVoiceCompleteCode code, string filepath){
			if (code == IGCloudVoice.GCloudVoiceCompleteCode.GV_ON_PLAYFILE_DONE) {
				if(onPlayRecordFilCompleteFn!=null)
					onPlayRecordFilCompleteFn.call(0, filepath);
			} else {
				Debug.LogError ("语音系统出错"+code+" "+filepath);
				if(onPlayRecordFilCompleteFn!=null)
					onPlayRecordFilCompleteFn.call((int)code);
			}
		}

		/// <summary>
		/// 语音转文字的结果
		/// </summary>
		/// <param name="code">GCloudVoiceCompleteCode	参见GCloudVoiceCompleteCode定义</param>
		/// <param name="fileID">需要翻译的文件id</param>
		/// <param name="result">翻译的文字结果</param>
		private void OnSpeechToTextR(IGCloudVoice.GCloudVoiceCompleteCode code, string fileID, string result){
			if (code == IGCloudVoice.GCloudVoiceCompleteCode.GV_ON_STT_SUCC) {
				if(onSpeechToTextFn!=null)
					onSpeechToTextFn.call(0, fileID,result);
			} else {
				if(onSpeechToTextFn!=null)
					onSpeechToTextFn.call((int)code);
				Debug.LogError ("语音系统出错"+code);
			}
		}
		#endregion

	}
}