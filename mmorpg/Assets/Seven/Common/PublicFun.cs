using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using SLua;
using System;
using Hugula.UGUIExtend;
using Seven;

namespace Seven
{
	[SLua.CustomLuaClass]
	public static class PublicFun
	{
		//获取自动寻路网格pos
		public static Vector3 GetNavMeshPos(float x, float y, int originalHeight)
		{
			bool isHave = false;
			Vector3 pos	= new Vector3 (x, 200, y);
			RaycastHit hit;
			Ray ray = new Ray (pos, Vector3.down);
			if (Physics.Raycast(ray, out hit, 300, 1<<12))//Floor layer
			{
				isHave = true;
				pos.y = hit.point.y;
			}

			if(isHave)
				return pos;

			UnityEngine.AI.NavMeshHit nhit;
			float _y = 0.0f;
			for (int k = -10+originalHeight; k < 10+originalHeight; ++k)
			{
				pos.y = k;
				if (UnityEngine.AI.NavMesh.SamplePosition(pos, out nhit, 0.5f, UnityEngine.AI.NavMesh.AllAreas))
				{
					_y = k;
					break;
				}
			}
			pos.y = _y;
			if(isHave)
				return pos;

			pos.x = -1;
			pos.y = -1;
			pos.z = -1;
			return pos;
		}

		public static Shader FindShader(string name)
		{
			return Shader.Find (name);
		}

		/// 获取当前时间戳
		/// </summary>
		/// <param name="bflag">为真时获取10位时间戳,为假时获取13位时间戳.</param>
		/// <returns></returns>
		public static long GetTimeStamp(bool bflag = true)
		{
			TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
			long ret;
			if (bflag)
				ret = Convert.ToInt64(ts.TotalSeconds);
			else
				ret = Convert.ToInt64(ts.TotalMilliseconds);
			return ret;
		}

		public static bool IsNull(UnityEngine.Object obj)
		{
			return obj == null;
		}

		public static void SetEulerAngles(Transform target, float x, float y, float z)
		{
			target.eulerAngles = new Vector3 (x, y, z);
		}

		public static void SetEulerAngles(GameObject target, float x, float y, float z)
		{
			target.transform.eulerAngles = new Vector3 (x, y, z);
		}

		public static Vector3 TransformDirection(GameObject obj, float dis)
		{
			return obj.transform.TransformDirection(Vector3.forward*dis);
		}

		public static Renderer ChangeShader(GameObject obj, string shaderName)
		{
//			Renderer[] renders = obj.GetComponentsInChildren<Renderer> ();
//
//			for (int i = 0; i < renders.Length; i++) {
//				Renderer render = renders [i];
//				if (render.material == null) {
//					continue;
//				}
//				render.material.shader = Shader.Find (shaderName);
//			}
			Renderer render = obj.GetComponentInChildren<Renderer>();
			render.material.shader = Shader.Find (shaderName);
			return render;
		}

		public static void SetPosition(GameObject obj, Vector3 pos)
		{
			obj.transform.position = pos;
		}

		public static void SetPosition(Transform obj, Vector3 pos)
		{
			obj.position = pos;
		}

		public static void SetPosition(GameObject obj, float x, float y, float z)
		{
			obj.transform.position = new Vector3 (x, y, z);
		}

		public static void SetPosition(Transform obj, float x, float y, float z)
		{
			obj.position = new Vector3 (x, y, z);
		}

		public static float GetDistanceSquare(Transform t1, Transform t2)
		{
			if (t1 == null || t2 == null) {
				return -1;
			}
			Vector3 dp = t1.position - t2.position;
			return dp.x * dp.x + dp.y * dp.y + dp.z * dp.z;
		}

		public static float GetDistanceSquare(Vector3 p1, Vector3 p2)
		{
			Vector3 dp = p1 - p2;
			return dp.x * dp.x + dp.y * dp.y + dp.z * dp.z;
		}

		//或去ugui某个节点在Canvas里的坐标
		static Canvas _canvas;
		public static Vector3 CovertToCanvasPosition(GameObject canvasObj, GameObject obj)
		{
//			Canvas canvas = canvasObj.GetComponent<Canvas> ();
//			if (canvas == null)
//				canvas = canvasObj.GetComponentInChildren<Canvas> ();
			if (_canvas == null) {
				_canvas = GameObject.Find ("UI").GetComponentInChildren<Canvas> ();
			}

			Vector2 pos = Vector3.zero;
			if(RectTransformUtility.ScreenPointToLocalPointInRectangle(_canvas.transform as RectTransform, obj.transform.position, _canvas.GetComponent<Camera>(), out pos)){
//				Debug.Log(pos);
			}
			return pos;
		}

		public static UI.AddButton AddButton(GameObject obj)
		{
			return obj.AddComponent<UI.AddButton> ();
		}

		/// <summary>
		/// 从自身坐标到世界坐标变换方向
		/// </summary>
		/// <returns>The direction.</returns>
		/// <param name="t">t</param>
		/// <param name="pos">坐标向量</param>
		public static Vector3 TransformDirection(Transform t, Vector3 pos)
		{
			return t.transform.position + t.TransformDirection(pos);
		}

		/// <summary>
		/// 设置渲染队列
		/// </summary>
		/// <param name="obj">Object.</param>
		/// <param name="queue">Queue.</param>
		public static void SetRenderQueue(GameObject obj, int queue)
		{
			Renderer[] renders = obj.GetComponentsInChildren<Renderer> ();

			for (int i = 0; i < renders.Length; i++) {
				Renderer render = renders [i];
				if (render.material == null) {
					continue;
				}
				render.material.renderQueue = queue;
			}
		}

		public static Material CreateMat(string shaderName)
		{
			return new Material (Shader.Find(shaderName));
		}

		//检查两点的射线是否墙
		public static bool CheckTwoPosHitWall(Vector3 tpos, Vector3 fpos)
		{
			RaycastHit hit;
			Ray ray = new Ray (fpos, tpos);
			if (Physics.Raycast (ray, out hit, Vector3.Distance (tpos, fpos), 1 << 13)) {//Wall layer
				return true;
			}
			return false;
		}
	}
}

