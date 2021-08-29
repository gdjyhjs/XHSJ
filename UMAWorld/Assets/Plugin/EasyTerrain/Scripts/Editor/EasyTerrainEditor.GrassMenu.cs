using UnityEngine;
using UnityEditor;
using System.Threading;
using MouseSoftware;

public partial class EasyTerrainEditor : Editor
{
    private Texture2D _grassmapPreview;

    //------------------------------------------------------------------

    void GrassMenu()
    {
        EditorGUILayout.BeginVertical("Box");
        {
            EditorGUILayout.Space();

            SerializedProperty drawTreesAndFoliage = serializedObject.FindProperty("drawTreesAndFoliage");
            EditorGUILayout.PropertyField(drawTreesAndFoliage, new GUIContent("Draw Trees & Foliage"));

            EditorGUILayout.Space();

            SerializedProperty detailResolution = serializedObject.FindProperty("detailResolution").FindPropertyRelative("_resolutionEnum");
            EditorGUILayout.PropertyField(detailResolution, new GUIContent("Resolution"));

            EditorGUILayout.Space();

            SerializedProperty detailResolutionIntPerPatch = serializedObject.FindProperty("detailResolutionIntPerPatch");
            EditorGUILayout.PropertyField(detailResolutionIntPerPatch, new GUIContent("Patch Size"));

            SerializedProperty detailObjectDensity = serializedObject.FindProperty("detailObjectDensity");
            EditorGUILayout.PropertyField(detailObjectDensity, new GUIContent("Default Density"));

            SerializedProperty detailObjectDistance = serializedObject.FindProperty("detailObjectDistance");
            EditorGUILayout.PropertyField(detailObjectDistance, new GUIContent("Max Distance"));

            EditorGUILayout.Space();

            SerializedProperty detailsProperties = serializedObject.FindProperty("detailsProperties");
            EditorGUILayout.BeginHorizontal();
            {
                EditorGUILayout.LabelField("Prototypes: " + detailsProperties.arraySize, EditorStyles.boldLabel, GUILayout.Width(84));

                GUI.enabled = GUI_Enabled() && (detailsProperties.arraySize >= 0);
                if (GUILayout.Button("+"))
                {
                    detailsProperties.arraySize++;
                    EasyTerrain.PropertiesGrass grassPropertiesDefault = new EasyTerrain.PropertiesGrass();
                    if (detailsProperties.arraySize > 1)
                    {
                        grassPropertiesDefault.prototypeTexture = detailsProperties.GetArrayElementAtIndex(detailsProperties.arraySize - 2).FindPropertyRelative("prototypeTexture").objectReferenceValue as Texture2D;
                        grassPropertiesDefault.billboard = detailsProperties.GetArrayElementAtIndex(detailsProperties.arraySize - 2).FindPropertyRelative("billboard").boolValue;
                        grassPropertiesDefault.prototype = detailsProperties.GetArrayElementAtIndex(detailsProperties.arraySize - 2).FindPropertyRelative("prototype").objectReferenceValue as GameObject;
                    }
                    detailsProperties.GetArrayElementAtIndex(detailsProperties.arraySize - 1).FindPropertyRelative("bendFactor").floatValue = grassPropertiesDefault.bendFactor;
                    detailsProperties.GetArrayElementAtIndex(detailsProperties.arraySize - 1).FindPropertyRelative("strength").floatValue = grassPropertiesDefault.strength;
                    detailsProperties.GetArrayElementAtIndex(detailsProperties.arraySize - 1).FindPropertyRelative("color1").colorValue = grassPropertiesDefault.color1;
                    detailsProperties.GetArrayElementAtIndex(detailsProperties.arraySize - 1).FindPropertyRelative("color2").colorValue = grassPropertiesDefault.color2;
                    detailsProperties.GetArrayElementAtIndex(detailsProperties.arraySize - 1).FindPropertyRelative("minScale").floatValue = grassPropertiesDefault.minScale;
                    detailsProperties.GetArrayElementAtIndex(detailsProperties.arraySize - 1).FindPropertyRelative("maxScale").floatValue = grassPropertiesDefault.maxScale;
                    detailsProperties.GetArrayElementAtIndex(detailsProperties.arraySize - 1).FindPropertyRelative("prototypeTexture").objectReferenceValue = grassPropertiesDefault.prototypeTexture;
                    detailsProperties.GetArrayElementAtIndex(detailsProperties.arraySize - 1).FindPropertyRelative("billboard").boolValue = grassPropertiesDefault.billboard;
                    detailsProperties.GetArrayElementAtIndex(detailsProperties.arraySize - 1).FindPropertyRelative("prototype").objectReferenceValue = grassPropertiesDefault.prototype;
                    SerializedProperty inspGrassSelectorIndex = serializedObject.FindProperty("inspGrassSelectorIndex");
                    inspGrassSelectorIndex.intValue = detailsProperties.arraySize - 1;
                }
                GUI.enabled = GUI_Enabled() && (detailsProperties.arraySize > 0);
                if (GUILayout.Button("-"))
                {
                    detailsProperties.arraySize--;
                }
                GUI_Enabled();
            }
            EditorGUILayout.EndHorizontal();

            if (detailsProperties.arraySize > 0)
            {
                SerializedProperty inspGrassSelectorIndex = serializedObject.FindProperty("inspGrassSelectorIndex");
                inspGrassSelectorIndex.intValue = Mathf.Clamp(inspGrassSelectorIndex.intValue, 0, detailsProperties.arraySize - 1);
                string[] menuTexts = new string[detailsProperties.arraySize];
                for (int j = 0; j < detailsProperties.arraySize; j++)
                {
                    menuTexts[j] = "#" + j;
                }
                EditorGUILayout.Space();
                inspGrassSelectorIndex.intValue = GUILayout.SelectionGrid(inspGrassSelectorIndex.intValue, menuTexts, detailsProperties.arraySize);
                EditorGUILayout.Space();

                int i = inspGrassSelectorIndex.intValue;

                SerializedProperty prototypeTexture = detailsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("prototypeTexture");
                SerializedProperty prototype = detailsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("prototype");
                SerializedProperty billboard = detailsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("billboard");
                //
                EditorGUILayout.BeginHorizontal();
                {
                    EditorGUILayout.BeginVertical();
                    {
                        GUI.enabled = (prototype.objectReferenceValue == true) ? false : true;
                        EditorGUILayout.PropertyField(prototypeTexture, GUIContent.none);
                        billboard.boolValue = EditorGUILayout.ToggleLeft("Billboard", billboard.boolValue);
                        GUI_Enabled();
                        EditorGUILayout.Space();
                        GUI.enabled = (prototypeTexture.objectReferenceValue == true) ? false : true;
                        EditorGUILayout.PropertyField(prototype, GUIContent.none);
                        GUI_Enabled();
                    }
                    EditorGUILayout.EndVertical();
                    EditorGUILayout.BeginVertical();
                    {
                        guiRect = EditorGUILayout.GetControlRect(false, GUILayout.Height(60f), GUILayout.Width(60f));
                        if (prototypeTexture.objectReferenceValue == true)
                        {
                            EditorGUI.ObjectField(guiRect, prototypeTexture.objectReferenceValue, typeof(Texture2D), true);
                            //Texture2D pTexture = AssetPreview.GetAssetPreview(prototypeTexture.objectReferenceValue as GameObject);
                            //if (pTexture != null)
                            //{
                            //    EditorGUI.DrawPreviewTexture(guiRect, pTexture);
                            //}
                        }
                        if (prototype.objectReferenceValue == true)
                        {
                            Texture2D pTexture = AssetPreview.GetAssetPreview(prototype.objectReferenceValue as GameObject);
                            if (pTexture != null)
                            {
                                EditorGUI.DrawPreviewTexture(guiRect, pTexture);
                            }
                            //EditorGUI.DrawPreviewTexture(guiRect, AssetPreview.GetAssetPreview(prototype.objectReferenceValue as GameObject));
                        }
                    }
                    EditorGUILayout.EndVertical();
                }
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.Space();

                EditorGUILayout.BeginHorizontal();
                {
                    EditorGUILayout.BeginVertical();
                    {
                        EditorGUILayout.BeginHorizontal();
                        {
                            SerializedProperty strength = detailsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("strength");
                            EditorGUILayout.LabelField("Strength", GUILayout.Width(EditorGUIUtility.labelWidth * 0.9f));
                            EditorGUILayout.PropertyField(strength, GUIContent.none);
                        }
                        EditorGUILayout.EndHorizontal();
                        //
                        EditorGUILayout.BeginHorizontal();
                        {
                            SerializedProperty color1 = detailsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("color1");
                            SerializedProperty color2 = detailsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("color2");
                            EditorGUILayout.LabelField("Colors", GUILayout.Width(EditorGUIUtility.labelWidth * 0.9f));
                            EditorGUILayout.PropertyField(color1, GUIContent.none);
                            EditorGUILayout.PropertyField(color2, GUIContent.none);
                        }
                        EditorGUILayout.EndHorizontal();
                        //
                        EditorGUILayout.BeginHorizontal();
                        {
                            SerializedProperty minScale = detailsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("minScale");
                            SerializedProperty maxScale = detailsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("maxScale");
                            float minScaleValue = minScale.floatValue;
                            float maxScaleValue = maxScale.floatValue;
                            EditorGUILayout.LabelField("Scale", GUILayout.Width(44));
                            minScaleValue = EditorGUILayout.FloatField(minScaleValue, GUILayout.MaxWidth(48), GUILayout.MinWidth(32));
                            EditorGUILayout.MinMaxSlider(ref minScaleValue, ref maxScaleValue, 0f, 4f, GUILayout.MinWidth(0));
                            maxScaleValue = EditorGUILayout.FloatField(maxScaleValue, GUILayout.MaxWidth(48), GUILayout.MinWidth(32));
                            minScale.floatValue = minScaleValue;
                            maxScale.floatValue = maxScaleValue;
                        }
                        EditorGUILayout.EndHorizontal();
                        //

                        EditorGUILayout.LabelField("Apply to Splat Textures:");
                        SerializedProperty applyToSplatTexture = detailsProperties.GetArrayElementAtIndex(i).FindPropertyRelative("applyToSplatTexture");
                        ApplyToSplatTextures(ref applyToSplatTexture);

                        EditorGUILayout.Space();

                        _applyToSplatTexture = new bool[applyToSplatTexture.arraySize];
                        for (int splatindex = 0; splatindex < applyToSplatTexture.arraySize; splatindex++)
                        {
                            _applyToSplatTexture[splatindex] = applyToSplatTexture.GetArrayElementAtIndex(splatindex).boolValue;
                        }

                        DrawPreviewTexture();
                    }
                    EditorGUILayout.EndVertical();
                    EditorGUILayout.LabelField("", GUILayout.Width(20f));
                }
                EditorGUILayout.EndHorizontal();
                //
            } // if (details.arraySize > 0)

            EditorGUILayout.Space();

        }
        EditorGUILayout.EndVertical();
    } // void GrassMenu ()

    //------------------------------------------------------------------
}