
using UnityEngine;
using System; 
using System.IO; 
using System.Net; 
using System.Text;

namespace Seven
{
	[SLua.CustomLuaClass]
	public class ClientToPhp : MonoBehaviour {
		public string url="http://192.168.0.197:58888/lyj";
		public void  sendDataToPhp(string postData){
			// 创建 WebRequest 对象，WebRequest 是抽象类，定义了请求的规定,
			// 可以用于各种请求，例如：Http, Ftp 等等。
			// HttpWebRequest 是 WebRequest 的派生类，专门用于 Http
			System.Net.HttpWebRequest request = System.Net.HttpWebRequest.Create(url) as System.Net.HttpWebRequest;

			// 请求的方式通过 Method 属性设置 ，默认为 GET
			// 可以将 Method 属性设置为任何 HTTP 1.1 协议谓词：GET、HEAD、POST、PUT、DELETE、TRACE 或 OPTIONS。
			request.Method = "GET";

			// 还可以在请求中附带 Cookie
			// 但是，必须首先创建 Cookie 容器
			// request.CookieContainer = new System.Net.CookieContainer();

			// System.Net.Cookie requestCookie = new System.Net.Cookie("Request", "RequestValue","/", "localhost");
			// request.CookieContainer.Add(requestCookie);

			// 拼接成请求参数串，并进行编码，成为字节
			// string postData = "firstone=" + inputData;			
			Debug.Log("php"+postData);
			ASCIIEncoding encoding = new ASCIIEncoding();
			byte[] byte1 = encoding.GetBytes(postData);

			// 设置请求的参数形式
			request.ContentType = "application/x-www-form-urlencoded";

			// 设置请求参数的长度.
			request.ContentLength = byte1.Length;

			// 取得发向服务器的流
			System.IO.Stream newStream = request.GetRequestStream();

			// 使用 POST 方法请求的时候，实际的参数通过请求的 Body 部分以流的形式传送
			newStream.Write(byte1, 0, byte1.Length);

			// 完成后，关闭请求流.
			newStream.Close();

			// GetResponse 方法才真的发送请求，等待服务器返回
			System.Net.HttpWebResponse response = (System.Net.HttpWebResponse)request.GetResponse();

			// 首先得到回应的头部，可以知道返回内容的长度或者类型
			Console.WriteLine("php Content length is {0}", response.ContentLength);
			Console.WriteLine("php Content type is {0}", response.ContentType);

			// // 回应的 Cookie 在 Cookie 容器中
			// foreach (System.Net.Cookie cookie in response.Cookies)
			// {
			// 	Console.WriteLine("Name: {0}, Value: {1}", cookie.Name, cookie.Value);
			// }
			Console.WriteLine();

			// 然后可以得到以流的形式表示的回应内容
			System.IO.Stream receiveStream = response.GetResponseStream();    

			// 还可以将字节流包装为高级的字符流，以便于读取文本内容
			// 需要注意编码
			System.IO.StreamReader readStream= new System.IO.StreamReader(receiveStream, Encoding.UTF8);

			Console.WriteLine("php Response stream received.");
			Console.WriteLine(readStream.ReadToEnd());

			// 完成后要关闭字符流，字符流底层的字节流将会自动关闭
			response.Close();
			readStream.Close();
		}
		public void sendtxtToPhp(string uriStr){
			Debug.Log(uriStr);
			 // = uriStr + "?参数A=" + A+ "&参数B=" + B;
 
            // WebRequest webRequest = WebRequest.Create(uriStr);
            // WebResponse WebResponse = webRequest.GetResponse();


            HttpWebRequest req = (HttpWebRequest) HttpWebRequest.Create(uriStr);  
  			req.ContentType = "application/json";  
			req.Method = "GET";  

			HttpWebResponse httpWebResponse = (HttpWebResponse)req.GetResponse();
        	StreamReader streamReader = new StreamReader(httpWebResponse.GetResponseStream());
        	string responseContent = streamReader.ReadToEnd();
        	Debug.Log(responseContent);
        	httpWebResponse.Close();
        	streamReader.Close();

        	//return responseContent;
        }
	}
}