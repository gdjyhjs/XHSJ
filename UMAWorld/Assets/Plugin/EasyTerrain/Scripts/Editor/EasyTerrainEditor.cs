using UnityEngine;
using UnityEditor;
using System.Threading;
using MouseSoftware;

[CustomEditor(typeof(MouseSoftware.EasyTerrain))]
public partial class EasyTerrainEditor : Editor
{

    private MouseSoftware.EasyTerrain script;
    private bool deleteButtonEnabled = false;
    protected string[] menuOptions = new string[] { "Heightmaps", "Textures", "Grass", "Trees", "GameObjects", "Runtime" };

    private Rect guiRect = new Rect();
    private Color[] _colors = new Color[]
    {
        Color.red,
        Color.green,
        Color.blue,
        Color.magenta,
        Color.yellow,
        Color.cyan,
        Color.grey,
        Color.white
    };

    private const int _previewTexturePixelSize = 64;
    static Texture2D _previewTexture = null;
    static private Color[,] _previewTextureColors = null;
    static private System.Threading.Thread _previewTextureColorsThread = null;
    static private bool _previewTextureUpdateRequired = true;
    static private bool _previewTextureUpdateInProgress = false;

    static private AnimationCurve[] _splatmapPreviewBlendCurves = null;
    static private Color[] _splatmapPreviewBlendColors = null;
    static private bool[] _applyToSplatTexture = null;

    private float _nTiles = 0f;
    private float _tileSize = 0f;
    private float _tileMaxHeight = 0f;

    private bool _useNoiseLayer = false;
    private float _noiseFrequency = 1f;
    private float _noiseOffsetX = 0f, _noiseOffsetY = 0f, _noiseOffsetZ = 0f, _threshold = 0f, _falloff = 0f;

