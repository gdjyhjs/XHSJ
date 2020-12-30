// Copyright (c) 2014 hugula
// direct https://github.com/Hugulor/Hugula
//
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.IO;
using System.Diagnostics;
using System.Linq;
using Seven.Tool;
using Hugula.Utils;
using Hugula.Cryptograph;
using Debug = UnityEngine.Debug;
using Seven;

namespace Hugula.Editor
{
    public class ExportResources
    {

        public const string ConfigPath = EditorCommon.ConfigPath;//"Assets/Hugula/Config";

        #region osx lua
#if UNITY_IPHONE
	public static string luajitPath=CurrentRootFolder+"tools/luaTools/luajit_gc64";
#elif UNITY_ANDROID && UNITY_EDITOR_OSX
	public static string luajitPath=CurrentRootFolder+"tools/luaTools/luajit_32";
#elif UNITY_ANDROID && UNITY_EDITOR_WIN
	public static string luajitPath = CurrentRootFolder + "tools/luaTools/win/210/luajit.exe";
#elif UNITY_STANDALONE_WIN && UNITY_EDITOR_WIN //pc版本
	public static string luajitPath = CurrentRootFolder+"tools/luaTools/win/204/luajit.exe";
#elif UNITY_STANDALONE_WIN && UNITY_EDITOR_OSX //pc版本
	public static string luajitPath=CurrentRootFolder+"tools/luaTools/luajit2.04";
#elif UNITY_STANDALONE_OSX
	public static string luajitPath=CurrentRootFolder+"tools/luaTools/luajit_gc64";
#else
	public static string luajitPath = "";
#endif

#if UNITY_EDITOR_WIN //win
    public static string luaWorkingPath = CurrentRootFolder + "tools/luaTools/win";
    public static string luacPath = CurrentRootFolder + "tools/luaTools/win/204/luajit.exe";
#elif UNITY_EDITOR_OSX && UNITY_IPHONE //iOS on mac
    public static string luaWorkingPath = CurrentRootFolder+"tools/luaTools";
    public static string luacPath = "";
#elif UNITY_STANDALONE_WIN && UNITY_EDITOR_OSX //win on mac
    public static string luaWorkingPath = CurrentRootFolder+"tools/luaTools";
    public static string luacPath = CurrentRootFolder+"tools/luaTools/luajit2.04";
#else // mac 
    public static string luaWorkingPath = CurrentRootFolder+"tools/luaTools";
    public static string luacPath = CurrentRootFolder+"tools/luaTools/luajit";
#endif

#if UNITY_EDITOR_OSX && (UNITY_ANDROID || UNITY_IPHONE)
    public static string OutLuaPath = CurrentRootFolder+"Assets/" + Common.LUACFOLDER + "/osx";
#elif UNITY_EDITOR_OSX && UNITY_STANDALONE_WIN
    public static string OutLuaPath = CurrentRootFolder+"Assets/" + Common.LUACFOLDER + "/win";
#elif UNITY_EDITOR_WIN
        public static string OutLuaPath = CurrentRootFolder + "Assets/" + Common.LUACFOLDER + "/win";
#else //默认平台
    public static string OutLuaPath = CurrentRootFolder+"Assets/" + Common.LUACFOLDER + "/osx";
#endif

        //lua bytes 输出目录
        // public static string OutLuaBytesPath = //"Assets/" + Common.LUACFOLDER + "/Resources";

#if UNITY_ANDROID
        public static string LuaTmpPath = "Assets/Tmp/" + Common.LUA_TMP_FOLDER;//"/Tmp/" + Common.LUACFOLDER + "/";
#endif

        public static string CurrentRootFolder
        {
            get
            {
                string dataPath = Application.dataPath;
                dataPath = dataPath.Replace("Assets", "");
                return dataPath;
            }
        }

        #endregion

