using UnityEngine;
using System.Collections;
using System.IO;
using UnityEditor;
using System.Diagnostics;
using Hugula.Editor;

namespace Seven.Tool
{
	public static class LuaTableOptimizer
	{
		[MenuItem("Tools/配置表优化")]
		public static void StartChangeLuaConfig()
		{
			string path = Path.Combine (Application.dataPath, "LuaTableOptimizer");
			UnityEngine.Debug.Log ("path" + path);
			UnityEngine.Debug.Log ("开始优化配置表");
			string output = Path.Combine (path, "Database");
			//拷贝配置表
			EditorUtils.DirectoryDelete (output);
			EditorUtils.CheckDirectory (output);

			//拷贝配置文件到Database文件夹下
			CopyConfig (Path.Combine (path, "Config"), output);
			//开始优化配置表
			Process pro = CreateProcess("DataTableOptimizer.lua "+path, "/usr/local/bin/lua", path);
			pro.Start ();
			pro.WaitForExit ();

//			if (pro.ExitCode != 0) {
				//拷贝配置文件到Lua/config下
				CopyConfig (output, Path.Combine(Application.dataPath, "Lua/config"));
				EditorUtils.DirectoryDelete (output);
				UnityEngine.Debug.Log ("配置表优化完成");
//			} else {
//				UnityEngine.Debug.Log ("配置表优化出错");
//			}
			pro.Dispose();

		}
	
		private static void CopyConfig(string rootPath, string output)
		{
			string[] paths = Directory.GetFiles(rootPath, "*.lua", SearchOption.AllDirectories);
			foreach (string path in paths) {
				if (!IsIgnore (path)) {
					string file = Path.Combine (output, Path.GetFileName (path));
					if (Path.GetFileNameWithoutExtension (path).Equals ("mapMonsters")) {
						file = Path.Combine (output, "map/"+Path.GetFileName (path));
						EditorUtils.CheckDirectory (Path.Combine(output, "map"));
					}
					File.Copy(path, file, true);
				}
			}
		}

		private static Process CreateProcess(string Arguments, string FileName, string workPath)
		{
			Process process = new Process();
			ProcessStartInfo startInfo = new ProcessStartInfo();
			startInfo.Arguments = Arguments;
			startInfo.WindowStyle = ProcessWindowStyle.Hidden;
			startInfo.CreateNoWindow = true;
			// startInfo.UseShellExecute = false;
			startInfo.WorkingDirectory = workPath;
			startInfo.FileName = FileName;
			process.StartInfo = startInfo;
			return process;
		}

		private static bool IsIgnore(string path)
		{
			return path.Contains ("walkable") || path.Contains ("lua_output");
		}
	}
}

