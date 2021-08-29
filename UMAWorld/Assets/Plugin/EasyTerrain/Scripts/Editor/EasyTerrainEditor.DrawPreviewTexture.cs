using UnityEngine;
using UnityEditor;
using System.Threading;
using MouseSoftware;

public partial class EasyTerrainEditor : Editor
{
    //------------------------------------------------------------------

    private void DrawPreviewTexture()
    {
        serializedObject.ApplyModifiedProperties();
        script.Initialize();

        EditorGUILayout.BeginHorizontal();
        {
            _nTiles = serializedObject.FindProperty("tileLayout").FindPropertyRelative("_horizontal").intValue;
            _tileSize = serializedObject.FindProperty("heightmapSize").floatValue;
            _tileMaxHeight = serializedObject.FindProperty("heightmapMaxHeight").floatValue;

            if (_previewTexture == null)
            {
                _previewTexture = new Texture2D(_previewTexturePixelSize, _previewTexturePixelSize, TextureFormat.ARGB32, false);
                _previewTexture.filterMode = FilterMode.Point;
                _previewTextureColors = new Color[_previewTexturePixelSize, _previewTexturePixelSize];
                _previewTextureUpdateRequired = true;
            }

            if (_previewTextureColorsThread == null)
            {
                _previewTextureColorsThread = new Thread(CalculateCenterHeightmapColors2D);
                _previewTextureUpdateRequired = true;
            }

            if (_previewTextureUpdateRequired && !_previewTextureUpdateInProgress && !Application.isPlaying)
            {
                CreateBlendCurvesAndColors();
                // 0 = "Heightmaps", 1 = "Textures", 2 = "Grass", 3 = "Trees", 4 = "GameObjects", 5 = "Runtime"
                SerializedProperty inspMenuIndex = serializedObject.FindProperty("inspMenuIndex");
                switch (inspMenuIndex.intValue)
                {
                    case 0:
                        _previewTextureColorsThread = new Thread(CalculateCenterHeightmapColors2D);
                        break;
                    case 1:
                        _previewTextureColorsThread = new Thread(CalculateCenterSplatmapColors2D);
                        break;
                    case 2:
                        _previewTextureColorsThread = new Thread(CalculateCenterGrassmapColors2D);
                        break;
                    case 3:
                        _previewTextureColorsThread = new Thread(CalculateCenterTreemapColors2D);
                        break;
                    case 4:
                        _previewTextureColorsThread = new Thread(CalculateGameObjectsMapColors2D);
                        break;
                    case 5:
                        break;
                    default:
                        return;
                }
                _previewTextureColorsThread.Priority = System.Threading.ThreadPriority.Lowest;
                _previewTextureColorsThread.Start();
                _previewTextureUpdateRequired = false;
                _previewTextureUpdateInProgress = true;
            }

            if (!_previewTextureUpdateInProgress)
            {
                _previewTexture = GetTexture2DFromColor2D(_previewTextureColors);
            }

            EditorGUILayout.LabelField("Preview", EditorStyles.boldLabel, GUILayout.Height(_previewTexturePixelSize * 2f), GUILayout.Width(_previewTexturePixelSize * 2f));
            guiRect = GUILayoutUtility.GetLastRect();
            guiRect.x += EditorGUIUtility.labelWidth;
            guiRect.width = _previewTexturePixelSize * 2f;
            guiRect.height = guiRect.width;
            EditorGUI.DrawPreviewTexture(guiRect, _previewTexture);
        }
        EditorGUILayout.EndHorizontal();
    }

    //------------------------------------------------------------------

    private void CalculateCenterHeightmapColors2D()
    {
        _previewTextureUpdateInProgress = true;

        float x, y, z;
        Vector3 point;
        EasyTerrain.TerrainSample terrainSample;

        float nTiles = _nTiles;
        float tileSize = _tileSize;
        float tileMaxHeight = _tileMaxHeight;

        for (int i = 0; i < _previewTexturePixelSize; i++)
        {
            for (int j = 0; j < _previewTexturePixelSize; j++)
            {
                x = nTiles * tileSize * (((float)i / (float)(_previewTexturePixelSize - 1)) - 0.5f);
                y = 0f;
                z = nTiles * tileSize * (((float)j / (float)(_previewTexturePixelSize - 1)) - 0.5f);
                point = new Vector3(x, y, z);
                terrainSample = EasyTerrain.GetTerrainSample(point);
                terrainSample.height /= tileMaxHeight;
                _previewTextureColors[i, j] = new Color(terrainSample.height, terrainSample.height, terrainSample.height);
            }
        }

        _previewTextureUpdateInProgress = false;
    }

    //------------------------------------------------------------------

