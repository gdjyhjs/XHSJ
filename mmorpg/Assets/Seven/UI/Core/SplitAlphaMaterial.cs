using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UnityEngine.UI.Ext
{

	public static class SplitAlphaMaterial
	{

		class MatEntry
		{
			public Material baseMat;
			public Texture aTex;
			public Sprite sprite;
			public Material customMat;
			public int count;
		}

		static List<MatEntry> matList = new List<MatEntry>();


		public static Material Add(Material baseMaterial, Texture aTex)
		{
			if (aTex == null)
				return baseMaterial;

			for (int i = 0; i < matList.Count; ++i)
			{
				var mat = matList[i];
				if (mat.baseMat == baseMaterial
					&& mat.aTex == aTex)
				{
					++mat.count;
					return mat.customMat;
				}
			}

			var newEnt = new MatEntry();
			newEnt.count = 1;
			newEnt.baseMat = baseMaterial;
			newEnt.aTex = aTex;
			newEnt.customMat = new Material(baseMaterial);
			newEnt.customMat.hideFlags = HideFlags.HideAndDontSave;
			newEnt.customMat.name = string.Format("SplitAlpha: {0} {1}", baseMaterial.name, "alpha");
			newEnt.customMat.shader = Shader.Find ("Seven/UI/AlphaSplitedColored");
			newEnt.customMat.SetTexture("_AlphaTex",aTex);
			matList.Add(newEnt);

			return newEnt.customMat;
		}

		public static Material Add(Material baseMaterial, Texture aTex, Sprite sprite)
		{
			if (sprite == null)
				return baseMaterial;

			for (int i = 0; i < matList.Count; ++i)
			{
				var mat = matList[i];
				if (mat.baseMat == baseMaterial
					&& mat.sprite == sprite)
				{
					++mat.count;
					return mat.customMat;
				}
			}

			var newEnt = new MatEntry();
			newEnt.count = 1;
			newEnt.baseMat = baseMaterial;
			newEnt.sprite = sprite;
			newEnt.customMat = new Material(baseMaterial);
			newEnt.customMat.hideFlags = HideFlags.HideAndDontSave;
			newEnt.customMat.name = baseMaterial.name;
			newEnt.customMat.shader = baseMaterial.shader;
			newEnt.customMat.SetTexture("_AlphaTex",aTex);
			matList.Add(newEnt);

			return newEnt.customMat;
		}

		static void DestroyImmediate(Object obj)
		{
			if (obj != null)
			{
				if (Application.isEditor) Object.DestroyImmediate(obj);
				else Object.Destroy(obj);
			}
		}

		public static void Remove(Material customMat)
		{
			if (customMat == null)
				return;

			for (int i = 0; i < matList.Count; ++i)
			{
				MatEntry ent = matList[i];

				if (ent.customMat != customMat)
					continue;
				if (--ent.count == 0)
				{
					DestroyImmediate(ent.customMat);
					ent.baseMat = null;
					matList.RemoveAt(i);
				}
				if (ent.sprite == null && ent.aTex != null) {
					SImage.RemoveATex (ent.aTex.name);
				}
				return;
			}
		}
	}
}