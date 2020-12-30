using UnityEngine;    
using System.Collections;    
using System.Collections.Generic;    
using UnityEditor;    
using System.IO;    
using System.Reflection; 
using UnityEngine.UI;

namespace Seven
{

	public class AplitRGBATool : EditorWindow
	{  
		static int winType = 0;
		static string folder;

		#region EditorWindow
		[MenuItem("Tools/分离图片通道")]
		public static void OpenWindow()
		{
			winType = 1;
			EditorWindow.GetWindow(typeof(AplitRGBATool));
		}

		void OnEnable()
		{
			folder = "";
		}

		void OnGUI()
		{
			if (winType == 1) {
				GUILayout.Label ("分离图片通道", EditorStyles.boldLabel);
				folder = EditorGUILayout.TextField("文件夹名字(默认导出所有)", folder);
				if (GUILayout.Button ("开始")){
					SplitRgbAndAlphaChannel (folder);
				}

			}
		}
		#endregion EditorWindow


		static string GetTexturePath()
		{
			return Application.dataPath+"/";
		}

		static string GetBigTexturePath()
		{
			return Application.dataPath+"/";
		}


		//分离rgb和alpha通道
		static void SplitRgbAndAlphaChannel(string folder)  
		{  
			Debug.Log("开始分离");    
			string[] paths = Directory.GetFiles(GetTexturePath()+folder, "*.*", SearchOption.AllDirectories);  
			foreach (string path in paths)  
			{  
				if (!string.IsNullOrEmpty(path) && !IsIgnorePath(path) && IsTextureFile(path) && !IsTextureConverted(path))   //full name  
				{  
					SplitOneTextureChannel(path);  
				}  
			}
			AssetDatabase.SaveAssets ();
			AssetDatabase.Refresh();  
			Debug.Log("分离结束");    
		}  

		static void SplitOneTextureChannel(string texPath)  
		{  
			//获得相对路径  
			string assetRelativePath = GetRelativeAssetPath(texPath);
			SetTextureReadable (assetRelativePath);
			Texture2D sourcetex = AssetDatabase.LoadAssetAtPath(assetRelativePath, typeof(Texture2D)) as Texture2D;  //not just the textures under Resources file  
			if (!sourcetex)  
			{  
				Debug.Log("读取图片失败 : " + assetRelativePath);  
				return;  
			}  

			string fileName = Path.GetFileName (texPath);
			string outputPath = texPath;
			if (Directory.Exists(outputPath.Replace(fileName,"")) == false)//如果不存在就创建file文件夹
			{
				Directory.CreateDirectory(outputPath.Replace(fileName,""));
			}
			Color[] colors = sourcetex.GetPixels();  
			Texture2D rgbTex2 = new Texture2D(sourcetex.width, sourcetex.height, TextureFormat.RGB24, false);  
			rgbTex2.SetPixels(colors);  
			rgbTex2.Apply();  
			string strPath_RGB = GetRGBTexPath(outputPath); 
			if (File.Exists (strPath_RGB)) {
				File.Delete (strPath_RGB);
			}
			File.WriteAllBytes(strPath_RGB, rgbTex2.EncodeToPNG());  


			Texture2D alphaTex2 = new Texture2D(sourcetex.width , sourcetex.height, TextureFormat.RGB24, false);  
			Color[] alphacolors = new Color[colors.Length];  
			for (int i = 0; i < colors.Length; ++i)  
			{  
				float value = colors[i].a / 3;
				alphacolors[i].r = value;  
				alphacolors[i].g = value;  
				alphacolors[i].b = value;  
			}  
			alphaTex2.SetPixels(alphacolors);  
			alphaTex2.Apply();  
			string strPath_Alpha = GetAlphaTexPath(outputPath);  
			if (File.Exists (strPath_Alpha)) {
				File.Delete (strPath_Alpha);
			}
			File.WriteAllBytes(strPath_Alpha, alphaTex2.EncodeToPNG());  

		}  

		/// <summary>  
		/// 设置图片为可读格式  
		/// </summary>  
		/// <param name="_relativeAssetPath"></param>  
		static void SetTextureReadable(string _relativeAssetPath)  
		{  
			string postfix = GetFilePostfix(_relativeAssetPath);  
			if (postfix == ".dds")    // no need to set .dds file.  Using TextureImporter to .dds file would get casting type error.  
			{  
				return;  
			}  

			TextureImporter ti = (TextureImporter)TextureImporter.GetAtPath(_relativeAssetPath);  
			ti.isReadable = true;  
			AssetDatabase.ImportAsset(_relativeAssetPath);  
		} 


		#region Path or 后缀  
		/// <summary>  
		/// 获得相对路径  
		/// </summary>  
		/// <param name="_fullPath"></param>  
		/// <returns></returns>  
		static string GetRelativeAssetPath(string fullPath)  
		{  
			fullPath = GetRightFormatPath(fullPath);  
			int idx = fullPath.IndexOf("Assets");  
			string assetRelativePath = fullPath.Substring(idx);  
			return assetRelativePath;  
		}  

		/// <summary>  
		/// 转换斜杠  
		/// </summary>  
		/// <param name="_path"></param>  
		/// <returns></returns>  
		static string GetRightFormatPath(string path)  
		{  
			return path.Replace("\\", "/");  
		}  

		/// <summary>  
		/// 获取文件后缀  
		/// </summary>  
		/// <param name="_filepath"></param>  
		/// <returns></returns>  
		static string GetFilePostfix(string filepath)   //including '.' eg ".tga", ".dds"  
		{  
			string postfix = "";  
			int idx = filepath.LastIndexOf('.');  
			if (idx > 0 && idx < filepath.Length)  
				postfix = filepath.Substring(idx, filepath.Length - idx);  
			return postfix;  
		}  

		static bool IsIgnorePath(string path)  
		{  
			return path.Contains("\\UI\\");  
		}  

		/// <summary>  
		/// 是否为图片  
		/// </summary>  
		/// <param name="_path"></param>  
		/// <returns></returns>  
		static bool IsTextureFile(string path)  
		{  
			path = path.ToLower();  
			return path.EndsWith(".psd") || path.EndsWith(".tga") || path.EndsWith(".png") || path.EndsWith(".jpg") || path.EndsWith(".dds") || path.EndsWith(".bmp") || path.EndsWith(".tif") || path.EndsWith(".gif");  
		}  

		/// <summary>  
		/// 是否已经转过  
		/// </summary>  
		/// <param name="_path"></param>  
		/// <returns></returns>  
		static bool IsTextureConverted(string path)  
		{  
			return path.Contains("_etc_rgb.") || path.Contains("_etc_a.");  
		}    

		static string GetRGBTexPath(string texPath)
		{  
			return ReplacePath(texPath, "_etc_rgb.");  
		}  

		static string GetAlphaTexPath(string texPath)  
		{  
			return ReplacePath(texPath, "_etc_a.");  
		}  

		static string ReplacePath(string texPath, string texRole)  
		{  
			string result = texPath.Replace(".", texRole);  
			string postfix = GetFilePostfix(texPath);
			return result.Replace(postfix, ".png");  
		}  
		#endregion   
	}  
}