    private void CalculateCenterSplatmapColors2D()
    {
        _previewTextureUpdateInProgress = true;

        float x, y, z;
        Vector3 point;
        EasyTerrain.TerrainSample terrainSample;

        float nTiles = _nTiles;
        float tileSize = _tileSize;
        float tileMaxHeight = _tileMaxHeight;

        for (int i = 0; i < _previewTexturePixelSize; i++)
        {
            for (int j = 0; j < _previewTexturePixelSize; j++)
            {
                x = nTiles * tileSize * (((float)i / (float)(_previewTexturePixelSize - 1)) - 0.5f);
                y = 0f;
                z = nTiles * tileSize * (((float)j / (float)(_previewTexturePixelSize - 1)) - 0.5f);
                point = new Vector3(x, y, z);
                terrainSample = EasyTerrain.GetTerrainSample(point);
                terrainSample.height /= tileMaxHeight;
                _previewTextureColors[i, j] = Color.black;
                for (int index = 0; index < _splatmapPreviewBlendCurves.Length; index++)
                {
                    if (_splatmapPreviewBlendColors[index] != Color.white)
                    {
                        _previewTextureColors[i, j] += _splatmapPreviewBlendColors[index] * _splatmapPreviewBlendCurves[index].Evaluate(terrainSample.height);
                    }
                    else
                    {
                        _previewTextureColors[i, j] += Color.white * _splatmapPreviewBlendCurves[index].Evaluate(terrainSample.steepness);
                    }
                }
            }
        }

        _previewTextureUpdateInProgress = false;
    }

    //------------------------------------------------------------------

    private void CalculateCenterGrassmapColors2D()
    {
        _previewTextureUpdateInProgress = true;

        float x, y, z;
        Vector3 point;
        EasyTerrain.TerrainSample terrainSample;

        float nTiles = _nTiles;
        float tileSize = _tileSize;
        float tileMaxHeight = _tileMaxHeight;

        for (int i = 0; i < _previewTexturePixelSize; i++)
        {
            for (int j = 0; j < _previewTexturePixelSize; j++)
            {
                x = nTiles * tileSize * (((float)i / (float)(_previewTexturePixelSize - 1)) - 0.5f);
                y = 0f;
                z = nTiles * tileSize * (((float)j / (float)(_previewTexturePixelSize - 1)) - 0.5f);
                point = new Vector3(x, y, z);
                terrainSample = EasyTerrain.GetTerrainSample(point);
                terrainSample.height /= tileMaxHeight;
                _previewTextureColors[i, j] = Color.black;

                Color clr = Color.green;
                for (int index = 0; index < _splatmapPreviewBlendCurves.Length; index++)
                {
                    if (_applyToSplatTexture[index])
                    {
                        if (_splatmapPreviewBlendColors[index] != Color.white)
                        {
                            _previewTextureColors[i, j] += clr * _splatmapPreviewBlendCurves[index].Evaluate(terrainSample.height);
                        }
                        else
                        {
                            _previewTextureColors[i, j] += clr * _splatmapPreviewBlendCurves[index].Evaluate(terrainSample.steepness);
                        }
                    }
                }
            }
        }

        _previewTextureUpdateInProgress = false;
    }

    //------------------------------------------------------------------

    private void CalculateCenterTreemapColors2D()
    {
        _previewTextureUpdateInProgress = true;

        float x, y, z;
        Vector3 point;
        EasyTerrain.TerrainSample terrainSample;

        float nTiles = _nTiles;
        float tileSize = _tileSize;
        float tileMaxHeight = _tileMaxHeight;

        for (int i = 0; i < _previewTexturePixelSize; i++)
        {
            for (int j = 0; j < _previewTexturePixelSize; j++)
            {
                x = nTiles * tileSize * (((float)i / (float)(_previewTexturePixelSize - 1)) - 0.5f);
                y = 0f;
                z = nTiles * tileSize * (((float)j / (float)(_previewTexturePixelSize - 1)) - 0.5f);
                point = new Vector3(x, y, z);
                terrainSample = EasyTerrain.GetTerrainSample(point);
                terrainSample.height /= tileMaxHeight;
                _previewTextureColors[i, j] = Color.black;
                float noiseValue;
                Color clr = Color.green;

                for (int index = 0; index < _splatmapPreviewBlendCurves.Length; index++)
                {
                    if (_applyToSplatTexture[index])
                    {
                        if (_splatmapPreviewBlendColors[index] != Color.white)
                        {
                            _previewTextureColors[i, j] += clr * _splatmapPreviewBlendCurves[index].Evaluate(terrainSample.height);
                        }
                        else
                        {
                            _previewTextureColors[i, j] += clr * _splatmapPreviewBlendCurves[index].Evaluate(terrainSample.steepness);
                        }
                    }

                }

                if (_useNoiseLayer)
                {
                    point.x -= _noiseOffsetX;
                    point.y = _noiseOffsetY;
                    point.z -= _noiseOffsetZ;

                    NoiseGenerator.NoiseSample noiseSample;
                    noiseSample = NoiseGenerator.Sum(
                        NoiseGenerator.methods[(int)NoiseGenerator.NoiseMethodType.Perlin3D],
                        point, _noiseFrequency, 1, 1f, 1f);
                    noiseValue = noiseSample.value;
                    noiseValue = (noiseValue + 1f) * 0.5f;

                    AnimationCurve animc = new AnimationCurve(
                                               new Keyframe(0f, 0f, 0f, 0f),
                                               new Keyframe(_threshold, 0f, 0f, 0f),
                                               new Keyframe(Mathf.Lerp(_threshold, 1f, _falloff), 1f, 0f, 0f),
                                               new Keyframe(1f, 1f, 0f, 0f));

                    _previewTextureColors[i, j] *= animc.Evaluate(noiseValue);
                }
            }
        }

        _previewTextureUpdateInProgress = false;
    }

