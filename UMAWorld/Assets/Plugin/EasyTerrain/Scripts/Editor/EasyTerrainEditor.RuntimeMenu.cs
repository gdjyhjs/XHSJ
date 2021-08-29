using UnityEngine;
using UnityEditor;
using System.Threading;
using MouseSoftware;
using System.Collections.Generic;

public partial class EasyTerrainEditor : Editor
{

    //------------------------------------------------------------------

    void RuntimeMenu()
    {
        // Auto Adjust Player Camera Max Distance
        EditorGUILayout.BeginVertical("box");
        {
            EditorGUILayout.Space();

            SerializedProperty player = serializedObject.FindProperty("player");
            EditorGUILayout.PropertyField(player, new GUIContent("Player"));

            SerializedProperty playerStartupGroundDistance = serializedObject.FindProperty("playerStartupGroundDistance");
            EditorGUILayout.PropertyField(playerStartupGroundDistance, new GUIContent("Start Height"));

            EditorGUILayout.Space();

            SerializedProperty autoAdjustPlayerCameraMaxDistance = serializedObject.FindProperty("autoAdjustPlayerCameraMaxDistance");
            EditorGUILayout.BeginHorizontal();
            {
                if (GUILayout.Button("Adjust Player Camera Max Distance"))
                {
                    script.AdjustPlayerCameraMaxDistance();
                }
                autoAdjustPlayerCameraMaxDistance.boolValue = EditorGUILayout.ToggleLeft(new GUIContent("auto"), autoAdjustPlayerCameraMaxDistance.boolValue, GUILayout.MaxWidth(48));
            }
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space();
        }
        GUILayout.EndVertical();

        // Runtime TreeCollider Agents
        EditorGUILayout.BeginVertical("Box");
        {
            EditorGUILayout.Space();

            SerializedProperty colliderAgents = serializedObject.FindProperty("colliderAgents");
            EditorGUILayout.BeginHorizontal();
            {
                EditorGUILayout.LabelField("Collider Agents: " + colliderAgents.arraySize, GUILayout.Width(144));

                GUI.enabled = GUI_Enabled() && (colliderAgents.arraySize >= 0);
                if (GUILayout.Button("+"))
                {
                    colliderAgents.arraySize++;
                    colliderAgents.GetArrayElementAtIndex(colliderAgents.arraySize - 1).FindPropertyRelative("agentTransform").objectReferenceValue = null;
                    colliderAgents.GetArrayElementAtIndex(colliderAgents.arraySize - 1).FindPropertyRelative("positionCache").vector3Value = new Vector3(0f, -10000f, 0f);
                    colliderAgents.GetArrayElementAtIndex(colliderAgents.arraySize - 1).FindPropertyRelative("treeColliderDistance").floatValue = 50f;
                    colliderAgents.GetArrayElementAtIndex(colliderAgents.arraySize - 1).FindPropertyRelative("gameObjectColliderDistance").floatValue = 200f;
                }
                GUI.enabled = GUI_Enabled() && (colliderAgents.arraySize > 0);
                if (GUILayout.Button("-"))
                {
                    colliderAgents.arraySize--;
                }
                GUI_Enabled();
            }
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal("box");
            {
                EditorGUILayout.BeginVertical();
                {
                    EditorGUILayout.LabelField("Transform", GUILayout.MinWidth(60f));
                    for (int index = 0; index < colliderAgents.arraySize; index++)
                    {
                        SerializedProperty colliderAgents_agentTransform = colliderAgents.GetArrayElementAtIndex(index).FindPropertyRelative("agentTransform");
                        colliderAgents_agentTransform.objectReferenceValue = EditorGUILayout.ObjectField(colliderAgents_agentTransform.objectReferenceValue, typeof(Transform), true, GUILayout.MinWidth(60f)) as Transform;
                        EditorGUILayout.LabelField(GUIContent.none, GUILayout.MinWidth(60f));
                    }
                }
                EditorGUILayout.EndVertical();

                EditorGUILayout.BeginVertical();
                {
                    EditorGUILayout.LabelField("Collider Distance", GUILayout.MinWidth(70f));
                    for (int index = 0; index < colliderAgents.arraySize; index++)
                    {
                        EditorGUILayout.BeginHorizontal();
                        {
                            EditorGUILayout.LabelField("T:", GUILayout.Width(16f));
                            SerializedProperty colliderAgents_treeColliderDistance = colliderAgents.GetArrayElementAtIndex(index).FindPropertyRelative("treeColliderDistance");
                            colliderAgents_treeColliderDistance.floatValue = EditorGUILayout.Slider(GUIContent.none, colliderAgents_treeColliderDistance.floatValue, 50f, 500f, GUILayout.MinWidth(70f));
                        }
                        EditorGUILayout.EndHorizontal();
                        EditorGUILayout.BeginHorizontal();
                        {
                            EditorGUILayout.LabelField("G:", GUILayout.Width(16f));
                            SerializedProperty colliderAgents_gameObjectColliderDistance = colliderAgents.GetArrayElementAtIndex(index).FindPropertyRelative("gameObjectColliderDistance");
                            colliderAgents_gameObjectColliderDistance.floatValue = EditorGUILayout.Slider(GUIContent.none, colliderAgents_gameObjectColliderDistance.floatValue, 50f, 500f, GUILayout.MinWidth(70f));
                        }
                        EditorGUILayout.EndHorizontal();
                    }
                }
                EditorGUILayout.EndVertical();
            }
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space();
        }
        EditorGUILayout.EndVertical();

        // TreeCollider Layer
        EditorGUILayout.BeginVertical("Box");
        {
            EditorGUILayout.Space();

            SerializedProperty treeColliderLayer = serializedObject.FindProperty("treeColliderLayer");
            EditorGUILayout.BeginHorizontal();
            {
                EditorGUILayout.LabelField("Tree Collider Layer", GUILayout.Width(144));
                treeColliderLayer.intValue = EditorGUILayout.IntSlider(GUIContent.none, treeColliderLayer.intValue, 0, 31, GUILayout.MinWidth(70f));
            }
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.BeginHorizontal();
            {
                EditorGUILayout.LabelField("", GUILayout.Width(144));
                string layerName = (LayerMask.LayerToName(treeColliderLayer.intValue) != "") ? LayerMask.LayerToName(treeColliderLayer.intValue) : "<undefined>";
                EditorGUILayout.LabelField(" --> " + layerName);
            }
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.Space();
        }
        EditorGUILayout.EndVertical();

        // Generate / randomize at start
        EditorGUILayout.BeginVertical("Box");
        {
            EditorGUILayout.Space();

            SerializedProperty generateAtStart = serializedObject.FindProperty("generateAtStart");
            SerializedProperty randomizeAtStart = serializedObject.FindProperty("randomizeAtStart");

            EditorGUILayout.BeginHorizontal();
            {
                generateAtStart.boolValue = EditorGUILayout.ToggleLeft(new GUIContent("Generate at Start"), generateAtStart.boolValue, GUILayout.MaxWidth(120f));
                if (generateAtStart.boolValue)
                {
                    randomizeAtStart.boolValue = EditorGUILayout.ToggleLeft(new GUIContent("Randomize"), randomizeAtStart.boolValue);
                }
            }
            EditorGUILayout.EndHorizontal();

            if (generateAtStart.boolValue && randomizeAtStart.boolValue)
            {
                EditorGUILayout.Space();

                if (GUILayout.Button("Randomize Now"))
                {
                    script.GenerateTerrainTilesAtStart();
                }

                EditorGUILayout.Space();

                SerializedProperty allowedPlayerStartSplatTextures = serializedObject.FindProperty("allowedPlayerStartSplatTextures");
                SerializedProperty allowedPlayerStartMaxSteepness = serializedObject.FindProperty("allowedPlayerStartMaxSteepness");
                EditorGUILayout.LabelField("Terrain Settings at Player Start Position:", EditorStyles.boldLabel);

                EditorGUILayout.PropertyField(allowedPlayerStartMaxSteepness, new GUIContent("Max Steepness"));
                EditorGUILayout.LabelField("Splat Textures:");
                ApplyToSplatTextures(ref allowedPlayerStartSplatTextures);
            }
            EditorGUILayout.Space();
        }
        EditorGUILayout.EndVertical();
    }

    //------------------------------------------------------------------

}