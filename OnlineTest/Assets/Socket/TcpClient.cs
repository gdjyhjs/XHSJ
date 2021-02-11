using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using UnityEngine;
namespace GameSocket {
    public class ServiceState {
        public Socket serviceSocket;
        public byte[] buffer;
        public static int bufsize = 1024;
    }

    public class TcpClient {
        Socket c_socket;
        Thread th_socket;
        int ConnectionResult;
        string ip;
        int port;
        public TcpClient(string ip, int port) {
            this.ip = ip;
            this.port = port;
        }

        /// <summary>
        /// 连接Socket
        /// </summary>
        public void Start() {
            try {
                IPEndPoint endPoint = new IPEndPoint(IPAddress.Parse(ip), port);
                c_socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                c_socket.BeginConnect(endPoint, new AsyncCallback(Connect), c_socket);//链接服务端
                th_socket = new Thread(MonitorSocker);//监听线程
                th_socket.IsBackground = true;
                th_socket.Start();
            } catch (SocketException ex) {
                Debug.Log("error ex=" + ex.Message + " " + ex.StackTrace);
            }
        }

        public void Close() {
            try {
                c_socket.Shutdown(SocketShutdown.Both);
            } catch (Exception e) {
                Debug.LogError(e.Message);
            }
            try {
                c_socket.Close();
            } catch (Exception e) {
                Debug.LogError(e.Message);
            }
        }

        //监听Socket
        void MonitorSocker() {
            while (true) {
                if (ConnectionResult != 0 && ConnectionResult != -2)//通过错误码判断
                {
                    Start();
                }
                Thread.Sleep(1000);
            }
        }

        /// <summary>
        /// 连接服务端
        /// </summary>
        /// <param name="ar"></param>
        private void Connect(IAsyncResult ar) {
            try {
                ServiceState obj = new ServiceState();
                Socket client = ar.AsyncState as Socket;
                obj.serviceSocket = client;
                //获取服务端信息
                client.EndConnect(ar);
                //接收连接Socket数据 
                client.BeginReceive(obj.buffer, 0, ServiceState.bufsize, SocketFlags.None, new AsyncCallback(ReadCallback), obj);
            } catch (SocketException ex) {
                ConnectionResult = ex.ErrorCode;
                Debug.Log(ex.Message + " " + ex.StackTrace);
            }
        }


        /// <summary>
        /// 数据接收
        /// </summary>
        /// <param name="ar">请求的Socket</param>
        private void ReadCallback(IAsyncResult ar) {
            //获取并保存
            ClientState obj = ar.AsyncState as ClientState;
            Socket c_socket = obj.clientSocket;
            int bytes = c_socket.EndReceive(ar);
            //接收完成 重新给出buffer接收
            obj.buffer = new byte[ClientState.bufsize];
            c_socket.BeginReceive(obj.buffer, 0, ClientState.bufsize, 0, new AsyncCallback(ReadCallback), obj);
        }
    }
}