    //------------------------------------------------------------------

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        script = target as MouseSoftware.EasyTerrain;
        if (!Application.isPlaying)
        {
            script.Initialize();
            Menu();
        }
        else
        {
            EditorGUILayout.Space();
            EditorGUILayout.HelpBox("Exit PlayMode to configure settings", MessageType.Warning, true);
            EditorGUILayout.Space();
        }
    }

    //------------------------------------------------------------------

    void Menu()
    {
        EditorGUI.BeginChangeCheck();
        {
            EditorGUILayout.BeginVertical("box");
            {
                EditorGUILayout.Space();
                SerializedProperty player = serializedObject.FindProperty("player");
                EditorGUILayout.PropertyField(player, new GUIContent("Player"));
                EditorGUILayout.Space();
            }
            GUILayout.EndVertical();

            UpdateButtons();

            GUI_Enabled();

            // 0 = "Heightmaps", 1 = "Textures", 2 = "Grass", 3 = "Trees", 4 = "GameObjects", 5 = "Runtime"
            SerializedProperty inspMenuIndex = serializedObject.FindProperty("inspMenuIndex");
            EditorGUILayout.BeginVertical();
            {
                inspMenuIndex.intValue = GUILayout.SelectionGrid(inspMenuIndex.intValue, menuOptions, 2);
            }
            GUILayout.EndVertical();

            switch (inspMenuIndex.intValue)
            {
                case 0:
                    HeightmapsMenu();
                    break;
                case 1:
                    TexturesMenu();
                    break;
                case 2:
                    GrassMenu();
                    break;
                case 3:
                    TreesMenu();
                    break;
                case 4:
                    GameObjectsMenu();
                    break;
                case 5:
                    RuntimeMenu();
                    break;
                default:
                    return;
            }

            GUI.enabled = true;

            // Debug START
            //EditorGUILayout.BeginVertical("box");
            //{
            //    //SerializedProperty tileUpdateInProgress = serializedObject.FindProperty("tileUpdateInProgress");
            //    //EditorGUILayout.PropertyField (tileUpdateInProgress);

            //    SerializedProperty inspDebugMode = serializedObject.FindProperty("inspDebugMode");
            //    EditorGUILayout.PropertyField(inspDebugMode);

            //    if (inspDebugMode.boolValue)
            //    {
            //        EditorGUILayout.Space();
            //        EditorGUILayout.Space();
            //        DrawDefaultInspector();
            //    }
            //}
            //EditorGUILayout.EndHorizontal();

            // Debug END
        }

        if (EditorGUI.EndChangeCheck())
        {
            serializedObject.ApplyModifiedProperties();
            EditorUtility.SetDirty(script);
            UnityEditorInternal.InternalEditorUtility.RepaintAllViews();
            _previewTextureUpdateRequired = true;
        }

        Undo.undoRedoPerformed = UndoCallbackFunction;
    }

    //------------------------------------------------------------------

    private void UndoCallbackFunction()
    {
        serializedObject.ApplyModifiedProperties();
        EditorUtility.SetDirty(script);
        UnityEditorInternal.InternalEditorUtility.RepaintAllViews();
        _previewTextureUpdateRequired = true;
    }

    //------------------------------------------------------------------

    void UpdateButtons()
    {
        EditorGUILayout.BeginVertical("Box");
        {
            EditorGUILayout.Space();

            SerializedProperty tileList = serializedObject.FindProperty("tileList");
            EditorGUILayout.BeginHorizontal();
            {
                EditorGUILayout.BeginVertical();
                {
                    {
                        //GUI_Enabled();

                        string buttonText = (tileList.arraySize == 0) ? "Create Terrain" : "Update Terrain";
                        if (deleteButtonEnabled)
                            buttonText = "Delete Terrain";

                        bool tileUpdateInProgress = (EasyTerrain.GetUpdateStatusPercentage() < 100) ? true : false;
                        if (tileUpdateInProgress)
                            buttonText = "Stop";

                        if (GUILayout.Button(buttonText, GUILayout.Width(EditorGUIUtility.currentViewWidth - 100)))
                        {
                            if (!tileUpdateInProgress)
                            {
                                if (!deleteButtonEnabled)
                                {
                                    script.GenerateTerrainTiles();
                                }
                                else
                                {
                                    script.DeleteTerrainTiles();
                                    deleteButtonEnabled = false;
                                }
                            }
                            else
                            {
                                script.StopUpdate();
                            }

                        }
                        GUI.enabled = true;
                    }
                    {
                        string updateStatusPercentageString = "" + Mathf.Round(EasyTerrain.GetUpdateStatusPercentage()) + "%";
                        EditorGUILayout.LabelField("", GUILayout.Width(EditorGUIUtility.currentViewWidth - 100));
                        EditorGUI.ProgressBar(GUILayoutUtility.GetLastRect(), EasyTerrain.GetUpdateStatusPercentage() * 0.01f, updateStatusPercentageString);
                    }
                }
                GUILayout.EndVertical();

                EditorGUILayout.BeginVertical();
                {
                    {
                        GUI_Enabled();
                        deleteButtonEnabled = GUILayout.Toggle(deleteButtonEnabled, "delete", GUILayout.Width(60));
                        GUI.enabled = true;
                    }
                    {
                        string progressSecondsString = "(" + EasyTerrain.GetStopwatchElapsedSeconds().ToString("F") + " s)";
                        EditorGUILayout.LabelField(progressSecondsString, GUILayout.Width(60));
                    }
                }
                GUILayout.EndVertical();
            }
            EditorGUILayout.EndHorizontal();

            //TileList ();

            EditorGUILayout.Space();
        }
        GUILayout.EndVertical();
    }

    //------------------------------------------------------------------

    void TileList()
    {
        SerializedProperty inspTileListEnabled = serializedObject.FindProperty("inspTileListEnabled");
        inspTileListEnabled.boolValue = EditorGUILayout.ToggleLeft(" Tile List", inspTileListEnabled.boolValue);

        if (inspTileListEnabled.boolValue)
        {
            EditorGUILayout.BeginVertical();
            {
                SerializedProperty tileList = serializedObject.FindProperty("tileList");
                for (int tileIndex = 0; tileIndex < tileList.arraySize; tileIndex++)
                {
                    GameObject tileGameObject = tileList.GetArrayElementAtIndex(tileIndex).FindPropertyRelative("gameObject").objectReferenceValue as GameObject;
                    GUI_Enabled();
                    EditorGUILayout.ObjectField("Tile_" + tileIndex, tileGameObject, typeof(GameObject), true, GUILayout.Width(EditorGUIUtility.currentViewWidth - 28));
                    GUI.enabled = true;
                }
            }
            EditorGUILayout.EndVertical();
        }

        EditorGUILayout.Space();
    }

    //------------------------------------------------------------------

    private bool GUI_Enabled()
    {
        bool tileUpdateInProgress = (EasyTerrain.GetUpdateStatusPercentage() < 100) ? true : false;
        GUI.enabled = !tileUpdateInProgress && !Application.isPlaying && (serializedObject.FindProperty("player").objectReferenceValue != null);
        return GUI.enabled;
    }

    //------------------------------------------------------------------

}