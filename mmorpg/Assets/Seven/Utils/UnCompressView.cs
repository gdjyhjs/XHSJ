using UnityEngine;
using Hugula.Loader;
using Hugula.Utils;
using Hugula.Update;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Hugula;
using Hugula.Utils;
using UnityEngine.UI;
using ICSharpCode.SharpZipLib.Zip;

namespace Seven.Utils
{
	public class UnCompressView : MonoBehaviour
	{
		public class UnCompressCB : ZipUtility.UnzipCallback{

			public long size = 0;
			public float per = 0f;
			public bool finish = false;

			public override void OnPostUnzip(long totalSize, ZipEntry entry) 
			{
				size += entry.CompressedSize;
				per = (float)size / totalSize;
//				Debug.Log (string.Format ("真正解压...({0:P})", per));
			}

			public override void OnFinished(bool result) 
			{
				finish = result;
			}
		}

		GameObject view;
		Slider slider;
		Text tips;
		long size = 0;
		System.Action finishCB;

		public UnCompressCB cb;

		void Awake()
		{
			view = GameObject.Find("regeng");
			ReferGameObjects refer = view.GetComponent<ReferGameObjects>();
			slider = refer.Get("slider") as Slider;
			slider.value = 0;
			(refer.Get ("slider_obj") as GameObject).SetActive (true);

			tips = refer.Get("updateText") as Text;
			tips.text = "开始解压";

			cb = new UnCompressCB ();
		}

		void Update()
		{
			tips.text = string.Format ("正在解压...({0:P})", cb.per);
			slider.value = cb.per;
			if (cb.finish && finishCB != null) {
				finishCB ();
				GameObject.Destroy (this);
			}
		}

		public void SetFinishCB(System.Action cb)
		{
			finishCB = cb;
		}
	}
}