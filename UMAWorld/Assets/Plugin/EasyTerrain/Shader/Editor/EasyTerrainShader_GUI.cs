using UnityEditor;
using UnityEngine;
using System;

public class EasyTerrainShader_GUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {

        Material targetMat = materialEditor.target as Material;

        EditorGUI.BeginChangeCheck();

        EditorGUILayout.LabelField("Terrain Size", EditorStyles.boldLabel);
        Vector3 _TerrainTileSize = targetMat.GetVector("_TerrainTileSize");
        _TerrainTileSize = EditorGUILayout.Vector3Field("Size XYZ", _TerrainTileSize);

        //-------------------------

        EditorGUILayout.Space();
        EditorGUILayout.LabelField("TriPlanar Projection", EditorStyles.boldLabel);
        bool _TRIPLANAR_ON = Array.IndexOf(targetMat.shaderKeywords, "_TRIPLANAR_ON") != -1;
        _TRIPLANAR_ON = EditorGUILayout.ToggleLeft("Use TriPlanar Projection", _TRIPLANAR_ON);

        //-------------------------

        EditorGUILayout.Space();
        EditorGUILayout.LabelField("Multi UV Mixing", EditorStyles.boldLabel);
        float _UVmixingMultiplier = targetMat.GetFloat("_UVmixingMultiplier");
        _UVmixingMultiplier = EditorGUILayout.Slider("UV Multiplier", _UVmixingMultiplier, 0.0001f, 1f);

        //-------------------------

        EditorGUILayout.Space();
        EditorGUILayout.LabelField("UV Mixing Distances:");
        float _UVmixingDistanceNear = targetMat.GetFloat("_UVmixingDistanceNear");
        float _UVmixingDistanceFar = targetMat.GetFloat("_UVmixingDistanceFar");
        float _UVmixingDistanceNear_temp = EditorGUILayout.Slider("  Near", _UVmixingDistanceNear, 1f, 100f);
        float _UVmixingDistanceFar_temp = EditorGUILayout.Slider("  Far", _UVmixingDistanceFar, 1f, 100f);

        //-------------------------

        EditorGUILayout.Space();
        float _MainTexDistance = targetMat.GetFloat("_MainTexDistance");
        bool _FADE_TO_BASEMAP_ON = Array.IndexOf(targetMat.shaderKeywords, "_FADE_TO_BASEMAP_ON") != -1;
        _FADE_TO_BASEMAP_ON = EditorGUILayout.ToggleLeft("Fade To Basemap?", _FADE_TO_BASEMAP_ON);
        if (_FADE_TO_BASEMAP_ON)
        {
            _MainTexDistance = EditorGUILayout.Slider("Base Texture Distance", _MainTexDistance, 1f, 2000f);
        }

        //-------------------------

        EditorGUILayout.Space();
        EditorGUILayout.LabelField("GPU Instancing", EditorStyles.boldLabel);
        bool _GPU_Instancing = targetMat.enableInstancing;
        _GPU_Instancing = EditorGUILayout.ToggleLeft("Enable GPU Instancing", _GPU_Instancing);

        //-------------------------

        if (EditorGUI.EndChangeCheck())
        {
            targetMat.SetVector("_TerrainTileSize", _TerrainTileSize);

            if (_TRIPLANAR_ON)
            {
                targetMat.EnableKeyword("_TRIPLANAR_ON");
            }
            else
            {
                targetMat.DisableKeyword("_TRIPLANAR_ON");
            }

            _UVmixingMultiplier = Mathf.Clamp(_UVmixingMultiplier, 0.0001f, 1f);
            targetMat.SetFloat("_UVmixingMultiplier", _UVmixingMultiplier);

            _UVmixingDistanceNear = Mathf.Min(_UVmixingDistanceNear_temp, _UVmixingDistanceFar_temp);
            _UVmixingDistanceFar = Mathf.Max(_UVmixingDistanceNear_temp + 1f, _UVmixingDistanceFar_temp);
            targetMat.SetFloat("_UVmixingDistanceNear", _UVmixingDistanceNear);
            targetMat.SetFloat("_UVmixingDistanceFar", _UVmixingDistanceFar);

            _MainTexDistance = Mathf.Clamp(_MainTexDistance, _UVmixingDistanceFar + 1f, 2000f);
            targetMat.SetFloat("_MainTexDistance", _MainTexDistance);
            if (_FADE_TO_BASEMAP_ON)
            {
                targetMat.EnableKeyword("_FADE_TO_BASEMAP_ON");
            }
            else
            {
                targetMat.DisableKeyword("_FADE_TO_BASEMAP_ON");
            }

            targetMat.enableInstancing = _GPU_Instancing;

            EditorUtility.SetDirty(targetMat);
        }

        //-------------------------

        //EditorGUILayout.Space();
        //EditorGUILayout.Space();
        //base.OnGUI(materialEditor, properties);

        //-------------------------
    }
}
