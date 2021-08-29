using UnityEngine;
using UnityEditor;
using System.Threading;
using MouseSoftware;

public partial class EasyTerrainEditor : Editor
{
    //------------------------------------------------------------------

    void TexturesMenu()
    {
        EditorGUILayout.BeginVertical("Box");
        {
            EditorGUILayout.Space();

            SerializedProperty alphamapResolution = serializedObject.FindProperty("alphamapResolution").FindPropertyRelative("_resolutionEnum");
            EditorGUILayout.PropertyField(alphamapResolution, new GUIContent("Resolution"));

            SerializedProperty materialTemplate = serializedObject.FindProperty("materialTemplate");
            EditorGUILayout.PropertyField(materialTemplate, new GUIContent("Material"));

            SerializedProperty castShadows = serializedObject.FindProperty("castShadows");
            EditorGUILayout.PropertyField(castShadows, new GUIContent("Cast Shadows"));

            EditorGUILayout.Space();

            SerializedProperty splatTexturesSteepness = serializedObject.FindProperty("splatTexturesSteepness");
            SerializedProperty splatTexturesHeightness = serializedObject.FindProperty("splatTexturesHeightness");

            int numberOfSplatmaps = ((splatTexturesSteepness.arraySize + splatTexturesHeightness.arraySize) == 0) ? 0 : (((splatTexturesSteepness.arraySize + splatTexturesHeightness.arraySize) <= 4) ? 1 : 2);
            EditorGUILayout.LabelField("Total Textures = " + (splatTexturesSteepness.arraySize + splatTexturesHeightness.arraySize) + "  (" + numberOfSplatmaps + " splatmaps)", EditorStyles.boldLabel);

            float spacing = 4f;
            float texturePreviewWidth = 44f;
            float animationCurvePreviewHeight = texturePreviewWidth;
            float animationCurvePreviewWidth = EditorGUIUtility.currentViewWidth - 180f;
            int index = 0;
            GUIContent guiContent;

            SerializedProperty diffuseTextureProperty;
            SerializedProperty normalTextureProperty;
            SerializedProperty blendCurveProperty;
            SerializedProperty blendStartProperty;
            SerializedProperty blendEndProperty;
            SerializedProperty tileSizeProperty;
            float tileSizeFloat;
            float blendStartFloat;
            float blendEndFloat;

            // Heightness Textures

            EditorGUILayout.BeginVertical("box");
            {
                EditorGUILayout.BeginHorizontal();
                {
                    EditorGUILayout.LabelField("Heightness Textures: " + splatTexturesHeightness.arraySize, EditorStyles.boldLabel, GUILayout.Width(140));

                    GUI.enabled = GUI_Enabled() && (splatTexturesHeightness.arraySize > 0) && (((splatTexturesSteepness.arraySize + splatTexturesHeightness.arraySize)) < 8);
                    if (GUILayout.Button("+", GUILayout.Width(48)) || (splatTexturesHeightness.arraySize == 0))
                    {
                        splatTexturesHeightness.arraySize++;
                        splatTexturesHeightness.GetArrayElementAtIndex(splatTexturesHeightness.arraySize - 1).FindPropertyRelative("blendStart").floatValue = (splatTexturesHeightness.arraySize > 1) ? 1f : 0f;
                        splatTexturesHeightness.GetArrayElementAtIndex(splatTexturesHeightness.arraySize - 1).FindPropertyRelative("blendEnd").floatValue = 1f;
                        splatTexturesHeightness.GetArrayElementAtIndex(splatTexturesHeightness.arraySize - 1).FindPropertyRelative("tileSize").floatValue = 1f;
                        splatTexturesHeightness.GetArrayElementAtIndex(splatTexturesHeightness.arraySize - 1).FindPropertyRelative("diffuseTexture").objectReferenceValue = null;
                        _previewTextureUpdateRequired = true;
                        GUI.changed = true;
                    }
                    GUI.enabled = GUI_Enabled() && (splatTexturesHeightness.arraySize > 1) && ((splatTexturesSteepness.arraySize + splatTexturesHeightness.arraySize) <= 8);
                    if (GUILayout.Button("-", GUILayout.Width(48)))
                    {
                        splatTexturesHeightness.arraySize--;
                        _previewTextureUpdateRequired = true;
                        GUI.changed = true;
                    }
                    GUI_Enabled();
                }
                EditorGUILayout.EndHorizontal();
                //
                index = 0;
                for (int i = 0; i < splatTexturesHeightness.arraySize; i++)
                {
                    diffuseTextureProperty = splatTexturesHeightness.GetArrayElementAtIndex(i).FindPropertyRelative("diffuseTexture");
                    normalTextureProperty = splatTexturesHeightness.GetArrayElementAtIndex(i).FindPropertyRelative("normalTexture");
                    blendCurveProperty = splatTexturesHeightness.GetArrayElementAtIndex(i).FindPropertyRelative("blendCurve");
                    blendStartProperty = splatTexturesHeightness.GetArrayElementAtIndex(i).FindPropertyRelative("blendStart");
                    blendEndProperty = splatTexturesHeightness.GetArrayElementAtIndex(i).FindPropertyRelative("blendEnd");
                    tileSizeProperty = splatTexturesHeightness.GetArrayElementAtIndex(i).FindPropertyRelative("tileSize");
                    //
                    if (diffuseTextureProperty.objectReferenceValue == null)
                    {
                        Texture2D tempTexture2D = new Texture2D(1, 1, TextureFormat.ARGB32, false);
                        tempTexture2D.SetPixel(0, 0, _colors[i]);
                        tempTexture2D.Apply();
                        diffuseTextureProperty.objectReferenceValue = tempTexture2D;
                    }
                    //
                    EditorGUILayout.BeginHorizontal();
                    {
                        EditorGUILayout.LabelField("#" + index, GUILayout.Width(20f));

                        EditorGUILayout.BeginVertical();
                        {
                            EditorGUILayout.BeginHorizontal();
                            {
                                EditorGUILayout.LabelField("Diffuse", GUILayout.Width(texturePreviewWidth));
                                EditorGUILayout.LabelField("Normal", GUILayout.Width(texturePreviewWidth));
                                EditorGUILayout.LabelField("", GUILayout.Width(spacing));
                                EditorGUILayout.LabelField("BlendCurve", GUILayout.Width(animationCurvePreviewWidth));
                            }
                            EditorGUILayout.EndHorizontal();

                            EditorGUILayout.BeginHorizontal();
                            {
                                diffuseTextureProperty.objectReferenceValue = (Texture2D)EditorGUILayout.ObjectField(diffuseTextureProperty.objectReferenceValue, typeof(Texture2D), true, GUILayout.Height(texturePreviewWidth), GUILayout.Width(texturePreviewWidth));
                                normalTextureProperty.objectReferenceValue = (Texture2D)EditorGUILayout.ObjectField(normalTextureProperty.objectReferenceValue, typeof(Texture2D), true, GUILayout.Height(texturePreviewWidth), GUILayout.Width(texturePreviewWidth));
                                EditorGUILayout.LabelField("", GUILayout.Width(spacing));
                                EditorGUILayout.CurveField(blendCurveProperty.animationCurveValue, _colors[index], new Rect(0, 0, 1, 1), GUILayout.Height(animationCurvePreviewHeight), GUILayout.Width(animationCurvePreviewWidth));
                            }
                            EditorGUILayout.EndHorizontal();

                            tileSizeFloat = tileSizeProperty.floatValue;
                            blendStartFloat = blendStartProperty.floatValue;
                            blendEndFloat = blendEndProperty.floatValue;

                            EditorGUILayout.BeginHorizontal();
                            {
                                EditorGUILayout.LabelField("", GUILayout.Width(2f * texturePreviewWidth + 4f));
                                guiRect = GUILayoutUtility.GetLastRect();
                                tileSizeFloat = (int)GUI.HorizontalSlider(guiRect, tileSizeFloat, 1f, 200f);
                                EditorGUILayout.LabelField("", GUILayout.Width(spacing));
                                EditorGUILayout.MinMaxSlider(ref blendStartFloat, ref blendEndFloat, 0f, 1f, GUILayout.Width(animationCurvePreviewWidth));
                            }
                            EditorGUILayout.EndHorizontal();

                            EditorGUILayout.BeginHorizontal();
                            {
                                guiContent = new GUIContent("tileSize");
                                EditorGUILayout.LabelField(guiContent, GUILayout.Width(texturePreviewWidth));
                                tileSizeFloat = (float)EditorGUILayout.IntField((int)tileSizeFloat, GUILayout.Width(texturePreviewWidth));
                                EditorGUILayout.LabelField("", GUILayout.Width(spacing));
                                blendStartFloat = EditorGUILayout.FloatField(blendStartFloat, GUILayout.Width(texturePreviewWidth));
                                EditorGUILayout.LabelField("", GUILayout.Width(animationCurvePreviewWidth - 2f * texturePreviewWidth - 8f));
                                blendEndFloat = EditorGUILayout.FloatField(blendEndFloat, GUILayout.Width(texturePreviewWidth));
                            }
                            EditorGUILayout.EndHorizontal();

                            tileSizeProperty.floatValue = tileSizeFloat;
                            blendStartProperty.floatValue = blendStartFloat;
                            blendEndProperty.floatValue = blendEndFloat;
                        }
                        EditorGUILayout.EndVertical();
                    }
                    EditorGUILayout.EndHorizontal();
                    index++;
                }
            }
            EditorGUILayout.EndVertical();

            // Steepness Texture

            EditorGUILayout.Space();
            EditorGUILayout.BeginVertical("box");
            {
                EditorGUILayout.BeginHorizontal();
                {
                    EditorGUILayout.LabelField("Steepness Texture: " + splatTexturesSteepness.arraySize, EditorStyles.boldLabel, GUILayout.Width(128));
                    GUI.enabled = GUI_Enabled() && (splatTexturesSteepness.arraySize == 0);
                    if (GUILayout.Button("+", GUILayout.Width(48)) || (splatTexturesHeightness.arraySize == 0))
                    {
                        splatTexturesSteepness.arraySize++;
                        splatTexturesSteepness.GetArrayElementAtIndex(splatTexturesSteepness.arraySize - 1).FindPropertyRelative("blendStart").floatValue = (splatTexturesSteepness.arraySize > 1) ? 90f : 40f;
                        splatTexturesSteepness.GetArrayElementAtIndex(splatTexturesSteepness.arraySize - 1).FindPropertyRelative("blendEnd").floatValue = 80f;
                        splatTexturesSteepness.GetArrayElementAtIndex(splatTexturesSteepness.arraySize - 1).FindPropertyRelative("tileSize").floatValue = 1f;
                        splatTexturesSteepness.GetArrayElementAtIndex(splatTexturesSteepness.arraySize - 1).FindPropertyRelative("diffuseTexture").objectReferenceValue = null;
                        _previewTextureUpdateRequired = true;
                        GUI.changed = true;
                    }
                    GUI.enabled = GUI_Enabled() && (splatTexturesSteepness.arraySize != 0);
                    if (GUILayout.Button("-", GUILayout.Width(48)))
                    {
                        splatTexturesSteepness.arraySize--;
                        _previewTextureUpdateRequired = true;
                        GUI.changed = true;
                    }
                    GUI_Enabled();
                    while ((splatTexturesSteepness.arraySize + splatTexturesHeightness.arraySize) > 8)
                    {
                        splatTexturesHeightness.arraySize--;
                    }
                }
                EditorGUILayout.EndHorizontal();
                //
                index = 0;
                for (int i = 0; i < splatTexturesSteepness.arraySize; i++)
                {
                    diffuseTextureProperty = splatTexturesSteepness.GetArrayElementAtIndex(i).FindPropertyRelative("diffuseTexture");
                    normalTextureProperty = splatTexturesSteepness.GetArrayElementAtIndex(i).FindPropertyRelative("normalTexture");
                    blendCurveProperty = splatTexturesSteepness.GetArrayElementAtIndex(i).FindPropertyRelative("blendCurve");
                    blendStartProperty = splatTexturesSteepness.GetArrayElementAtIndex(i).FindPropertyRelative("blendStart");
                    blendEndProperty = splatTexturesSteepness.GetArrayElementAtIndex(i).FindPropertyRelative("blendEnd");
                    tileSizeProperty = splatTexturesSteepness.GetArrayElementAtIndex(i).FindPropertyRelative("tileSize");
                    //
                    if (diffuseTextureProperty.objectReferenceValue == null)
                    {
                        Texture2D tempTexture2D = new Texture2D(1, 1, TextureFormat.ARGB32, false);
                        tempTexture2D.SetPixel(0, 0, Color.white);
                        tempTexture2D.Apply();
                        diffuseTextureProperty.objectReferenceValue = tempTexture2D;
                    }
                    //
                    EditorGUILayout.BeginHorizontal();
                    {
                        EditorGUILayout.LabelField("#" + index, GUILayout.Width(20f));

                        EditorGUILayout.BeginVertical();
                        {
                            EditorGUILayout.BeginHorizontal();
                            {
                                EditorGUILayout.LabelField("Diffuse", GUILayout.Width(texturePreviewWidth));
                                EditorGUILayout.LabelField("Normal", GUILayout.Width(texturePreviewWidth));
                                EditorGUILayout.LabelField("", GUILayout.Width(spacing));
                                EditorGUILayout.LabelField("BlendCurve", GUILayout.Width(animationCurvePreviewWidth));
                            }
                            EditorGUILayout.EndHorizontal();

                            EditorGUILayout.BeginHorizontal();
                            {
                                diffuseTextureProperty.objectReferenceValue = (Texture2D)EditorGUILayout.ObjectField(diffuseTextureProperty.objectReferenceValue, typeof(Texture2D), true, GUILayout.Height(texturePreviewWidth), GUILayout.Width(texturePreviewWidth));
                                normalTextureProperty.objectReferenceValue = (Texture2D)EditorGUILayout.ObjectField(normalTextureProperty.objectReferenceValue, typeof(Texture2D), true, GUILayout.Height(texturePreviewWidth), GUILayout.Width(texturePreviewWidth));
                                EditorGUILayout.LabelField("", GUILayout.Width(spacing));
                                EditorGUILayout.CurveField(blendCurveProperty.animationCurveValue, Color.white, new Rect(0, 0, 90, 1), GUILayout.Height(animationCurvePreviewHeight), GUILayout.Width(animationCurvePreviewWidth));
                            }
                            EditorGUILayout.EndHorizontal();

                            tileSizeFloat = tileSizeProperty.floatValue;
                            blendStartFloat = blendStartProperty.floatValue;
                            blendEndFloat = blendEndProperty.floatValue;

                            EditorGUILayout.BeginHorizontal();
                            {
                                EditorGUILayout.LabelField("", GUILayout.Width(2f * texturePreviewWidth + 4f));
                                guiRect = GUILayoutUtility.GetLastRect();
                                tileSizeFloat = (int)GUI.HorizontalSlider(guiRect, tileSizeFloat, 1f, 200f);
                                EditorGUILayout.LabelField("", GUILayout.Width(spacing));
                                EditorGUILayout.MinMaxSlider(ref blendStartFloat, ref blendEndFloat, 0f, 90f, GUILayout.Width(animationCurvePreviewWidth));
                            }
                            EditorGUILayout.EndHorizontal();

                            EditorGUILayout.BeginHorizontal();
                            {
                                guiContent = new GUIContent("tileSize");
                                EditorGUILayout.LabelField(guiContent, GUILayout.Width(texturePreviewWidth));
                                tileSizeFloat = (float)EditorGUILayout.IntField((int)tileSizeFloat, GUILayout.Width(texturePreviewWidth));
                                EditorGUILayout.LabelField("", GUILayout.Width(spacing));
                                blendStartFloat = EditorGUILayout.FloatField(blendStartFloat, GUILayout.Width(texturePreviewWidth));
                                EditorGUILayout.LabelField("", GUILayout.Width(animationCurvePreviewWidth - 2f * texturePreviewWidth - 8f));
                                blendEndFloat = EditorGUILayout.FloatField(blendEndFloat, GUILayout.Width(texturePreviewWidth));
                            }
                            EditorGUILayout.EndHorizontal();

                            tileSizeProperty.floatValue = tileSizeFloat;
                            blendStartProperty.floatValue = blendStartFloat;
                            blendEndProperty.floatValue = blendEndFloat;
                        }
                        EditorGUILayout.EndVertical();
                    }
                    EditorGUILayout.EndHorizontal();
                    index++;
                }
            }
            EditorGUILayout.EndVertical();

            EditorGUILayout.Space();

            DrawPreviewTexture();

            EditorGUILayout.Space();
        }
        EditorGUILayout.EndVertical();
    }

    //------------------------------------------------------------------

}