        #region update
        /// <summary>
        /// Builds the asset bundles update A.
        /// </summary>
        public static void buildAssetBundlesUpdateAB()
        {
            EditorUtility.DisplayProgressBar("Generate FileList", "loading bundle manifest", 1 / 2);
            AssetDatabase.Refresh();
            string readPath = EditorUtils.GetFileStreamingOutAssetsPath();// 读取Streaming目录
            var u3dList = EditorUtils.getAllChildFiles(readPath, @"\.meta$|\.manifest$|\.DS_Store$|\.u$", null, false);
            List<string> assets = new List<string>();
            foreach (var s in u3dList)
            {
                string ab = EditorUtils.GetAssetPath(s); //s.Replace(readPath, "").Replace("/", "").Replace("\\", "");
                assets.Add(ab);
            }

            readPath = new System.IO.DirectoryInfo(EditorUtils.GetLuaBytesResourcesPath()).FullName;// 读取lua 目录
            u3dList = EditorUtils.getAllChildFiles(readPath, @"\.bytes$", null);
            foreach (var s in u3dList)
            {
                string ab = EditorUtils.GetAssetPath(s); //s.Replace(readPath, "").Replace("/", "").Replace("\\", "");
                assets.Add(ab);
            }

            EditorUtility.ClearProgressBar();
            CUtils.DebugCastTime("Time Generate FileList End");
            Debug.Log("all assetbundle count = " + assets.Count);
            BuildScript.GenerateAssetBundlesUpdateFile(assets.ToArray());
            CUtils.DebugCastTime("Time GenerateAssetBundlesUpdateFile End");
        }

        #endregion


        #region export

        private static Process CreateProcess(string Arguments, string FileName)
        {
            Process process = new Process();
            ProcessStartInfo startInfo = new ProcessStartInfo();
            startInfo.Arguments = Arguments;
            startInfo.WindowStyle = ProcessWindowStyle.Hidden;
            startInfo.CreateNoWindow = true;
            // startInfo.UseShellExecute = false;
            startInfo.WorkingDirectory = luaWorkingPath;
            startInfo.FileName = FileName;
            process.StartInfo = startInfo;
            return process;
        }