    //------------------------------------------------------------------

    private void CalculateGameObjectsMapColors2D()
    {
        _previewTextureUpdateInProgress = true;

        float x, y, z;
        Vector3 point;
        EasyTerrain.TerrainSample terrainSample;

        float nTiles = _nTiles;
        float tileSize = _tileSize;
        float tileMaxHeight = _tileMaxHeight;

        for (int i = 0; i < _previewTexturePixelSize; i++)
        {
            for (int j = 0; j < _previewTexturePixelSize; j++)
            {
                x = nTiles * tileSize * (((float)i / (float)(_previewTexturePixelSize - 1)) - 0.5f);
                y = 0f;
                z = nTiles * tileSize * (((float)j / (float)(_previewTexturePixelSize - 1)) - 0.5f);
                point = new Vector3(x, y, z);
                terrainSample = EasyTerrain.GetTerrainSample(point);
                terrainSample.height /= tileMaxHeight;
                _previewTextureColors[i, j] = Color.black;
                float noiseValue;
                Color clr = Color.green;

                for (int index = 0; index < _splatmapPreviewBlendCurves.Length; index++)
                {
                    if (_applyToSplatTexture[index])
                    {
                        if (_splatmapPreviewBlendColors[index] != Color.white)
                        {
                            _previewTextureColors[i, j] += clr * _splatmapPreviewBlendCurves[index].Evaluate(terrainSample.height);
                        }
                        else
                        {
                            _previewTextureColors[i, j] += clr * _splatmapPreviewBlendCurves[index].Evaluate(terrainSample.steepness);
                        }
                    }

                }

                if (_useNoiseLayer)
                {
                    point.x -= _noiseOffsetX;
                    point.y = _noiseOffsetY;
                    point.z -= _noiseOffsetZ;

                    NoiseGenerator.NoiseSample noiseSample;
                    noiseSample = NoiseGenerator.Sum(
                        NoiseGenerator.methods[(int)NoiseGenerator.NoiseMethodType.Perlin3D],
                        point, _noiseFrequency, 1, 1f, 1f);
                    noiseValue = noiseSample.value;
                    noiseValue = (noiseValue + 1f) * 0.5f;

                    AnimationCurve animc = new AnimationCurve(
                                               new Keyframe(0f, 0f, 0f, 0f),
                                               new Keyframe(_threshold, 0f, 0f, 0f),
                                               new Keyframe(Mathf.Lerp(_threshold, 1f, _falloff), 1f, 0f, 0f),
                                               new Keyframe(1f, 1f, 0f, 0f));

                    _previewTextureColors[i, j] *= animc.Evaluate(noiseValue);
                }
            }
        }

        _previewTextureUpdateInProgress = false;
    }

    //------------------------------------------------------------------

    private void CreateBlendCurvesAndColors()
    {
        SerializedProperty splatTexturesSteepness = serializedObject.FindProperty("splatTexturesSteepness");
        SerializedProperty splatTexturesHeightness = serializedObject.FindProperty("splatTexturesHeightness");

        _splatmapPreviewBlendCurves = new AnimationCurve[splatTexturesSteepness.arraySize + splatTexturesHeightness.arraySize];
        _splatmapPreviewBlendColors = new Color[splatTexturesSteepness.arraySize + splatTexturesHeightness.arraySize];
        for (int i = 0; i < splatTexturesHeightness.arraySize; i++)
        {
            _splatmapPreviewBlendCurves[i] = splatTexturesHeightness.GetArrayElementAtIndex(i).FindPropertyRelative("blendCurve").animationCurveValue;
            _splatmapPreviewBlendColors[i] = _colors[i];
        }
        for (int i = 0; i < splatTexturesSteepness.arraySize; i++)
        {
            _splatmapPreviewBlendCurves[i + splatTexturesHeightness.arraySize] = splatTexturesSteepness.GetArrayElementAtIndex(i).FindPropertyRelative("blendCurve").animationCurveValue;
            _splatmapPreviewBlendColors[i + splatTexturesHeightness.arraySize] = Color.white; //_colors[_colors.Length - i - 1];
        }
    }

