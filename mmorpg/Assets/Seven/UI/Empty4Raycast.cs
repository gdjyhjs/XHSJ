using UnityEngine;
using System.Collections;

namespace Seven.UI
{
	public class Empty4Raycast : UnityEngine.UI.MaskableGraphic
	{
		protected Empty4Raycast()
		{
			useLegacyMeshGeneration = false;
		}

		protected override void OnPopulateMesh(UnityEngine.UI.VertexHelper toFill)
		{
			toFill.Clear();
		}
	}
}