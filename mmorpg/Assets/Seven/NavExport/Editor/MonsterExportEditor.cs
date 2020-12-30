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
	[CustomEditor(typeof(MonsterExport))]
	public class MonsterExportEditor : Editor
	{
		public override void OnInspectorGUI()
		{
			base.OnInspectorGUI();
			if (GUILayout.Button("Export"))
			{
				var exp = target as MonsterExport;
				exp.Exp();
				AssetDatabase.Refresh();
			}
			if (GUILayout.Button("Refresh"))
			{
				var exp = target as MonsterExport;
				exp.Refresh();
				AssetDatabase.Refresh();
			}
		}
	}
}