    //------------------------------------------------------------------

    private Texture2D GetTexture2DFromColor2D(Color[,] textureColors)
    {
        Texture2D newTexture2D = new Texture2D(_previewTexturePixelSize, _previewTexturePixelSize, TextureFormat.ARGB32, false);
        newTexture2D.filterMode = FilterMode.Point;
        for (int i = 0; i < _previewTexturePixelSize; i++)
        {
            for (int j = 0; j < _previewTexturePixelSize; j++)
            {
                newTexture2D.SetPixel(i, j, textureColors[i, j]);
            }
        }
        newTexture2D.Apply();
        return newTexture2D;
    }

    //------------------------------------------------------------------

    void ApplyToSplatTextures(ref SerializedProperty applyToSplatTexture)
    {
        EditorGUILayout.BeginVertical();
        {
            SerializedProperty splatTexturesHeightness = serializedObject.FindProperty("splatTexturesHeightness");
            SerializedProperty splatTexturesSteepness = serializedObject.FindProperty("splatTexturesSteepness");
            while (applyToSplatTexture.arraySize < (splatTexturesHeightness.arraySize + splatTexturesSteepness.arraySize))
            {
                applyToSplatTexture.arraySize++;
                applyToSplatTexture.GetArrayElementAtIndex(applyToSplatTexture.arraySize - 1).boolValue = false;
            }
            while (applyToSplatTexture.arraySize > (splatTexturesHeightness.arraySize + splatTexturesSteepness.arraySize))
            {
                applyToSplatTexture.arraySize--;
            }
            float fieldwidth = EditorGUIUtility.fieldWidth * 0.8f;
            //
            EditorGUILayout.BeginHorizontal();
            {
                EditorGUILayout.LabelField("", GUILayout.Width(fieldwidth * 0.5f));
                int splatindex = 0;
                SerializedProperty diffuseTextureProperty;
                for (int h = 0; h < splatTexturesHeightness.arraySize; h++)
                {
                    EditorGUILayout.BeginVertical();
                    {
                        EditorGUILayout.BeginHorizontal();
                        {
                            EditorGUILayout.LabelField("#" + splatindex, GUILayout.Width(fieldwidth * 0.5f));
                            EditorGUILayout.PropertyField(applyToSplatTexture.GetArrayElementAtIndex(splatindex), GUIContent.none, GUILayout.Width(fieldwidth * 0.5f));
                        }
                        EditorGUILayout.EndHorizontal();
                        diffuseTextureProperty = splatTexturesHeightness.GetArrayElementAtIndex(h).FindPropertyRelative("diffuseTexture");
                        guiRect = EditorGUILayout.GetControlRect(false, GUILayout.Height(fieldwidth), GUILayout.Width(fieldwidth));
                        EditorGUI.DrawPreviewTexture(guiRect, diffuseTextureProperty.objectReferenceValue as Texture2D);
                        splatindex++;
                    }
                    EditorGUILayout.EndVertical();
                    //
                    if ((h + 1) % 4 == 0)
                    {
                        EditorGUILayout.EndHorizontal();
                        EditorGUILayout.BeginHorizontal();
                        EditorGUILayout.LabelField("", GUILayout.Width(fieldwidth * 0.5f));
                    }
                }
                for (int s = 0; s < splatTexturesSteepness.arraySize; s++)
                {
                    EditorGUILayout.BeginVertical();
                    {
                        EditorGUILayout.BeginHorizontal();
                        {
                            EditorGUILayout.LabelField("#" + splatindex, GUILayout.Width(fieldwidth * 0.5f));
                            EditorGUILayout.PropertyField(applyToSplatTexture.GetArrayElementAtIndex(splatindex), GUIContent.none, GUILayout.Width(fieldwidth * 0.5f));
                        }
                        EditorGUILayout.EndHorizontal();
                        diffuseTextureProperty = splatTexturesSteepness.GetArrayElementAtIndex(s).FindPropertyRelative("diffuseTexture");
                        guiRect = EditorGUILayout.GetControlRect(false, GUILayout.Height(fieldwidth), GUILayout.Width(fieldwidth));
                        EditorGUI.DrawPreviewTexture(guiRect, diffuseTextureProperty.objectReferenceValue as Texture2D);
                        splatindex++;
                    }
                    EditorGUILayout.EndVertical();
                }
            }
            EditorGUILayout.EndHorizontal();
        }
        EditorGUILayout.EndVertical();
    }

    //------------------------------------------------------------------
}