using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace GameSocket {
    public class serverTest : MonoBehaviour {
        TcpServer server;
        private void Start() {
            server = new TcpServer("127.0.0.1", 7788);
        }

        private void OnDestroy() {
            if (server != null) {
                server.Close();
                server = null;
            }
        }
    }
}