// Copyright (c) 2015 hugula
// direct https://github.com/tenvick/hugula
//
using UnityEngine;
using System.Collections;
using System.Net.Sockets;
using System;
using System.IO;
using System.Threading;
using SLua;

namespace Hugula.Net
{

    /// <summary>
    /// 网络连接类
    /// </summary>
    [SLua.CustomLuaClass]
    public class LNet : MonoBehaviour, IDisposable
    {
        TcpClient client;
        NetworkStream stream;
        BinaryReader breader;
        DateTime begin;
        private Thread receiveThread;
        private bool isbegin = false;
        private bool callConnectioneFun = false;
        private bool callTimeOutFun = false;
        private bool isConnectioned = false;
        private float lastSeconds = 0;
        public bool isConnectCall { private set; get; }
        public float pingDelay = 120;
        public int timeoutMiliSecond = 4000;

        void Awake()
        {
            queue = ArrayList.Synchronized(new ArrayList());
            sendQueue = ArrayList.Synchronized(new ArrayList());
        }

        void Update()
        {
			//一帧处理10个消息
			int count = 0;
			while (count < 10) {
				if (queue != null && queue.Count > 0) {
					Msg msg = (Msg)queue [0];
					queue.RemoveAt (0);

					if (onMessageReceiveFn != null) {
						try {
							onMessageReceiveFn.call (msg);
						} catch (Exception e) {
							SendErro (e.Message, e.StackTrace);
							Debug.LogError (e);
						}
					}
				} else {
					break;
				}
				count++;
			}

            if (isbegin)
            {
                //			Debug.Log(" Connected "+this.client.Connected);
                if (client.Connected == false && isConnectioned == false)
                {
                    TimeSpan ts = DateTime.Now - begin;

                    if (onConnectionTimeoutFn != null && ts.TotalMilliseconds > this.timeoutMiliSecond && !callTimeOutFun)
                    {
                        isbegin = false;
                        callConnectioneFun = false;
                        callTimeOutFun = true;
                        onConnectionTimeoutFn.call(this);
                    }
                }
                else if (client.Connected == false && isConnectioned)
                {
                    isbegin = false;
                    callConnectioneFun = false;
                    callTimeOutFun = false;
                    //if(receiveThread!=null)receiveThread.Abort();
                    if (onConnectionCloseFn != null)
                        onConnectionCloseFn.call(this);

                }

                if (client.Connected && callConnectioneFun)
                {
                    callConnectioneFun = false;
                    if (onConnectionFn != null)
                        onConnectionFn.call(this);
                }


                if (client.Connected)
                {
                    float dt = Time.time - lastSeconds;
                    if (dt > pingDelay && onIntervalFn != null)
                    {
                        onIntervalFn.call(this);
                        lastSeconds = Time.time;
                    }

                    if (this.sendQueue.Count > 0)
                    {
						var msg = sendQueue[0];
                        sendQueue.RemoveAt(0);
						Send((byte[])msg);
                    }
                }
            }
        }

        void OnDestroy()
        {
            Dispose();
            //if (_main == this) _main = null;
        }

        public void Connect(string host, int port)
        {
            this.Host = host;
            this.Port = port;
            begin = DateTime.Now;
            callConnectioneFun = false;
            callTimeOutFun = false;
            isConnectioned = false;
            isbegin = true;
            isConnectCall = true;
            Debug.LogFormat("<color=green>begin connect:{0} :{1} time:{2}</color>", host, port, begin.ToString());
            if (client != null)
                client.Close();
            client = new TcpClient();
            client.BeginConnect(host, port, new AsyncCallback(OnConnected), client);

        }

        public void ReConnect()
        {
            Connect(Host, Port);
            if (onReConnectFn != null)
                onReConnectFn.call(this);
        }

        public void Close()
        {
            if (receiveThread != null) receiveThread.Abort();
            if (client != null) client.Close();
            if (breader != null) breader.Close();
        }

		private void Send(byte[] bytes)
        {
            if (client.Connected)
                stream.BeginWrite(bytes, 0, bytes.Length, new AsyncCallback(SendCallback), stream);
            //		else
            //			this.reConnect();
        }

        public bool IsConnected
        {
            get
            {
                return client == null ? false : client.Connected;
            }
        }

		public void SendMsg(byte[] msg)
        {
			if (client != null && client.Connected && isConnectioned)
                Send(msg);
            else
                sendQueue.Add(msg);
        }

		private const int MSG_SIZE_BIT = 2; //包体长度所占字节数
        public void Receive()
        {
            ushort len = 0;
            byte[] buffer = null;
            while (client.Connected)
            {
				int count = 0;
				while (client.Available > MSG_SIZE_BIT && count < 10) //一帧最多取10条消息
				{
					byte[] header = new byte[MSG_SIZE_BIT];
					stream.Read(header, 0, MSG_SIZE_BIT);
					Array.Reverse(header);
					len = BitConverter.ToUInt16(header, 0);
					buffer = new byte[len];

					stream.Read(buffer, 0, len);
					Msg msg = new Msg(buffer);
					queue.Add(msg);
					count++;
				}

                Thread.Sleep(16);
            }

        }

        #region protected

        #region  memeber

        public string Host
        {
            get;
            private set;
        }

        public int Port
        {
            get;
            private set;
        }

        private ArrayList queue;
        private ArrayList sendQueue;
        #endregion

        private void SendCallback(IAsyncResult rs)
        {
            try
            {
                client.Client.EndSend(rs);
            }
            catch (Exception e)
            {
                Debug.Log(e.ToString());
            }
        }

        private void OnConnected(IAsyncResult rs)
        {
            TimeSpan ts = DateTime.Now - begin;
            stream = client.GetStream();
            breader = new BinaryReader(stream);
            Debug.LogFormat("<color=green>Connection success {0} cast {1} milliseconds</color>", Host, ts.TotalMilliseconds);
            callConnectioneFun = true;
            isConnectioned = true;
            if (receiveThread != null)
                receiveThread.Abort();
            receiveThread = new Thread(new ThreadStart(Receive));
            receiveThread.Start();
        }

        #endregion

        public void SendErro(string type, string desc)
        {
            if (onAppErrorFn != null)
            {
                onAppErrorFn.call(type, desc);
            }
            else
            {
                //var error = new Msg();
                //error.Type = 233;
                //error.WriteString(type);
                //error.WriteString(desc);
                //this.Send(error);
            }
        }

        public void Dispose()
        {
            this.Close();
            isbegin = false;
            client = null;
            breader = null;
            onAppErrorFn = null;
            onConnectionCloseFn = null;
            onConnectionFn = null;
            onMessageReceiveFn = null;
            onConnectionTimeoutFn = null;
            onReConnectFn = null;
            onIntervalFn = null;
        }

        #region lua Event
        public LuaFunction onAppErrorFn;

        public LuaFunction onConnectionCloseFn;

        public LuaFunction onConnectionFn;

        public LuaFunction onMessageReceiveFn;

        public LuaFunction onConnectionTimeoutFn;

        public LuaFunction onReConnectFn;

        public LuaFunction onIntervalFn;
        #endregion

        private static GameObject lNetObj;
        private static LNet _main;

        public static LNet main
        {
            get
            {
                if (_main == null)
                {
                    if (lNetObj == null) lNetObj = new GameObject("LNet");
                    _main = lNetObj.AddComponent<LNet>();
                }
                return _main;
            }
        }

        public static LNet New()
        {
            if (lNetObj == null) lNetObj = new GameObject("LNet");
            var cnet = lNetObj.AddComponent<LNet>();
            if (_main == null) _main = cnet;
            return cnet;
        }

    }
}