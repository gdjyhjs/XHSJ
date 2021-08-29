using UnityEngine;
using UnityEditor;
using System.Threading;
using MouseSoftware;


public partial class EasyTerrainEditor : Editor
{
    //------------------------------------------------------------------

    void HeightmapsMenu()
    {
        EditorGUILayout.BeginVertical("Box");
        {
            EditorGUILayout.Space();

            SerializedProperty tileLayout = serializedObject.FindProperty("tileLayout").FindPropertyRelative("_layout");
            int tileLayoutCachedEnumValueIndex = tileLayout.enumValueIndex;
            EditorGUILayout.PropertyField(tileLayout, new GUIContent("Tile Layout"));
            if (tileLayout.enumValueIndex != tileLayoutCachedEnumValueIndex)
            {
                _previewTextureUpdateRequired = true;
            }

            EditorGUILayout.Space();

            SerializedProperty heightmapSize = serializedObject.FindProperty("heightmapSize");
            EditorGUILayout.PropertyField(heightmapSize, new GUIContent("Tile Size"));

            SerializedProperty heightmapMaxHeight = serializedObject.FindProperty("heightmapMaxHeight");
            EditorGUILayout.PropertyField(heightmapMaxHeight, new GUIContent("Max Height"));

            EditorGUILayout.Space();

            SerializedProperty heightmapResolution = serializedObject.FindProperty("heightmapResolution").FindPropertyRelative("_resolutionEnum");
            EditorGUILayout.PropertyField(heightmapResolution, new GUIContent("Resolution"));

            SerializedProperty heightmapPixelError = serializedObject.FindProperty("heightmapPixelError");
            EditorGUILayout.PropertyField(heightmapPixelError, new GUIContent("Pixel Error"));

            EditorGUILayout.Space();

            SerializedProperty heightmapBaseMapResolution = serializedObject.FindProperty("heightmapBaseMapResolution").FindPropertyRelative("_resolutionEnum");
            EditorGUILayout.PropertyField(heightmapBaseMapResolution, new GUIContent("BaseMap Resolution"));

            SerializedProperty heightmapBasemapDistance = serializedObject.FindProperty("heightmapBasemapDistance");
            EditorGUILayout.PropertyField(heightmapBasemapDistance, new GUIContent("BaseMap Distance"));

            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Noise", EditorStyles.boldLabel);

            SerializedProperty heightmapNoiseSettings = serializedObject.FindProperty("heightmapNoiseSettings");

            SerializedProperty heightmapNoiseSettings_type = heightmapNoiseSettings.FindPropertyRelative("type");
            EditorGUILayout.PropertyField(heightmapNoiseSettings_type, new GUIContent("Type"));

            SerializedProperty heightmapNoiseSettings_frequency = heightmapNoiseSettings.FindPropertyRelative("frequency");
            // heightmapNoiseSettings_frequency.floatValue = EditorGUILayout.Slider("Frequency",heightmapNoiseSettings_frequency.floatValue,0.0005f, 0.1f);
            float scale = Mathf.RoundToInt(1f / heightmapNoiseSettings_frequency.floatValue);
            scale = EditorGUILayout.Slider(new GUIContent("Scale"), scale, 1f, 2000f);
            heightmapNoiseSettings_frequency.floatValue = 1f / scale;

            SerializedProperty heightmapNoiseSettings_offsetX = heightmapNoiseSettings.FindPropertyRelative("offsetX");
            EditorGUILayout.PropertyField(heightmapNoiseSettings_offsetX, new GUIContent("Offset X"));

            SerializedProperty heightmapNoiseSettings_offsetY = heightmapNoiseSettings.FindPropertyRelative("offsetY");
            if ((heightmapNoiseSettings_type.enumValueIndex != (int)NoiseGenerator.NoiseMethodType.Value2D) &&
                (heightmapNoiseSettings_type.enumValueIndex != (int)NoiseGenerator.NoiseMethodType.Perlin2D) &&
                (heightmapNoiseSettings_type.enumValueIndex != (int)NoiseGenerator.NoiseMethodType.SimplexValue2D) &&
                (heightmapNoiseSettings_type.enumValueIndex != (int)NoiseGenerator.NoiseMethodType.SimplexGradient2D))
            {
                EditorGUILayout.PropertyField(heightmapNoiseSettings_offsetY, new GUIContent("Offset Y"));
            }

            SerializedProperty heightmapNoiseSettings_offsetZ = heightmapNoiseSettings.FindPropertyRelative("offsetZ");
            EditorGUILayout.PropertyField(heightmapNoiseSettings_offsetZ, new GUIContent("Offset Z"));

            SerializedProperty heightmapNoiseSettings_octaves = heightmapNoiseSettings.FindPropertyRelative("octaves");
            EditorGUILayout.PropertyField(heightmapNoiseSettings_octaves, new GUIContent("Octaves"));

            SerializedProperty heightmapNoiseSettings_lacunarity = heightmapNoiseSettings.FindPropertyRelative("lacunarity");
            EditorGUILayout.PropertyField(heightmapNoiseSettings_lacunarity, new GUIContent("Lacunarity"));

            SerializedProperty heightmapNoiseSettings_persistence = heightmapNoiseSettings.FindPropertyRelative("persistence");
            EditorGUILayout.PropertyField(heightmapNoiseSettings_persistence, new GUIContent("Persistence"));

            //SerializedProperty heightmapNoiseSettings_adjustmentCurve = heightmapNoiseSettings.FindPropertyRelative("adjustmentCurve");
            //EditorGUILayout.CurveField (heightmapNoiseSettings_adjustmentCurve, Color.green, new Rect (0, 0, 1, 1), new GUIContent("Adjustment Curve"), GUILayout.Height (48f));

            EditorGUILayout.Space();

            SerializedProperty isIsland = serializedObject.FindProperty("isIsland");

            EditorGUILayout.BeginHorizontal();
            {
                EditorGUILayout.LabelField("Island", EditorStyles.boldLabel, GUILayout.MaxWidth(40f));
                isIsland.boolValue = EditorGUILayout.ToggleLeft("", isIsland.boolValue);
            }
            EditorGUILayout.EndHorizontal();

            if (isIsland.boolValue)
            {
                SerializedProperty islandRadiusMin = serializedObject.FindProperty("islandRadiusMin");
                SerializedProperty islandRadiusMax = serializedObject.FindProperty("islandRadiusMax");
                SerializedProperty waterHeight = serializedObject.FindProperty("waterHeight");
                SerializedProperty waterTransform = serializedObject.FindProperty("waterTransform");

                float radiusMin = islandRadiusMin.floatValue;
                float radiusMax = islandRadiusMax.floatValue;

                Rect r;
                EditorGUILayout.BeginHorizontal();
                {
                    EditorGUILayout.LabelField("Size", GUILayout.MaxWidth(80f));
                    AnimationCurve islandCurve = new AnimationCurve(
                        new Keyframe(-radiusMax, 0f, 0f, 0f),
                        new Keyframe(-radiusMin, 1f, 0f, 0f),
                        new Keyframe(radiusMin, 1f, 0f, 0f),
                        new Keyframe(radiusMax, 0f, 0f, 0f)
                        );
                    EditorGUILayout.CurveField(islandCurve, Color.yellow, new Rect(-1, 0, 2, 1), GUILayout.Height(44f));
                    r = GUILayoutUtility.GetLastRect();
                }
                EditorGUILayout.EndHorizontal();

                r.height = 12f;
                r.y += 44f;
                r.width /= 2f;
                radiusMin = -GUI.HorizontalSlider(r, -radiusMin, -1f, 0f);
                r.x += r.width;
                radiusMin = GUI.HorizontalSlider(r, radiusMin, 0f, 1f);
                r.x -= r.width;
                r.y += 12f;
                radiusMax = -GUI.HorizontalSlider(r, -radiusMax, -1f, 0f);
                r.x += r.width;
                radiusMax = GUI.HorizontalSlider(r, radiusMax, 0f, 1f);
                r.y -= 16f;

                EditorGUILayout.Space();
                EditorGUILayout.Space();
                EditorGUILayout.Space();
                EditorGUILayout.Space();

                EditorGUILayout.BeginHorizontal();
                {
                    EditorGUILayout.LabelField("", GUILayout.MaxWidth(80f));
                    radiusMax = EditorGUILayout.FloatField(radiusMax);
                    radiusMin = EditorGUILayout.FloatField(radiusMin);
                    radiusMin = EditorGUILayout.FloatField(radiusMin);
                    radiusMax = EditorGUILayout.FloatField(radiusMax);
                }
                EditorGUILayout.EndHorizontal();

                islandRadiusMin.floatValue = Mathf.Clamp(Mathf.Min(radiusMin, radiusMax), 0f, 1f);
                islandRadiusMax.floatValue = Mathf.Clamp(Mathf.Max(radiusMin, radiusMax), 0f, 1f);

                EditorGUILayout.PropertyField(waterTransform, new GUIContent("Water"));
                if (waterTransform.objectReferenceValue != null)
                {
                    waterHeight.floatValue = EditorGUILayout.Slider("Water height", waterHeight.floatValue, 0f, heightmapMaxHeight.floatValue);
                }
            }

            EditorGUILayout.Space();

            DrawPreviewTexture();

            EditorGUILayout.Space();
        }
        EditorGUILayout.EndVertical();

    } // void HeightmapMenu ()

    //------------------------------------------------------------------

}