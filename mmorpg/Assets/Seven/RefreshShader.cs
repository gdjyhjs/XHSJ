// Copyright (c) 2016 Seven
// direct 
//
using UnityEngine;
using System.Collections.Generic;

namespace Seven
{
	/// <summary>
	/// 刷新Shader
	/// </summary>
	public class RefreshShader : MonoBehaviour
	{

		/// <summary>``
		/// for index
		/// </summary>
		/// 
		void Start()
		{
			Refresh (gameObject);
		}

		void Refresh(GameObject obj)
		{
			#if UNITY_EDITOR
			List<Renderer> meshrs = new List<Renderer>(obj.GetComponentsInChildren<Renderer>(false));
			List<Material> mats = new List<Material>();

			for (int i = 0; i < meshrs.Count; i++)
			{
				Material[] mat = meshrs[i].sharedMaterials;
				if (mat == null) mat = meshrs[i].materials;
				if (mat != null)
				{
					mats.AddRange(mat);
				}
			}

			for (int i = 0; i < mats.Count; i++)
			{
				Material mat = mats[i];
				if (mat != null)
				{
					string shaderName = mat.shader.name;
					Shader newShader = Shader.Find(shaderName);
					if (newShader != null)
					{
						mat.shader = newShader;
					}
				}
			}
			#endif

		}
	}

}