        public static void doExportLua(string[] childrens)
        {
            EditorUtils.CheckstreamingAssetsPath();

            string info = "luac";
            string title = "build lua";
            EditorUtility.DisplayProgressBar(title, info, 0);

//            var checkChildrens = AssetDatabase.GetAllAssetPaths().Where(p =>
//                (p.StartsWith("Assets/Lua")
//                || p.StartsWith("Assets/Config"))
//                && (p.EndsWith(".lua"))
//                ).ToArray();
            string path = "Assets/Lua/"; //lua path
            string path1 = "Assets/Config/"; //config path
            string root = CurrentRootFolder;//Application.dataPath.Replace("Assets", "");

            string crypName = "", crypEditorName = "", fileName = "", outfilePath = "", arg = "";
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
			System.Text.StringBuilder crc_sb = new System.Text.StringBuilder();
			
            //refresh directory
//            if (checkChildrens.Length == childrens.Length) EditorUtils.DirectoryDelete(OutLuaPath);
            EditorUtils.CheckDirectory(OutLuaPath);


            string OutLuaBytesPath = EditorUtils.GetLuaBytesResourcesPath();
            string luabytesParentPath = OutLuaBytesPath.Substring(0, OutLuaBytesPath.LastIndexOf("/"));
            string streamingAssetsPath = Path.Combine(CurrentRootFolder, OutLuaBytesPath); //Path.Combine(CurrentRootFolder, LuaTmpPath);
//            EditorUtils.DirectoryDelete(luabytesParentPath);
            EditorUtils.CheckDirectory(luabytesParentPath);
            EditorUtils.CheckDirectory(streamingAssetsPath);
            Debug.Log(streamingAssetsPath);
            List<System.Diagnostics.Process> listPc = new List<System.Diagnostics.Process>();

            List<string> luabytesAssets32 = new List<string>();
            List<string> luabytesAssets64 = new List<string>();
			
			string tmpPath = EditorUtils.GetAssetTmpPath();
			string luaCrcPath = Path.Combine(tmpPath, "lua_crc.txt");
			string luaMd5Path = Path.Combine(tmpPath, "lua_md5mapping.txt");
			if (File.Exists (luaMd5Path)) {
				//文件读写流
				StreamReader sr = new StreamReader(luaMd5Path);
				//读取内容
				string result = sr.ReadToEnd();
				sb.Append (result);
			}

			string[] diffList = new string[2000];
			Dictionary<string, uint> luaCrcDis = new Dictionary<string, uint> ();
			if (File.Exists (luaCrcPath)) {
				//文件读写流
				StreamReader sr = new StreamReader(luaCrcPath);
				//读取内容
				string result = sr.ReadToEnd();

				//逐行截取(这样截取的数据可能会有问题，如多一行或对一个空格，需要调整)
				// 可以自行百度方法解决，也可以按实际手动修改
				string[] data = result.Split('\n' );

				foreach (string line in data) {
					string[] tl = line.Split ('=');
					if (tl.Length == 2) {
						luaCrcDis.Add (tl [0], uint.Parse (tl [1]));
					}
				}
				int index = 0;
				foreach (string file in childrens) {
					if (file == null){
						continue;
					}
					string filePath = Path.Combine (root, file);
					fileName = CUtils.GetAssetName (filePath);
					crypName = file.Replace (path, "").Replace (path1, "").Replace (".lua", ".bytes").Replace ("\\", "+").Replace ("/", "+");
					string override_name = CUtils.GetRightFileName (crypName);
					uint len = 0;
					uint crc = Hugula.Update.CrcCheck.GetLocalFileCrc (filePath, out len);

					if (!luaCrcDis.ContainsKey (override_name) || luaCrcDis [override_name] != crc) {
						diffList [index++] = file;
					} 
				}
			} else {
				diffList = childrens;
			}

			float allLen = diffList.Length;
			float i = 0;

			foreach (string file in diffList)
            {
				if (file == null)
					continue;

                string filePath = Path.Combine(root, file);
                fileName = CUtils.GetAssetName(filePath);
                crypName = file.Replace(path, "").Replace(path1, "").Replace(".lua", ".bytes").Replace("\\", "+").Replace("/", "+");
                crypEditorName = file.Replace(path, "").Replace(path1, "").Replace(".lua", "." + Common.ASSETBUNDLE_SUFFIX).Replace("\\", "+").Replace("/", "+");
                if (!string.IsNullOrEmpty(luajitPath))// luajit32
                {
                    string override_name = CUtils.GetRightFileName(crypName);
                    string override_lua = streamingAssetsPath + "/" + override_name;
                    arg = "-b " + filePath + " " + override_lua; //for jit
                    // Debug.Log(arg);
                    listPc.Add(CreateProcess(arg, luajitPath));
                    luabytesAssets32.Add(Path.Combine(OutLuaBytesPath, override_name));
                    sb.AppendLine("[\"" + crypName + "\"] = { name = \"" + override_name + "\", path = \"" + file + "\", out path = \"" + override_lua + "\"},");
                }
                i++;
                // EditorUtility.DisplayProgressBar(title, info + "=>" + i.ToString() + "/" + allLen.ToString(), i / allLen);
				uint len = 0;
				uint crc = Hugula.Update.CrcCheck.GetLocalFileCrc (filePath, out len);
				string abName = CUtils.GetRightFileName (crypName);
				if (luaCrcDis.ContainsKey (abName)) {
					luaCrcDis [abName] = crc;
				} else {
					luaCrcDis.Add (abName, crc);
				}
            }

            //compile lua
            int total = listPc.Count;
            int workThreadCount = System.Environment.ProcessorCount * 2 + 2;
            int batchCount = (int)System.Math.Ceiling(total / (float)workThreadCount);
            for (int batchIndex = 0; batchIndex < batchCount; ++batchIndex)
            {
                int processIndex;
                int offset = batchIndex * workThreadCount;
                for (processIndex = 0; processIndex < workThreadCount; ++processIndex)
                {
                    int fileIndex = offset + processIndex;
                    if (fileIndex >= total)
                        break;
                    var ps = listPc[fileIndex];
                    ps.Start();
                }

                bool fail = false;
                fileName = null;
                string arguments = null;
                for (int j = offset; j < offset + processIndex; ++j)
                {
                    var ps = listPc[j];
                    ps.WaitForExit();

                    EditorUtility.DisplayProgressBar(title, info + "=>" + j.ToString() + "/" + total.ToString(), j / total);

                    if (ps.ExitCode != 0 && !fail)
                    {
                        fail = true;
                        fileName = ps.StartInfo.FileName;
                        arguments = ps.StartInfo.Arguments;
                    }
                    ps.Dispose();
                }

                if (fail)
                {
//                    throw new System.Exception(string.Format("Luajit Compile Fail.FileName={0},Arg={1}", fileName, arguments));
					Debug.LogError (string.Format("Luajit Compile Fail.FileName={0},Arg={1}", fileName, arguments));
                }
            }
			
			foreach (string key in luaCrcDis.Keys) {
				crc_sb.AppendLine (key+"="+luaCrcDis [key]);
			}

            Debug.Log("lua:" + path + "files=" + childrens.Length + " completed");
            System.Threading.Thread.Sleep(100);

            //out md5 mapping file
            EditorUtils.CheckDirectory(tmpPath);
			Debug.Log("write to path=" + luaMd5Path);
			File.Delete (luaMd5Path);
			using (StreamWriter sr = new StreamWriter(luaMd5Path, false))
            {
                sr.Write(sb.ToString());
            }

			File.Delete (luaCrcPath);
			using (StreamWriter sr = new StreamWriter(luaCrcPath, false))
			{
				sr.Write(crc_sb.ToString());
			}

	            EditorUtility.ClearProgressBar();
	        }

