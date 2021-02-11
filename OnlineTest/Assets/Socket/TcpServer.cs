using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Net.Sockets;
using System.Net;
using System;
using System.Threading;
namespace GameSocket {
    public class ClientState {
        public Socket clientSocket;
        public byte[] buffer;
        public static int bufsize = 1024;
    }

    public class TcpServer {
        Socket s_socket;
        Thread th_socket;
        public TcpServer(string ip, int port) {
            // 创建一个socket
            s_socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            // 绑定IP地址和端口
            s_socket.Bind(new IPEndPoint(IPAddress.Parse(ip), port));
            // 开始监听
            Debug.Log("服务器开始监听");
            s_socket.Listen(100); // 设置最大的连接数

            th_socket = new Thread(() => { s_socket.BeginAccept(new AsyncCallback(Accept), s_socket); });//监听线程
            th_socket.IsBackground = true;
            th_socket.Start();
        }

        public void Close() {
            try {
                s_socket.Shutdown(SocketShutdown.Both);
            } catch (Exception e) {
                Debug.LogError(e.Message);
            }
            try {
                s_socket.Close();
            } catch (Exception e) {
                Debug.LogError(e.Message);
            }
        }

        /// <summary>
        /// 异步连接回调 获取请求Socket
        /// </summary>
        /// <param name="ar">请求的Socket</param>
        private void Accept(IAsyncResult ar) {
            try {
                //获取连接Socket 创建新的连接
                Socket myServer = ar.AsyncState as Socket;
                Socket service = myServer.EndAccept(ar);

                ClientState obj = new ClientState();
                obj.clientSocket = service;
                //接收连接Socket数据
                service.BeginReceive(obj.buffer, 0, ClientState.bufsize, SocketFlags.None, new AsyncCallback(ReadCallback), obj);
                myServer.BeginAccept(new AsyncCallback(Accept), myServer);//等待下一个连接
            } catch (Exception ex) {
                Console.WriteLine("服务端关闭" + ex.Message + " " + ex.StackTrace);
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

        /// <summary>
        /// 发送消息
        /// </summary>
        /// <param name="c_socket">指定客户端socket</param>
        /// <param name="by">内容数组</param>
        private void Send(Socket c_socket, byte[] by) {
            //发送
            c_socket.BeginSend(by, 0, by.Length, SocketFlags.None, asyncResult => {
                try {
                    //完成消息发送
                    int len = c_socket.EndSend(asyncResult);
                } catch (Exception ex) {
                    Console.WriteLine("error ex=" + ex.Message + " " + ex.StackTrace);
                }
            }, null);
        }
    }
}