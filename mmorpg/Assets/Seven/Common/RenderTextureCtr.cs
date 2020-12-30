using UnityEngine;
using System.Collections;
using UnityEngine.UI;

namespace Seven
{
	public class RenderTextureCtr : MonoBehaviour
	{
		
		public Camera camera;

		private RawImage image;
		private RectTransform rectTransform;
		private RenderTexture rt;

		// Use this for initialization
		void Start ()
		{
			image = GetComponent<RawImage> ();
			rectTransform = GetComponent<RectTransform> ();
			rt = new RenderTexture ((int)rectTransform.rect.width, (int)rectTransform.rect.height, 24);
			rt.antiAliasing= 4;
			//rt.filterMode = FilterMode.Point;
			camera.targetTexture = rt;

			image.texture = camera.targetTexture;
		}
	}
}