        public static void exportLua()
        {
//            var childrens = AssetDatabase.GetAllAssetPaths().Where(p =>
//               (p.StartsWith("Assets/Lua")
//               || p.StartsWith("Assets/Config"))
//               && (p.EndsWith(".lua"))
//               ).ToArray();
			string[] childrens = Directory.GetFiles(Path.Combine(Application.dataPath, "Lua/"), "*.lua", SearchOption.AllDirectories);
			string[] files = new string[childrens.Length];
			int j = 0;
			for (int i = 0; i < childrens.Length; i++) {
				string file = childrens [i];
				if (!IsIgnore (file)) {
					files [j++] = GetRelativeAssetPath (file);
				}
			}
			doExportLua(files);
        }

        public static void exportConfig()
        {
            var files = AssetDatabase.GetAllAssetPaths().Where(p =>
             p.StartsWith("Assets/Config") || !p.StartsWith("Assets/Config/Lan")
             && p.EndsWith(".csv")
             ).ToArray();

            EditorUtils.CheckstreamingAssetsPath();

            if (files.Length > 0)
            {
                string cname = CUtils.GetRightFileName(Common.CONFIG_CSV_NAME);
                BuildScript.BuildABs(files.ToArray(), null, cname, SplitPackage.DefaultBuildAssetBundleOptions);
                Debug.Log(" Config export " + cname);
            }

        }

        public static void exportLanguage()
        {
            var files = AssetDatabase.GetAllAssetPaths().Where(p =>
                p.StartsWith("Assets/Config/Lan")
                && p.EndsWith(".csv")
            ).ToArray();

            EditorUtils.CheckstreamingAssetsPath();
            // BuildScript.ch
            foreach (string abPath in files)
            {
                string name = CUtils.GetAssetName(abPath);
                string abName = CUtils.GetRightFileName(name + Common.CHECK_ASSETBUNDLE_SUFFIX);
                Hugula.BytesAsset bytes = (Hugula.BytesAsset)ScriptableObject.CreateInstance(typeof(Hugula.BytesAsset));
                bytes.bytes = File.ReadAllBytes(abPath);
                string bytesPath = string.Format("Assets/Tmp/{0}.asset", name);
                AssetDatabase.CreateAsset(bytes, bytesPath);
                BuildScript.BuildABs(new string[] { bytesPath }, null, abName, SplitPackage.DefaultBuildAssetBundleOptions);
                Debug.Log(name + " " + abName + " export");
            }
        }

        public static void exportPublish()
        {
//            exportLanguage();
            //exportConfig();
			LuaTableOptimizer.StartChangeLuaConfig ();
			exportLua();
			CUtils.DebugCastTime("Time exportLua End");

            BuildScript.BuildAssetBundles(); //导出资源
            // CleanAssetbundle.Clean();        //清理多余的资源

            CUtils.DebugCastTime("Time BuildAssetBundles End");
            buildAssetBundlesUpdateAB();//更新列表和版本号码
            CUtils.DebugCastTime("Time buildAssetBundlesUpdateAB End");
        }

		static string GetRelativeAssetPath(string fullPath)
		{  
			fullPath = GetRightFormatPath (fullPath);  
			int idx = fullPath.IndexOf ("Assets");  
			string assetRelativePath = fullPath.Substring (idx);  
			return assetRelativePath;  
		}

		static string GetRightFormatPath(string path)  
		{  
			return path.Replace("\\", "/");  
		}  

		static bool IsIgnore(string file)
		{
			return file.Contains ("walkable") || file.Contains ("lua_output");
		}
        #endregion

    }
}