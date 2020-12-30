// Copyright (c) 2015 hugula
// direct https://github.com/tenvick/hugula
//
using UnityEngine;
using System.IO;
using System;
using System.Collections.Generic;
using SLua;
using Hugula.Update;

using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.GZip;
using ICSharpCode.SharpZipLib.Tar;
using ICSharpCode.SharpZipLib.Core;
using System.Collections;

namespace Hugula.Utils
{
    /// <summary>
    /// 文件读取等操作
    /// </summary>
//    [SLua.CustomLuaClass]
    public class ZipHelper
    {


        /// <summary>
        /// files to gzip
        /// </summary>
        /// <param name="tgzFileName">tgzFileName.</param>
        /// <param name="files">files.</param>
        /// <param name="rootPath">rootPath.</param>
        public static void CreateGZip(string tgzFileName, List<String> files, string rootPath = null)
        {
            if (string.IsNullOrEmpty(rootPath)) rootPath = CUtils.realStreamingAssetsPath;
            rootPath = rootPath.Replace('\\', '/');
            if (rootPath.EndsWith("/"))
                rootPath = rootPath.Remove(rootPath.Length - 1);
            if (File.Exists(tgzFileName)) File.Delete(tgzFileName);
            using (Stream outStream = File.Create(tgzFileName))
            {
                using (GZipOutputStream gzoStream = new GZipOutputStream(outStream))
                {
                    TarArchive tarArchive = TarArchive.CreateOutputTarArchive(gzoStream);
                    tarArchive.RootPath = rootPath;
                    foreach (string filename in files)
                    {
                        //check folder
                        AddDirectoryFilesToTar(tarArchive, rootPath, filename);
                    }
                }
            }

        }

        private static void AddDirectoryFilesToTar(TarArchive tarArchive, string rootDirectory, string filePath)
        {
            filePath = filePath.Replace("\\", "/");
            string absFilePath = filePath.Replace(rootDirectory, "").Remove(0, 1);
            // Debug.Log(absFilePath);
            string[] parentDirInfos = absFilePath.Split('/');
            string parentDir = "";
            string sp = "/";
            for (int i = 0; i < parentDirInfos.Length - 1; i++)
            {
                parentDir += sp + parentDirInfos[i];
                TarEntry tarEntryDic = TarEntry.CreateEntryFromFile(rootDirectory + parentDir);
                tarArchive.WriteEntry(tarEntryDic, false);
                // Debug.Log(rootDirectory + parentDir);
            }

            TarEntry tarEntry = TarEntry.CreateEntryFromFile(filePath);
            tarArchive.WriteEntry(tarEntry, true);

        }



        public static void ExtractGZip(Stream stream, string outPath)
        {
            if (string.IsNullOrEmpty(outPath)) outPath = CUtils.realPersistentDataPath;
            if (!Directory.Exists(outPath)) Directory.CreateDirectory(outPath);

            using (Stream gzipStream = new GZipInputStream(stream))
            {
                TarArchive tarArchive = TarArchive.CreateInputTarArchive(gzipStream);
                tarArchive.ExtractContents(outPath);
                tarArchive.Close();
            }
            stream.Close();
        }

        public static void ExtractGZip(System.Array bts, string outPath)
        {
            var bytes = (byte[])bts;
            if (bytes != null)
            {
                using (MemoryStream m = new MemoryStream(bytes))
                {
                    ExtractGZip(m, outPath);
                }
            }
        }

        public static void ExtractGZipByPath(string tarFileName, string outPath)
        {
            if (File.Exists(tarFileName))
            {
                Stream inStream = File.OpenRead(tarFileName);
                ExtractGZip(inStream, outPath);
            }
            else
            {
                Debug.LogWarningFormat("{0} file is not exists!", tarFileName);
            }
        }



        /// <summary>
        /// files to gzip
        /// </summary>
        /// <param name="tgzFileName">tgzFileName.</param>
        /// <param name="files">files.</param>
        /// <param name="rootPath">rootPath.</param>
        public static bool CreateZip(string tgzFileName, List<String> files, string rootPath = null)
        {
            if(files.Count==0) return false;
            bool hasFile = false;
            if (string.IsNullOrEmpty(rootPath)) rootPath = CUtils.realStreamingAssetsPath;
            rootPath = rootPath.Replace('\\', '/');
            if (rootPath.EndsWith("/"))
                rootPath = rootPath.Remove(rootPath.Length - 1);
            int folderOffset = rootPath.Length;
            if (File.Exists(tgzFileName)) File.Delete(tgzFileName);
            using (Stream outStream = File.Create(tgzFileName))
            {
                using (ZipOutputStream zoStream = new ZipOutputStream(outStream))
                {
                    foreach (string filename in files)
                    {
                        //check folder
                        if (File.Exists(filename))
                        {
                            CompressFolder(filename, zoStream, folderOffset);
                            hasFile = true;
                        }
                        else
                            Debug.LogWarningFormat("zip file {0} not exists ", filename);
                    }
                }
            }
            return hasFile;
        }

