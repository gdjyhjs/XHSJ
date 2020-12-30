/**
 * 导入fbx的时候自动修改一些动画为循环播放
*/
//using UnityEngine;
//using System.Collections;
//using System.Collections.Generic;
//using UnityEditor;
//
//namespace Seven
//{
//	public class Importer : AssetPostprocessor 
//
//	{
//
//		#region Override Methods
//
//		void OnPostprocessModel(GameObject g)
//
//		{
//
//			ModelImporter model = (ModelImporter)assetImporter;
//
//			if (model != null)
//
//			{
//
//				if (isLoopAnimation(g.name))
//
//				{
//
//					//由于我们采用动画分离的导出策略，每个fbx只有一个动画
//
//					if (model.defaultClipAnimations.Length > 0) 
//
//					{
//
//						List<ModelImporterClipAnimation> actions = new List<ModelImporterClipAnimation>();
//
//						ModelImporterClipAnimation anim = model.defaultClipAnimations[0];
//
//						anim.loopTime = true;
//
//						actions.Add(anim);
//
//						model.clipAnimations = actions.ToArray();
//
//					}
//
//				}
//
//			}
//
//		}
//
//		#endregion
//
//		#region Inner
//
//		bool isLoopAnimation(string objectName)
//
//		{
//
//			bool res = false;
//
//			if (objectName.Contains("idle"))
//
//			{
//
//				res = true;
//
//			}
//
//			else if (objectName.Contains("walk"))
//
//			{
//
//				res = true;
//
//			}
//
//			else if (objectName.Contains("run"))
//
//			{
//
//				res = true;
//
//			}
//
//			else if (objectName.Contains("sidle"))
//
//			{
//
//				res = true;
//
//			}
//
//			else if (objectName.Contains("dizziness"))
//
//			{
//
//				res = true;
//
//			}
//
//			return res;
//
//		}
//
//		#endregion
//
//	}
//}
