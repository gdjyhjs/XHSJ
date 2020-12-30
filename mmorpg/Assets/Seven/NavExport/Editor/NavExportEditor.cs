using UnityEngine;
using System.Collections;
using System.Text;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
namespace Seven
{
	[CustomEditor(typeof(NavExport))]
	public class NavExportHelper : Editor
	{
		public override void OnInspectorGUI()
		{
			base.OnInspectorGUI();
			if (GUILayout.Button("Export"))
			{
				var exp = target as NavExport;
				exp.Exp();
				AssetDatabase.Refresh();
			}
		}
	}
}