        private static void CompressFolder(string filePath, ZipOutputStream zipStream, int folderOffset)
        {

            FileInfo fi = new FileInfo(filePath);
            string entryName = filePath.Substring(folderOffset); // Makes the name in zip based on the folder
            entryName = ZipEntry.CleanName(entryName); // Removes drive from name and fixes slash direction
            // Debug.Log(entryName);
            ZipEntry newEntry = new ZipEntry(entryName);
            newEntry.DateTime = fi.LastWriteTime; // Note the zip format stores 2 second granularity
            newEntry.Size = fi.Length;

            zipStream.PutNextEntry(newEntry);

            // Zip the file in buffered chunks
            // the "using" will close the stream even if an exception occurs
            byte[] buffer = new byte[4096];
            using (FileStream streamReader = File.OpenRead(filePath))
            {
                StreamUtils.Copy(streamReader, zipStream, buffer);
            }
            zipStream.CloseEntry();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="outPath"></param>
        public static void UnpackZip(Stream stream, string outFolder)
        {

            if (string.IsNullOrEmpty(outFolder)) outFolder = CUtils.realPersistentDataPath;
            if (!Directory.Exists(outFolder)) Directory.CreateDirectory(outFolder);

            ZipInputStream zipInputStream = new ZipInputStream(stream);
            ZipEntry zipEntry = zipInputStream.GetNextEntry();
            while (zipEntry != null)
            {
                String entryFileName = zipEntry.Name;
                // to remove the folder from the entry:- entryFileName = Path.GetFileName(entryFileName);
                // Optionally match entrynames against a selection list here to skip as desired.
                // The unpacked length is available in the zipEntry.Size property.

                byte[] buffer = new byte[4096];     // 4K is optimum

                // Manipulate the output filename here as desired.
                String fullZipToPath = Path.Combine(outFolder, entryFileName);
                string directoryName = Path.GetDirectoryName(fullZipToPath);
                if (directoryName.Length > 0 && !Directory.Exists(directoryName))
                    Directory.CreateDirectory(directoryName);

                // Unzip file in buffered chunks. This is just as fast as unpacking to a buffer the full size
                // of the file, but does not waste memory.
                // The "using" will close the stream even if an exception occurs.
                using (FileStream streamWriter = File.Create(fullZipToPath))
                {
                    StreamUtils.Copy(zipInputStream, streamWriter, buffer);
                }
                zipEntry = zipInputStream.GetNextEntry();
            }
        }

        /// <summary>
        /// 解压bytes
        /// </summary>
        /// <param name="bytes"></param>
        /// <param name="outPath"></param>
        public static void UnpackZip(System.Array bts, string outPath)
        {
            var bytes = (byte[])bts;
            if (bytes != null)
            {
                using (MemoryStream m = new MemoryStream(bytes))
                {
                    UnpackZip(m, outPath);
                }
            }
        }

        /// <summary>
        /// 按照路径解压zip
        /// </summary>
        /// <param name="bytes"></param>
        /// <param name="outPath"></param>
		public static bool UnpackZipByPath(string zipPath, string outPath)
        {
            if (File.Exists(zipPath))
            {
                using (Stream s = File.OpenRead(zipPath))
                {
                    UnpackZip(s, outPath);
                }
				return true;
            }
            else
            {
                Debug.LogWarningFormat("{0} file is not exists!", zipPath);
				return false;
            }
        }

        public static byte[] OpenZipFile(string zipPath, string fileName)
        {
            byte[] re = null;
            if (File.Exists(zipPath))
            {
                ZipInputStream zipInputStream = new ZipInputStream(File.OpenRead(zipPath));
                // while(ZipEntry zipEntry = zipInputStream.GetNextEntry() ;
            }


            return re;
        }

		static string GetStreamingAssetsZipPath()  
		{  
			#if UNITY_EDITOR  
			return Application.dataPath + "/StreamingAssets/"+CUtils.platformFloder+".zip";  
			#elif UNITY_ANDROID  
			return "jar:file://" + Application.dataPath + "!/assets/"+CUtils.platformFloder+".zip";  
			#elif UNITY_IPHONE  
			return Application.dataPath + "/Raw/" + CUtils.platformFloder+".zip";  
			#endif
		} 
		
		/// <summary>  
		/// 将streaming path 下的文件copy到对应用  
		/// 为什么不直接用io函数拷贝，原因在于streaming目录不支持，  
		/// 不管理是用getStreamingPath_for_www，还是Application.streamingAssetsPath，  
		/// io方法都会说文件不存在  
		/// </summary>  
		/// <param name="fileName"></param>  
		public static IEnumerator ExtractFromStreamingAssets(System.Action cb)  
		{  
			string src = GetStreamingAssetsZipPath();  
			string des = Application.persistentDataPath + "/" + CUtils.platformFloder;  
			Debug.Log("des:" + des);  
			Debug.Log("src:" + src);  
			WWW www = new WWW(src);
			yield return www;
			if (!string.IsNullOrEmpty(www.error))  
			{  
				Debug.LogError("拷贝压缩包出错:" + www.error);
			}  
			else  
			{  
				Debug.Log ("开始解压");
				Stream stream = new MemoryStream(www.bytes);
				Debug.Log ("开始解压1");
				UnpackZip (stream, CUtils.realUncompressStreamingAssetsPath);
				Debug.Log ("拷贝压缩包完成");
				if (cb != null) {
					cb ();
				}
			}  

			www.Dispose();
		} 
		
    }
}