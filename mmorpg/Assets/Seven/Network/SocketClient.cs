using UnityEngine;
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Collections;
using System.Collections.Generic;
using SLua;

namespace Seven
{
	public class SocketClient : MonoBehaviour
	{
		public enum Status
		{
			Initial = 1,
			Connecting = 2,
			Establish = 3,
			Closed = 4,
			OnMessage = 5,
			Exception = 102,     //异常消息
			Disconnect = 103     //正常断线
		}
		private TcpClient socket = null;
		public string remoteHost { private set; get; }
		public int remotePort { private set; get; }

		private const int MAX_READ = 8192;
		private volatile Status status = Status.Initial;
		public Status CurStatus { get { return status; } }
		private NetworkStream networkStream;
		private readonly byte[] readBuffer = new byte[MAX_READ];

		public event Action OnConnect;
		public event Action OnDisconnect;
		public event Action OnClose;
		public event Action<Exception> OnError;
		public event Action<ByteBuffer> OnMessage;

		private MemoryStream memStream;
		private BinaryReader reader;

		// Use this for initialization
		public SocketClient()
		{

		}

		public void Close()
		{
			if (status == Status.Closed) return;

			if (networkStream != null)
			{
				networkStream.Close();
			}
			if (socket != null)
			{
				socket.Close();
			}

			if (reader != null)
			{
				reader.Close();
			}
			if (memStream != null)
			{
				memStream.Close();
			}

			status = Status.Closed;
			if (OnClose != null)
				OnClose();
		}

		public void Connect(string host, int port)
		{
			remoteHost = host;
			remotePort = port;

			if (status != Status.Initial && status != Status.Closed) { return; }
			status = Status.Connecting;
			Dns.BeginGetHostAddresses(remoteHost, OnDnsGetHostAddressesComplete, null);
		}

		private void OnDnsGetHostAddressesComplete(IAsyncResult result)
		{
			try
			{
				var ipAddress = Dns.EndGetHostAddresses(result);
				socket = new TcpClient();
				socket.SendTimeout = 1000;
				socket.ReceiveTimeout = 1000;
				socket.NoDelay = true;
				memStream = new MemoryStream();
				reader = new BinaryReader(memStream);
				socket.BeginConnect(ipAddress, remotePort, OnConnectComplete, socket);
			}
			catch (Exception ex)
			{
				if (OnError != null)
					OnError(ex);
				Close();
			}
		}

		protected void OnConnectComplete(IAsyncResult result)
		{
			if (status == Status.Closed) return;

			try
			{
				socket.EndConnect(result);
				networkStream = socket.GetStream();
				networkStream.BeginRead(readBuffer, 0, MAX_READ, OnReadCallBack, readBuffer);

				status = Status.Establish;
				if (OnConnect != null)
					OnConnect();
			}
			catch (Exception ex)
			{
				if (OnError != null)
					OnError(ex);
				Close();
			}
		}

		protected void OnReadCallBack(IAsyncResult result)
		{
			//读取字节流到缓冲区
			int read = networkStream.EndRead(result);
			if (read <= 0)
			{
				//包尺寸有问题，断线处理
				//status = Status.Closed;
				Disconnect("bytesRead < 1");
				return;
			}

			//分析数据包内容，抛给逻辑层
			OnReceive(readBuffer, read);

			//分析完，再次监听服务器发过来的新消息
			//接收缓冲区清零
			Array.Clear(readBuffer, 0, readBuffer.Length);
			networkStream.BeginRead(readBuffer, 0, MAX_READ, OnReadCallBack, readBuffer);
		}

		/// <summary>
		/// 接收到消息
		/// </summary>
		private const int MSG_SIZE_BIT = 2; //包体长度所占字节数
		void OnReceive(byte[] bytes, int length)
		{
			memStream.Seek(0, SeekOrigin.End);
			memStream.Write(bytes, 0, length);
			//Reset to beginning
			memStream.Seek(0, SeekOrigin.Begin);
			while (RemainingBytes() > MSG_SIZE_BIT)
			{
				ushort totalSize = reader.ReadUInt16();
				totalSize = Converter.GetBigEndian(totalSize);
				if (RemainingBytes() >= totalSize)
				{
					MemoryStream ms = new MemoryStream();
					BinaryWriter writer = new BinaryWriter(ms);
					writer.Write(reader.ReadBytes(totalSize));
					ms.Seek(0, SeekOrigin.Begin);
					OnReceivedMessage(ms);
				}
				else
				{
					//Back up the position two bytes
					memStream.Position = memStream.Position - MSG_SIZE_BIT;
					break;
				}
			}
			//Create a new stream with any leftover bytes
			byte[] leftover = reader.ReadBytes((int)RemainingBytes());
			memStream.SetLength(0);     //Clear
			memStream.Write(leftover, 0, leftover.Length);
		}

		/// <summary>
		/// 接收到消息
		/// </summary>
		/// <param name="ms"></param>
		void OnReceivedMessage(MemoryStream ms)
		{
			//BinaryReader r = new BinaryReader(ms);
			//byte[] message = r.ReadBytes((int)(ms.Length - ms.Position));
			//int msglen = message.Length;

			ByteBuffer buffer = new ByteBuffer(ms);
			//int mainId = buffer.ReadShort();
			if (OnMessage != null)
			{
				OnMessage(buffer);
			}
		}

		/// <summary>
		/// 写数据
		/// </summary>
		public void Send(byte[] message)
		{
			if (status != Status.Establish) { return; }

			MemoryStream ms = null;
			using (ms = new MemoryStream())
			{
				ms.Position = 0;
				BinaryWriter writer = new BinaryWriter(ms);
				ushort msglen = (ushort)message.Length;
				//最终数据包为：2字节包长+包体数据
				writer.Write(Converter.GetBigEndian(msglen));
				writer.Write(message);
				writer.Flush();

				byte[] payload = ms.ToArray();
				networkStream.BeginWrite(payload, 0, payload.Length, OnSendCallBack, socket);
			}
		}

		/// <summary>
		/// 向链接写入数据流
		/// </summary>
		void OnSendCallBack(IAsyncResult result)
		{
			try
			{
				networkStream.EndWrite(result);
			}
			catch (Exception ex)
			{
				if (OnError != null)
					OnError(ex);
				Close();
			}
		}

		/// <summary>
		/// 丢失链接
		/// </summary>
		void Disconnect(string msg)
		{
			Close();   //关掉客户端链接

			if (OnDisconnect != null)
			{
				OnDisconnect();
			}

			Debug.LogError("Connection was closed by the server:>" + msg + " Status:>" + status);
		}

		/// <summary>
		/// 打印字节
		/// </summary>
		/// <param name="bytes"></param>
		void PrintBytes()
		{
			string returnStr = string.Empty;
			for (int i = 0; i < readBuffer.Length; i++)
			{
				returnStr += readBuffer[i].ToString("X2");
			}
			Debug.LogError(returnStr);
		}

		/// <summary>
		/// 剩余的字节
		/// </summary>
		private long RemainingBytes()
		{
			return memStream.Length - memStream.Position;
		}

		/// <summary>
		/// 发送消息
		/// </summary>
		public void SendMessage(ByteBuffer buffer)
		{
			Send(buffer.ToBytes());
			buffer.Close();
		}

		void Update()
		{
		}
	}
}