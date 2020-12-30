using UnityEngine;
using System.Collections;
//using UnityEngine.SceneManagement.SceneManager;

namespace Seven
{
	[SLua.CustomLuaClass]
	public static class SceneMgr
	{
		public static bool SetActiveScene(UnityEngine.SceneManagement.Scene scene)
		{
			return UnityEngine.SceneManagement.SceneManager.SetActiveScene (scene);
		}

		public static bool SetActiveScene(string name)
		{
			UnityEngine.SceneManagement.Scene scene = UnityEngine.SceneManagement.SceneManager.GetSceneByName (name);
			return UnityEngine.SceneManagement.SceneManager.SetActiveScene (scene);
		}
	}
}		
