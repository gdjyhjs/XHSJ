using UnityEngine;
using UnityEditor;
using System.Threading;
using MouseSoftware;

public partial class EasyTerrainEditor : Editor
{
    //------------------------------------------------------------------

    void GameObjectsMenu()
    {
        EditorGUILayout.BeginVertical("Box");
        {
            EditorGUILayout.Space();

            SerializedProperty playerStartupFreeRadius = serializedObject.FindProperty("playerStartupFreeRadius");
            EditorGUILayout.PropertyField(playerStartupFreeRadius, new GUIContent("Player Free Radius"));

            EditorGUILayout.Space();

            SerializedProperty gameObjectsProperties = serializedObject.FindProperty("gameObjectsProperties");
            //EditorGUILayout.PropertyField(gameObjectsProperties, true);

            EditorGUILayout.BeginHorizontal();
            {
                EditorGUILayout.LabelField("Prototypes: " + gameObjectsProperties.arraySize, EditorStyles.boldLabel, GUILayout.Width(84));

                GUI.enabled = GUI_Enabled() && (gameObjectsProperties.arraySize >= 0);
                if (GUILayout.Button("+"))
                {
                    gameObjectsProperties.arraySize++;
                    EasyTerrain.PropertiesGameObject gameObjectPropertiesDefault = new EasyTerrain.PropertiesGameObject();
                    if (gameObjectsProperties.arraySize > 1)
                    {
                        gameObjectPropertiesDefault.prototype = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("prototype").objectReferenceValue as GameObject;
                        gameObjectPropertiesDefault.density = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("density").floatValue;
                        gameObjectPropertiesDefault.preventMeshOverlap = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("preventMeshOverlap").boolValue;
                        gameObjectPropertiesDefault.minScale = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("minScale").floatValue;
                        gameObjectPropertiesDefault.maxScale = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("maxScale").floatValue;
                        gameObjectPropertiesDefault.minSteepness = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("minSteepness").floatValue;
                        gameObjectPropertiesDefault.maxSteepness = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("maxSteepness").floatValue;
                        gameObjectPropertiesDefault.forceHorizontalPlacement = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("forceHorizontalPlacement").boolValue;
                        gameObjectPropertiesDefault.useNoiseLayer = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("useNoiseLayer").boolValue;
                        gameObjectPropertiesDefault.noiseSettings.frequency = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("noiseSettings").FindPropertyRelative("frequency").floatValue;
                        gameObjectPropertiesDefault.noiseSettings.octaves = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("noiseSettings").FindPropertyRelative("octaves").intValue;
                        gameObjectPropertiesDefault.noiseSettings.lacunarity = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("noiseSettings").FindPropertyRelative("lacunarity").floatValue;
                        gameObjectPropertiesDefault.noiseSettings.persistence = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("noiseSettings").FindPropertyRelative("persistence").floatValue;
                        gameObjectPropertiesDefault.noiseSettings.threshold = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("noiseSettings").FindPropertyRelative("threshold").floatValue;
                        gameObjectPropertiesDefault.noiseSettings.falloff = gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 2).FindPropertyRelative("noiseSettings").FindPropertyRelative("falloff").floatValue;
                    }
                    else
                    {
                        gameObjectPropertiesDefault.noiseSettings.type = NoiseGenerator.NoiseMethodType.Perlin3D;
                        gameObjectPropertiesDefault.noiseSettings.frequency = 0.002f;
                        gameObjectPropertiesDefault.noiseSettings.octaves = 1;
                        gameObjectPropertiesDefault.noiseSettings.lacunarity = 2f;
                        gameObjectPropertiesDefault.noiseSettings.persistence = 0.5f;
                        gameObjectPropertiesDefault.noiseSettings.threshold = 0.5f;
                        gameObjectPropertiesDefault.noiseSettings.falloff = 0.5f;
                    }
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("density").floatValue = gameObjectPropertiesDefault.density;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("preventMeshOverlap").boolValue = gameObjectPropertiesDefault.preventMeshOverlap;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("minScale").floatValue = gameObjectPropertiesDefault.minScale;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("maxScale").floatValue = gameObjectPropertiesDefault.maxScale;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("minSteepness").floatValue = gameObjectPropertiesDefault.minSteepness;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("maxSteepness").floatValue = gameObjectPropertiesDefault.maxSteepness;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("forceHorizontalPlacement").boolValue = gameObjectPropertiesDefault.forceHorizontalPlacement;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("prototype").objectReferenceValue = gameObjectPropertiesDefault.prototype;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("useNoiseLayer").boolValue = gameObjectPropertiesDefault.useNoiseLayer;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("type").enumValueIndex = (int)gameObjectPropertiesDefault.noiseSettings.type;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("frequency").floatValue = gameObjectPropertiesDefault.noiseSettings.frequency;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("octaves").intValue = gameObjectPropertiesDefault.noiseSettings.octaves;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("lacunarity").floatValue = gameObjectPropertiesDefault.noiseSettings.lacunarity;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("persistence").floatValue = gameObjectPropertiesDefault.noiseSettings.persistence;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("threshold").floatValue = gameObjectPropertiesDefault.noiseSettings.threshold;
                    gameObjectsProperties.GetArrayElementAtIndex(gameObjectsProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("falloff").floatValue = gameObjectPropertiesDefault.noiseSettings.falloff;
                     SerializedProperty inspGameObjectSelectorIndex = serializedObject.FindProperty("inspGameObjectSelectorIndex");
                    inspGameObjectSelectorIndex.intValue = gameObjectsProperties.arraySize - 1;
                }
                GUI.enabled = GUI_Enabled() && (gameObjectsProperties.arraySize > 0);
                if (GUILayout.Button("-"))
                {
                    gameObjectsProperties.arraySize--;
                }
                GUI_Enabled();
            }
            EditorGUILayout.EndHorizontal();

            if (gameObjectsProperties.arraySize > 0)
            {
                SerializedProperty inspGameObjectSelectorIndex = serializedObject.FindProperty("inspGameObjectSelectorIndex");
                inspGameObjectSelectorIndex.intValue = Mathf.Clamp(inspGameObjectSelectorIndex.intValue, 0, gameObjectsProperties.arraySize - 1);
                string[] menuTexts = new string[gameObjectsProperties.arraySize];
                for (int j = 0; j < gameObjectsProperties.arraySize; j++)
                {
                    menuTexts[j] = "#" + j;
                }
                EditorGUILayout.Space();
                inspGameObjectSelectorIndex.intValue = GUILayout.SelectionGrid(inspGameObjectSelectorIndex.intValue, menuTexts, gameObjectsProperties.arraySize);
                EditorGUILayout.Space();

                int i = inspGameObjectSelectorIndex.intValue;

                SerializedProperty prototype = gameObjectsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("prototype");

                EditorGUILayout.BeginHorizontal();
                {
                    EditorGUILayout.BeginVertical();
                    {
                        float labelWidth = 66f;
                        EditorGUILayout.PropertyField(prototype, GUIContent.none);
                        EditorGUILayout.BeginHorizontal();
                        {
                            SerializedProperty density = gameObjectsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("density");
                            EditorGUILayout.LabelField("Density", GUILayout.MaxWidth(labelWidth));
                            EditorGUILayout.PropertyField(density, GUIContent.none);
                        }
                        EditorGUILayout.EndHorizontal();
                        EditorGUILayout.BeginHorizontal();
                        {
                            SerializedProperty preventMeshOverlap = gameObjectsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("preventMeshOverlap");
                            //EditorGUILayout.LabelField("", GUILayout.Width(labelWidth));
                            preventMeshOverlap.boolValue = EditorGUILayout.ToggleLeft("Prevent Mesh Overlap", preventMeshOverlap.boolValue, GUILayout.MinWidth(0));
                        }
                        EditorGUILayout.EndHorizontal();
                        //EditorGUILayout.BeginHorizontal();
                        //{
                        //    SerializedProperty minDistance = trees.GetArrayElementAtIndex(i).FindPropertyRelative("minDistance");
                        //    EditorGUILayout.LabelField("minDistance", GUILayout.Width(labelWidth*2f));
                        //    GUI.enabled = false;
                        //    EditorGUILayout.FloatField(minDistance.floatValue);
                        //    GUI_Enabled();
                        //}
                        //EditorGUILayout.EndHorizontal();
                        EditorGUILayout.BeginHorizontal();
                        {
                            SerializedProperty minScale = gameObjectsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("minScale");
                            SerializedProperty maxScale = gameObjectsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("maxScale");
                            float minScaleValue = minScale.floatValue;
                            float maxScaleValue = maxScale.floatValue;
                            EditorGUILayout.LabelField("Scale", GUILayout.MaxWidth(labelWidth));
                            minScaleValue = EditorGUILayout.FloatField(minScaleValue, GUILayout.MaxWidth(46), GUILayout.MinWidth(28));
                            EditorGUILayout.MinMaxSlider(ref minScaleValue, ref maxScaleValue, 0f, 20f, GUILayout.MinWidth(0));
                            maxScaleValue = EditorGUILayout.FloatField(maxScaleValue, GUILayout.MaxWidth(46), GUILayout.MinWidth(28));
                            minScale.floatValue = minScaleValue;
                            maxScale.floatValue = maxScaleValue;
                        }
                        EditorGUILayout.EndHorizontal();
                        EditorGUILayout.BeginHorizontal();
                        {
                            SerializedProperty minSteepness = gameObjectsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("minSteepness");
                            SerializedProperty maxSteepness = gameObjectsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("maxSteepness");
                            float minSteepnessValue = minSteepness.floatValue;
                            float maxSteepnessValue = maxSteepness.floatValue;
                            EditorGUILayout.LabelField("Steepness", GUILayout.MaxWidth(labelWidth));
                            minSteepnessValue = EditorGUILayout.FloatField(minSteepnessValue, GUILayout.MaxWidth(46), GUILayout.MinWidth(28));
                            EditorGUILayout.MinMaxSlider(ref minSteepnessValue, ref maxSteepnessValue, 0f, 90f, GUILayout.MinWidth(0));
                            maxSteepnessValue = EditorGUILayout.FloatField(maxSteepnessValue, GUILayout.MaxWidth(46), GUILayout.MinWidth(28));
                            minSteepness.floatValue = minSteepnessValue;
                            maxSteepness.floatValue = maxSteepnessValue;
                        }
                        EditorGUILayout.EndHorizontal();
                        EditorGUILayout.BeginHorizontal();
                        {
                            SerializedProperty forceHorizontalPlacement = gameObjectsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("forceHorizontalPlacement");
                            forceHorizontalPlacement.boolValue = EditorGUILayout.ToggleLeft("Force Horizontal", forceHorizontalPlacement.boolValue, GUILayout.MinWidth(140f));
                        }
                        EditorGUILayout.EndHorizontal();
                    }
                    EditorGUILayout.EndVertical();

                    EditorGUILayout.BeginVertical();
                    {
                        guiRect = EditorGUILayout.GetControlRect(false, GUILayout.Height(100), GUILayout.Width(100));
                        if (prototype.objectReferenceValue == true)
                        {
                            Texture2D pTexture = AssetPreview.GetAssetPreview(prototype.objectReferenceValue as GameObject);
                            if (pTexture != null)
                            {
                                EditorGUI.DrawPreviewTexture(guiRect, pTexture);
                            }
                        }
                    }
                    EditorGUILayout.EndVertical();
                }
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.Space();

                EditorGUILayout.LabelField("Apply to Splat Textures:");
                SerializedProperty applyToSplatTexture = gameObjectsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("applyToSplatTexture");
                ApplyToSplatTextures(ref applyToSplatTexture);

                EditorGUILayout.Space();

                SerializedProperty useNoiseLayer = gameObjectsProperties.GetArrayElementAtIndex(inspGameObjectSelectorIndex.intValue).FindPropertyRelative("useNoiseLayer");
                useNoiseLayer.boolValue = EditorGUILayout.ToggleLeft(new GUIContent("Use noise layer (Perlin3D)"), useNoiseLayer.boolValue);

                if (useNoiseLayer.boolValue)
                {
                    SerializedProperty noiseSettings = gameObjectsProperties.GetArrayElementAtIndex(inspGameObjectSelectorIndex.intValue).FindPropertyRelative("noiseSettings");
                    SerializedProperty noiseSettings_type = noiseSettings.FindPropertyRelative("type");
                    noiseSettings_type.enumValueIndex = (int)NoiseGenerator.NoiseMethodType.Perlin3D;
                    //EditorGUILayout.PropertyField (noiseSettings_type, new GUIContent("Type"));

                    SerializedProperty noiseSettings_offsetX = noiseSettings.FindPropertyRelative("offsetX");
                    //EditorGUILayout.PropertyField (noiseSettings_offsetX, new GUIContent("Offset X"));
                    noiseSettings_offsetX.floatValue = 0f;

                    SerializedProperty noiseSettings_offsetY = noiseSettings.FindPropertyRelative("offsetY");
                    //EditorGUILayout.PropertyField (noiseSettings_offsetY, new GUIContent("Offset Y"));
                    EditorGUILayout.PropertyField(noiseSettings_offsetY, new GUIContent("Seed"));

                    SerializedProperty noiseSettings_offsetZ = noiseSettings.FindPropertyRelative("offsetZ");
                    //EditorGUILayout.PropertyField (noiseSettings_offsetZ, new GUIContent("Offset Z"));
                    noiseSettings_offsetZ.floatValue = 0f;

                    SerializedProperty noiseSettings_frequency = noiseSettings.FindPropertyRelative("frequency");
                    //noiseSettings_frequency.floatValue = EditorGUILayout.Slider("Frequency",noiseSettings_frequency.floatValue,0.0005f, 0.1f);
                    float scale = Mathf.RoundToInt(1f / noiseSettings_frequency.floatValue);
                    scale = EditorGUILayout.Slider(new GUIContent("Scale"), scale, 1f, 2000f);
                    noiseSettings_frequency.floatValue = 1f / scale;

                    SerializedProperty threshold = noiseSettings.FindPropertyRelative("threshold");
                    EditorGUILayout.PropertyField(threshold, new GUIContent("Threshold"));
                    SerializedProperty falloff = noiseSettings.FindPropertyRelative("falloff");
                    EditorGUILayout.PropertyField(falloff, new GUIContent("Smoothness"));

                    SerializedProperty noiseSettings_octaves = noiseSettings.FindPropertyRelative("octaves");
                    noiseSettings_octaves.intValue = 1;
                    SerializedProperty noiseSettings_lacunarity = noiseSettings.FindPropertyRelative("lacunarity");
                    noiseSettings_lacunarity.floatValue = 1;
                    SerializedProperty noiseSettings_persistence = noiseSettings.FindPropertyRelative("persistence");
                    noiseSettings_persistence.floatValue = 1;
                    //SerializedProperty noiseSettings_adjustmentCurve = noiseSettings.FindPropertyRelative("adjustmentCurve");
                    //noiseSettings_adjustmentCurve.animationCurveValue = AnimationCurve.Linear(0f, 0f, 1f, 1f);
                }

                EditorGUILayout.Space();
                EditorGUILayout.Space();

                _applyToSplatTexture = new bool[applyToSplatTexture.arraySize];
                for (int splatindex = 0; splatindex < applyToSplatTexture.arraySize; splatindex++)
                {
                    _applyToSplatTexture[splatindex] = applyToSplatTexture.GetArrayElementAtIndex(splatindex).boolValue;
                }
                _useNoiseLayer = useNoiseLayer.boolValue;
                _noiseFrequency = gameObjectsProperties.GetArrayElementAtIndex(inspGameObjectSelectorIndex.intValue).FindPropertyRelative("noiseSettings").FindPropertyRelative("frequency").floatValue;
                _noiseOffsetX = gameObjectsProperties.GetArrayElementAtIndex(inspGameObjectSelectorIndex.intValue).FindPropertyRelative("noiseSettings").FindPropertyRelative("offsetX").floatValue;
                _noiseOffsetY = gameObjectsProperties.GetArrayElementAtIndex(inspGameObjectSelectorIndex.intValue).FindPropertyRelative("noiseSettings").FindPropertyRelative("offsetY").floatValue;
                _noiseOffsetZ = gameObjectsProperties.GetArrayElementAtIndex(inspGameObjectSelectorIndex.intValue).FindPropertyRelative("noiseSettings").FindPropertyRelative("offsetZ").floatValue;
                _threshold = gameObjectsProperties.GetArrayElementAtIndex(inspGameObjectSelectorIndex.intValue).FindPropertyRelative("noiseSettings").FindPropertyRelative("threshold").floatValue;
                _falloff = gameObjectsProperties.GetArrayElementAtIndex(inspGameObjectSelectorIndex.intValue).FindPropertyRelative("noiseSettings").FindPropertyRelative("falloff").floatValue;

                DrawPreviewTexture();

            } // if (gameObjectsProperties.arraySize > 0)

            EditorGUILayout.Space();
        } //        EditorGUILayout.BeginVertical ("Box");
        EditorGUILayout.EndVertical();
    }
    // void GameObjectsMenu ()

    //------------------------------------------------------------------
}