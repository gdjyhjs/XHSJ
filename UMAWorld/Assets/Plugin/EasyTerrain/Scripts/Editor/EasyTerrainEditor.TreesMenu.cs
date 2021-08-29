using UnityEngine;
using UnityEditor;
using System.Threading;
using MouseSoftware;


public partial class EasyTerrainEditor : Editor
{
    //------------------------------------------------------------------

    void TreesMenu()
    {
        EditorGUILayout.BeginVertical("Box");
        {
            EditorGUILayout.Space();

            SerializedProperty drawTreesAndFoliage = serializedObject.FindProperty("drawTreesAndFoliage");
            EditorGUILayout.PropertyField(drawTreesAndFoliage, new GUIContent("Draw Trees & Foliage"));

            EditorGUILayout.Space();


            SerializedProperty treeDistance = serializedObject.FindProperty("treeDistance");
            SerializedProperty autoTreeDistance = serializedObject.FindProperty("autoTreeDistance");
            EditorGUILayout.BeginHorizontal();
            {
                GUI.enabled = GUI_Enabled() && !autoTreeDistance.boolValue;
                EditorGUILayout.PropertyField(treeDistance, new GUIContent("Max Tree Distance"));
                GUI.enabled = GUI_Enabled();
                autoTreeDistance.boolValue = EditorGUILayout.ToggleLeft(new GUIContent("auto"), autoTreeDistance.boolValue, GUILayout.MaxWidth(48));
            }
            EditorGUILayout.EndHorizontal();

            SerializedProperty treeBillboardDistance = serializedObject.FindProperty("treeBillboardDistance");
            EditorGUILayout.PropertyField(treeBillboardDistance, new GUIContent("Billboard Distance"));

            SerializedProperty treeCrossFadeLength = serializedObject.FindProperty("treeCrossFadeLength");
            EditorGUILayout.PropertyField(treeCrossFadeLength, new GUIContent("Cross Fade Length"));

            EditorGUILayout.Space();

            SerializedProperty playerStartupFreeRadius = serializedObject.FindProperty("playerStartupFreeRadius");
            EditorGUILayout.PropertyField(playerStartupFreeRadius, new GUIContent("Player Free Radius"));

            EditorGUILayout.Space();

            SerializedProperty treesProperties = serializedObject.FindProperty("treesProperties");
            EditorGUILayout.BeginHorizontal();
            {
                EditorGUILayout.LabelField("Prototypes: " + treesProperties.arraySize, EditorStyles.boldLabel, GUILayout.Width(84));

                GUI.enabled = GUI_Enabled() && (treesProperties.arraySize >= 0);
                if (GUILayout.Button("+"))
                {
                    treesProperties.arraySize++;
                    EasyTerrain.PropertiesTree treePropertiesDefault = new EasyTerrain.PropertiesTree();
                    if (treesProperties.arraySize > 1)
                    {
                        treePropertiesDefault.prototype = treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 2).FindPropertyRelative("prototype").objectReferenceValue as GameObject;
                        treePropertiesDefault.density = treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 2).FindPropertyRelative("density").floatValue;
                        treePropertiesDefault.useNoiseLayer = treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 2).FindPropertyRelative("useNoiseLayer").boolValue;
                        treePropertiesDefault.noiseSettings.type = NoiseGenerator.NoiseMethodType.Perlin3D;
                        treePropertiesDefault.noiseSettings.frequency = treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 2).FindPropertyRelative("noiseSettings").FindPropertyRelative("frequency").floatValue;
                        treePropertiesDefault.noiseSettings.octaves = treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 2).FindPropertyRelative("noiseSettings").FindPropertyRelative("octaves").intValue;
                        treePropertiesDefault.noiseSettings.lacunarity = treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 2).FindPropertyRelative("noiseSettings").FindPropertyRelative("lacunarity").floatValue;
                        treePropertiesDefault.noiseSettings.persistence = treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 2).FindPropertyRelative("noiseSettings").FindPropertyRelative("persistence").floatValue;
                        treePropertiesDefault.noiseSettings.threshold = treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 2).FindPropertyRelative("noiseSettings").FindPropertyRelative("threshold").floatValue;
                        treePropertiesDefault.noiseSettings.falloff = treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 2).FindPropertyRelative("noiseSettings").FindPropertyRelative("falloff").floatValue;
                    }
                    else
                    {
                        treePropertiesDefault.noiseSettings.type = NoiseGenerator.NoiseMethodType.Perlin3D;
                        treePropertiesDefault.noiseSettings.frequency = 0.002f;
                        treePropertiesDefault.noiseSettings.octaves = 1;
                        treePropertiesDefault.noiseSettings.lacunarity = 2f;
                        treePropertiesDefault.noiseSettings.persistence = 0.5f;
                        treePropertiesDefault.noiseSettings.threshold = 0.5f;
                        treePropertiesDefault.noiseSettings.falloff = 0.5f;
                    }
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("bendFactor").floatValue = treePropertiesDefault.bendFactor;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("density").floatValue = treePropertiesDefault.density;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("preventMeshOverlap").boolValue = treePropertiesDefault.preventMeshOverlap;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("color1").colorValue = treePropertiesDefault.color1;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("color2").colorValue = treePropertiesDefault.color2;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("minScale").floatValue = treePropertiesDefault.minScale;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("maxScale").floatValue = treePropertiesDefault.maxScale;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("prototype").objectReferenceValue = treePropertiesDefault.prototype;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("useNoiseLayer").boolValue = treePropertiesDefault.useNoiseLayer;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("type").enumValueIndex = (int)treePropertiesDefault.noiseSettings.type;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("frequency").floatValue = treePropertiesDefault.noiseSettings.frequency;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("octaves").intValue = treePropertiesDefault.noiseSettings.octaves;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("lacunarity").floatValue = treePropertiesDefault.noiseSettings.lacunarity;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("persistence").floatValue = treePropertiesDefault.noiseSettings.persistence;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("threshold").floatValue = treePropertiesDefault.noiseSettings.threshold;
                    treesProperties.GetArrayElementAtIndex(treesProperties.arraySize - 1).FindPropertyRelative("noiseSettings").FindPropertyRelative("falloff").floatValue = treePropertiesDefault.noiseSettings.falloff;
                    SerializedProperty inspTreeSelectorIndex = serializedObject.FindProperty("inspTreeSelectorIndex");
                    inspTreeSelectorIndex.intValue = treesProperties.arraySize - 1;
                }
                GUI.enabled = GUI_Enabled() && (treesProperties.arraySize > 0);
                if (GUILayout.Button("-"))
                {
                    treesProperties.arraySize--;
                }
                GUI_Enabled();
            }
            EditorGUILayout.EndHorizontal();

            if (treesProperties.arraySize > 0)
            {
                SerializedProperty inspTreeSelectorIndex = serializedObject.FindProperty("inspTreeSelectorIndex");
                inspTreeSelectorIndex.intValue = Mathf.Clamp(inspTreeSelectorIndex.intValue, 0, treesProperties.arraySize - 1);
                string[] menuTexts = new string[treesProperties.arraySize];
                for (int j = 0; j < treesProperties.arraySize; j++)
                {
                    menuTexts[j] = "#" + j;
                }
                EditorGUILayout.Space();
                inspTreeSelectorIndex.intValue = GUILayout.SelectionGrid(inspTreeSelectorIndex.intValue, menuTexts, treesProperties.arraySize);
                EditorGUILayout.Space();

                int i = inspTreeSelectorIndex.intValue;

                SerializedProperty prototype = treesProperties.GetArrayElementAtIndex(i).FindPropertyRelative("prototype");

                EditorGUILayout.BeginHorizontal();
                {
                    EditorGUILayout.BeginVertical();
                    {
                        EditorGUILayout.PropertyField(prototype, GUIContent.none);
                        float labelWidth = 44f;
                        EditorGUILayout.BeginHorizontal();
                        {
                            SerializedProperty density = treesProperties.GetArrayElementAtIndex(i).FindPropertyRelative("density");
                            EditorGUILayout.LabelField("Density", GUILayout.Width(labelWidth));
                            EditorGUILayout.PropertyField(density, GUIContent.none);
                        }
                        EditorGUILayout.EndHorizontal();
                        EditorGUILayout.BeginHorizontal();
                        {
                            SerializedProperty preventMeshOverlap = treesProperties.GetArrayElementAtIndex(i).FindPropertyRelative("preventMeshOverlap");
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
                        EditorGUILayout.Space();
                        EditorGUILayout.BeginHorizontal();
                        {
                            SerializedProperty color1 = treesProperties.GetArrayElementAtIndex(i).FindPropertyRelative("color1");
                            SerializedProperty color2 = treesProperties.GetArrayElementAtIndex(i).FindPropertyRelative("color2");
                            EditorGUILayout.LabelField("Colors", GUILayout.Width(labelWidth));
                            EditorGUILayout.PropertyField(color1, GUIContent.none, GUILayout.MinWidth(32));
                            EditorGUILayout.PropertyField(color2, GUIContent.none, GUILayout.MinWidth(32));
                        }
                        EditorGUILayout.EndHorizontal();
                        EditorGUILayout.BeginHorizontal();
                        {
                            SerializedProperty minScale = treesProperties.GetArrayElementAtIndex(i).FindPropertyRelative("minScale");
                            SerializedProperty maxScale = treesProperties.GetArrayElementAtIndex(i).FindPropertyRelative("maxScale");
                            float minScaleValue = minScale.floatValue;
                            float maxScaleValue = maxScale.floatValue;
                            EditorGUILayout.LabelField("Scale", GUILayout.Width(labelWidth));
                            minScaleValue = EditorGUILayout.FloatField(minScaleValue, GUILayout.MaxWidth(48), GUILayout.MinWidth(32));
                            EditorGUILayout.MinMaxSlider(ref minScaleValue, ref maxScaleValue, 0f, 4f, GUILayout.MinWidth(0));
                            maxScaleValue = EditorGUILayout.FloatField(maxScaleValue, GUILayout.MaxWidth(48), GUILayout.MinWidth(32));
                            minScale.floatValue = minScaleValue;
                            maxScale.floatValue = maxScaleValue;
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
                SerializedProperty applyToSplatTexture = treesProperties.GetArrayElementAtIndex(i).FindPropertyRelative("applyToSplatTexture");
                ApplyToSplatTextures(ref applyToSplatTexture);

                EditorGUILayout.Space();

                SerializedProperty useNoiseLayer = treesProperties.GetArrayElementAtIndex(inspTreeSelectorIndex.intValue).FindPropertyRelative("useNoiseLayer");
                useNoiseLayer.boolValue = EditorGUILayout.ToggleLeft(new GUIContent("Use noise layer (Perlin3D)"), useNoiseLayer.boolValue);

                if (useNoiseLayer.boolValue)
                {
                    SerializedProperty noiseSettings = treesProperties.GetArrayElementAtIndex(inspTreeSelectorIndex.intValue).FindPropertyRelative("noiseSettings");
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
                    //SerializedProperty noiseSettings_adjustmentCurve = noiseSettings.FindPropertyRelative ("adjustmentCurve");
                    //noiseSettings_adjustmentCurve.animationCurveValue = AnimationCurve.Linear (0f, 0f, 1f, 1f);
                }

                EditorGUILayout.Space();
                EditorGUILayout.Space();

                _applyToSplatTexture = new bool[applyToSplatTexture.arraySize];
                for (int splatindex = 0; splatindex < applyToSplatTexture.arraySize; splatindex++)
                {
                    _applyToSplatTexture[splatindex] = applyToSplatTexture.GetArrayElementAtIndex(splatindex).boolValue;
                }
                _useNoiseLayer = useNoiseLayer.boolValue;
                _noiseFrequency = treesProperties.GetArrayElementAtIndex(inspTreeSelectorIndex.intValue).FindPropertyRelative("noiseSettings").FindPropertyRelative("frequency").floatValue;
                _noiseOffsetX = treesProperties.GetArrayElementAtIndex(inspTreeSelectorIndex.intValue).FindPropertyRelative("noiseSettings").FindPropertyRelative("offsetX").floatValue;
                _noiseOffsetY = treesProperties.GetArrayElementAtIndex(inspTreeSelectorIndex.intValue).FindPropertyRelative("noiseSettings").FindPropertyRelative("offsetY").floatValue;
                _noiseOffsetZ = treesProperties.GetArrayElementAtIndex(inspTreeSelectorIndex.intValue).FindPropertyRelative("noiseSettings").FindPropertyRelative("offsetZ").floatValue;
                _threshold = treesProperties.GetArrayElementAtIndex(inspTreeSelectorIndex.intValue).FindPropertyRelative("noiseSettings").FindPropertyRelative("threshold").floatValue;
                _falloff = treesProperties.GetArrayElementAtIndex(inspTreeSelectorIndex.intValue).FindPropertyRelative("noiseSettings").FindPropertyRelative("falloff").floatValue;

                DrawPreviewTexture();
            } // if (treesProperties.arraySize > 0)

            EditorGUILayout.Space();
        } // 		EditorGUILayout.BeginVertical ("Box");
        EditorGUILayout.EndVertical();

    }
    // void treesMenu ()

    //------------------------------------------------------------------

}