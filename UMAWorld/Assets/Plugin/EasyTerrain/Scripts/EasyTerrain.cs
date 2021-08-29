using System.Collections.Generic;
using UnityEngine;
using System.Threading;

namespace MouseSoftware
{
    [SelectionBase]
    public partial class EasyTerrain : MonoBehaviour
    {
        protected EasyTerrain() { }

        //------------------------------------------------------------------

        [SerializeField]
        private Transform parentTransform;

        //------------------------------------------------------------------

        [SerializeField]
        private TilesLayout tileLayout = new TilesLayout();

        [SerializeField, Range(0f, 5000f)]
        private float heightmapSize = 1000f;

        [SerializeField, Range(0f, 1000f)]
        private float heightmapMaxHeight = 500f;

        [SerializeField]
        private Resolution heightmapResolution = new Resolution();

        [SerializeField]
        private Resolution heightmapBaseMapResolution = new Resolution();

        [SerializeField, Range(0f, 2000f)]
        private float heightmapBasemapDistance = 750f;

        [SerializeField, Range(0, 10)]
        private int heightmapPixelError = 0;

        [SerializeField]
        private NoiseGenerator.NoiseSampleSettings heightmapNoiseSettings = new NoiseGenerator.NoiseSampleSettings();

        [SerializeField]
        private bool isIsland = false;

        [SerializeField]
        private float islandRadiusMin = 0.6f;

        [SerializeField]
        private float islandRadiusMax = 0.8f;

        [SerializeField]
        private float waterHeight = 1.0f;

        [SerializeField]
        private Transform waterTransform = null;

        //------------------------------------------------------------------

        [SerializeField]
        private Resolution alphamapResolution = new Resolution();

        [SerializeField]
        private Material materialTemplate = null;

        [SerializeField]
        private bool castShadows = false;

        [SerializeField]
        private List<PropertiesSplatTexture> splatTexturesHeightness = new List<PropertiesSplatTexture>();

        [SerializeField]
        private List<PropertiesSplatTexture> splatTexturesSteepness = new List<PropertiesSplatTexture>();

        private SplatPrototype[] splatPrototypes;

        //------------------------------------------------------------------

        [SerializeField]
        private bool drawTreesAndFoliage = true;

        [SerializeField]
        private Resolution detailResolution = new Resolution();

        [SerializeField]
        [Range(8, 32)]
        private int detailResolutionIntPerPatch = 8;

        [SerializeField]
        [Range(0f, 1f)]
        private float detailObjectDensity = 1.0F;

        [SerializeField]
        [Range(0f, 1000f)]
        private float detailObjectDistance = 500f;

        [SerializeField]
        private List<PropertiesGrass> detailsProperties = new List<PropertiesGrass>();

        private DetailPrototype[] detailPrototypes = new DetailPrototype[0];

        //------------------------------------------------------------------

        private Transform treeCollidersRoot = null;

        [SerializeField]
        [Range(0f, 4000f)]
        private float treeDistance = 2000f;

        [SerializeField]
        private bool autoTreeDistance = false;

        [SerializeField]
        [Range(0f, 500f)]
        private float treeBillboardDistance = 100f;

        [SerializeField]
        [Range(0f, 100f)]
        private float treeCrossFadeLength = 20f;

        [SerializeField]
        private List<PropertiesTree> treesProperties = new List<PropertiesTree>();

        private TreePrototype[] treePrototypes = new TreePrototype[0];

        [SerializeField]
        private int treeColliderLayer = 0;
        //------------------------------------------------------------------

        [SerializeField]
        private List<PropertiesGameObject> gameObjectsProperties = new List<PropertiesGameObject>();

        //------------------------------------------------------------------

        [SerializeField]
        private Transform player = null;

        [SerializeField, Range(0f, 200f)]
        private float playerStartupFreeRadius = 10f;

        [SerializeField, Range(0f, 100f)]
        private float playerStartupGroundDistance = 1f;

        [SerializeField]
        private bool generateAtStart = false;

        [SerializeField]
        private bool randomizeAtStart = false;


        [SerializeField]
        private bool[] allowedPlayerStartSplatTextures = new bool[8];

        [SerializeField]
        [Range(5f, 90f)]
        private float allowedPlayerStartMaxSteepness = 10f;

        [SerializeField]
        private bool autoAdjustPlayerCameraMaxDistance = false;

        //------------------------------------------------------------------

        [SerializeField]
        private List<Tile> tileList = new List<Tile>();

        [SerializeField]
        private List<ColliderAgent> colliderAgents = new List<ColliderAgent>();

        private static List<ColliderAgent> newColliderAgentsQueue = new List<ColliderAgent>();
        private static List<Transform> removeColliderAgentsQueue = new List<Transform>();

        //------------------------------------------------------------------

        static private float _heightmapMaxHeight = 1f;
        static private float _heightmapSize = 1f;

        static private NoiseGenerator.NoiseSampleSettings _heightmapNoiseSettings;
        static private bool _isIsland;
        static private float _islandRadiusMin;
        static private float _islandRadiusMax;
        static private float _nTilesHorizontal;

        static private float _updateStatusDelta = 0f;
        static private float _updateStatus = 1f;
        static private System.Diagnostics.Stopwatch _stopwatch = new System.Diagnostics.Stopwatch();
        static List<DetachTreesRequest> detachTreesRequestQueue = new List<DetachTreesRequest>();

        //------------------------------------------------------------------

        static private Thread _terrainSamplesThread = null;
        static private Thread _heightmapThread = null;
        static private Thread _alphamapThread = null;
        static private Thread _detailmapThread = null;
        static private Thread _treesPlacementThread = null;
        static private Thread _gameObjectsPlacementThread = null;

        //------------------------------------------------------------------

        //  Inspector Variables
        [SerializeField, HideInInspector]
        private int inspMenuIndex = 0;

        [SerializeField, HideInInspector]
        private int inspGrassSelectorIndex = 0;

        [SerializeField, HideInInspector]
        private int inspTreeSelectorIndex = 0;

        [SerializeField, HideInInspector]
        private int inspGameObjectSelectorIndex = 0;

        [SerializeField, HideInInspector]
        private bool inspTileListEnabled = false;

        [SerializeField, HideInInspector]
        private bool inspDebugMode = false;

        //[SerializeField, HideInInspector]
        //private Texture inspHeightmapPreview;

        //[SerializeField, HideInInspector]
        //private Texture inspSplatmapPreview;

        //==================================================================

        //==================================================================

        [System.Serializable]
        public class Tile
        {
            public GameObject gameObject;
            public int uniqueID;
            public int gridX;
            public int gridZ;
            public Terrain terrain;
            public TerrainData terrainData;
            public TileUpdateStatus updateStatus;
            public Terrain neighbourLeft;
            public Terrain neighbourTop;
            public Terrain neighbourRight;
            public Terrain neighbourBottom;
            public float distanceToPlayer;
            public List<TreeInfo> treeInfoList;
        } // public class Tile

        //------------------------------------------------------------------

        public enum TileUpdateStatus { Idle, UpdateNeeded, UpdateInProgress, FlushNeeded }

        //------------------------------------------------------------------

        [System.Serializable]
        public struct TilesLayout
        {
            public enum LayoutEnum
            {
                _1x1,
                _3x3,
                _5x5,
                _7x7,
                _9x9,
                _11x11
            }

            [SerializeField, HideInInspector]
            private LayoutEnum _layout;

            [SerializeField, HideInInspector]
            private int _horizontal;

            [SerializeField, HideInInspector]
            private int _vertical;

            [SerializeField, HideInInspector]
            private int _total;

            public LayoutEnum layout
            {
                get
                {
                    return this._layout;
                }
                set
                {
                    switch (value)
                    {
                        case LayoutEnum._1x1:
                            this._layout = value;
                            this._horizontal = 1;
                            this._vertical = 1;
                            this._total = this._horizontal * this._vertical;
                            break;
                        case LayoutEnum._3x3:
                            this._layout = value;
                            this._horizontal = 3;
                            this._vertical = 3;
                            this._total = this._horizontal * this._vertical;
                            break;
                        case LayoutEnum._5x5:
                            this._layout = value;
                            this._horizontal = 5;
                            this._vertical = 5;
                            this._total = this._horizontal * this._vertical;
                            break;
                        case LayoutEnum._7x7:
                            this._layout = value;
                            this._horizontal = 7;
                            this._vertical = 7;
                            this._total = this._horizontal * this._vertical;
                            break;
                        case LayoutEnum._9x9:
                            this._layout = value;
                            this._horizontal = 9;
                            this._vertical = 9;
                            this._total = this._horizontal * this._vertical;
                            break;
                        case LayoutEnum._11x11:
                            this._layout = value;
                            this._horizontal = 11;
                            this._vertical = 11;
                            this._total = this._horizontal * this._vertical;
                            break;
                        default:
                            this._layout = value;
                            this._horizontal = 1;
                            this._vertical = 1;
                            this._total = this._horizontal * this._vertical;
                            break;
                    }
                }
            }

            public int horizontal
            {
                get
                {
                    return this._horizontal;
                }
            }

            public int vertical
            {
                get
                {
                    return this._vertical;
                }
            }

            public int total
            {
                get
                {
                    return this._total;
                }
            }
        } // public struct TilesLayout

        //------------------------------------------------------------------

        [System.Serializable]
        public struct Resolution
        {
            public enum ResolutionEnum
            {
                _33,
                _65,
                _129,
                _257,
                _513,
                _1025,
            }

            [SerializeField, HideInInspector]
            private ResolutionEnum _resolutionEnum;

            [SerializeField, HideInInspector]
            private int _resolutionInt;

            public ResolutionEnum resolution
            {
                get
                {
                    return this._resolutionEnum;
                }
                set
                {
                    switch (value)
                    {
                        case ResolutionEnum._33:
                            this._resolutionEnum = value;
                            this._resolutionInt = 33;
                            break;
                        case ResolutionEnum._65:
                            this._resolutionEnum = value;
                            this._resolutionInt = 65;
                            break;
                        case ResolutionEnum._129:
                            this._resolutionEnum = value;
                            this._resolutionInt = 129;
                            break;
                        case ResolutionEnum._257:
                            this._resolutionEnum = value;
                            this._resolutionInt = 257;
                            break;
                        case ResolutionEnum._513:
                            this._resolutionEnum = value;
                            this._resolutionInt = 513;
                            break;
                        case ResolutionEnum._1025:
                            this._resolutionEnum = value;
                            this._resolutionInt = 1025;
                            break;
                        default:
                            this._resolutionEnum = ResolutionEnum._33;
                            this._resolutionInt = 33;
                            break;
                    }
                }
            }

            public int resolutionInt
            {
                get
                {
                    return this._resolutionInt;
                }
                set
                {
                    switch (value)
                    {
                        case 33:
                            this._resolutionEnum = ResolutionEnum._33;
                            this._resolutionInt = value;
                            break;
                        case 65:
                            this._resolutionEnum = ResolutionEnum._65;
                            this._resolutionInt = value;
                            break;
                        case 129:
                            this._resolutionEnum = ResolutionEnum._129;
                            this._resolutionInt = value;
                            break;
                        case 257:
                            this._resolutionEnum = ResolutionEnum._257;
                            this._resolutionInt = value;
                            break;
                        case 513:
                            this._resolutionEnum = ResolutionEnum._513;
                            this._resolutionInt = value;
                            break;
                        case 1025:
                            this._resolutionEnum = ResolutionEnum._1025;
                            this._resolutionInt = value;
                            break;
                        default:
                            this._resolutionEnum = ResolutionEnum._33;
                            this._resolutionInt = 33;
                            break;
                    }
                }
            }

            public void Max(Resolution maxAllowedResolution)
            {
                if (this.resolutionInt > maxAllowedResolution.resolutionInt)
                {
                    this.resolutionInt = maxAllowedResolution.resolutionInt;
                }
            }

            public void Min(Resolution minAllowedResolution)
            {
                if (this.resolutionInt < minAllowedResolution.resolutionInt)
                {
                    this.resolutionInt = minAllowedResolution.resolutionInt;
                }
            }
        } // public struct Resolution

        //==================================================================

        [System.Serializable]
        public class PropertiesSplatTexture
        {
            public Texture2D diffuseTexture = null;
            public Texture2D normalTexture = null;
            public float tileSize = 1f;
            public float blendStart = 0f;
            public float blendEnd = 1f;
            public AnimationCurve blendCurve = AnimationCurve.Linear(0f, 0f, 1f, 1f);
        } // public class PropertiesSplatTexture

        //------------------------------------------------------------------

        [System.Serializable]
        public class PropertiesGrass
        {
            [Range(0f, 1f)]
            public float strength = 1f;
            public GameObject prototype = null;
            public Texture2D prototypeTexture = null;
            public bool billboard = true;
            public Color color1 = new Color(205f / 255f, 188f / 255f, 26f / 255f, 255f / 255f);
            public Color color2 = new Color(67f / 255f, 249f / 255f, 42f / 255f, 255f / 255f);
            [Range(0f, 4f)]
            public float minScale = 0.8f;
            [Range(0f, 4f)]
            public float maxScale = 1.2f;
            [HideInInspector, Range(0f, 1f)]
            public float bendFactor = 1f;
            public bool[] applyToSplatTexture = new bool[8];
            [HideInInspector]
            public int[,] detailLayer = new int[0, 0];
        } // public class PropertiesGrass

        //------------------------------------------------------------------

        [System.Serializable]
        public class PropertiesTree
        {
            [Range(0f, 2000f)]
            public float density = 500f;
            public GameObject prototype = null;
            public Color color1 = Color.white; //new Color(205f / 255f, 188f / 255f, 26f / 255f, 255f / 255f);
            public Color color2 = Color.white; //new Color(0.9f, 1.0f, 0.9f, 1.0f); //new Color(67f / 255f, 249f / 255f, 42f / 255f, 255f / 255f);
            [Range(0f, 4f)]
            public float minScale = 0.8f;
            [Range(0f, 4f)]
            public float maxScale = 1.2f;
            [HideInInspector, Range(0f, 1f)]
            public float bendFactor = 1f;
            public bool[] applyToSplatTexture = new bool[8];
            public bool useNoiseLayer = false;
            public NoiseGenerator.NoiseSampleSettings noiseSettings = new NoiseGenerator.NoiseSampleSettings();
            [Range(1f, 200f)]
            public float minDistance = 1.0f;
            public bool preventMeshOverlap = true;
            [HideInInspector]
            public GameObject colliderPrefab = null;
            [HideInInspector]
            public List<GameObject> colliders;
        } // public class PropertiesTree

        //------------------------------------------------------------------

        [System.Serializable]
        public class TreeInfo
        {
            public Vector3 worldPosition;
            public Vector3 localPosition;
            public Vector3 scale;
            public int prototypeIndex;
            public GameObject colliderInstance;
            public bool hasActiveCollider;
        } // public class TreeInfo

        //------------------------------------------------------------------

        [System.Serializable]
        public class PropertiesGameObject
        {
            //[Range(0f, 1f)]
            //public float strength = 1f;
            [Range(0f, 2000f)]
            public float density = 500f;
            public GameObject prototype = null;
            [Range(0f, 20f)]
            public float minScale = 0.8f;
            [Range(0f, 20f)]
            public float maxScale = 1.2f;
            [Range(0f, 90f)]
            public float minSteepness = 0f;
            [Range(0f, 90f)]
            public float maxSteepness = 10f;
            public bool forceHorizontalPlacement = true;
            public bool useNoiseLayer = false;
            public NoiseGenerator.NoiseSampleSettings noiseSettings = new NoiseGenerator.NoiseSampleSettings();
            [Range(1f, 200f)]
            public float minDistance = 1.0f;
            public bool preventMeshOverlap = true;
            [HideInInspector]
            public bool[] applyToSplatTexture = new bool[8];
        } // public class PropertiesGameObject

        //==================================================================

        [System.Serializable]
        public class ColliderAgent
        {
            public Transform agentTransform;
            public Vector3 positionCache = new Vector3(0, -100000, 0);
            [Range(0f, 500f)]
            public float treeColliderDistance = 50f;
            [Range(0f, 500f)]
            public float gameObjectColliderDistance = 200f;
        } // public class ColliderAgent

        //==================================================================

        //==================================================================

        static WaitForEndOfFrame _endOfFrame = new WaitForEndOfFrame();
        public static WaitForEndOfFrame EndOfFrame
        {
            get { return _endOfFrame; }
        }

        static WaitForFixedUpdate _fixedUpdate = new WaitForFixedUpdate();
        public static WaitForFixedUpdate FixedUpdate
        {
            get { return _fixedUpdate; }
        }

        //static Dictionary<float, WaitForSeconds> _timeInterval = new Dictionary<float, WaitForSeconds>(100);
        //static Dictionary<float, WaitForSecondsRealtime> _realTimeInterval = new Dictionary<float, WaitForSecondsRealtime>(100);

        //public static WaitForSeconds _delay(float seconds)
        //{
        //    if (!_timeInterval.ContainsKey(seconds))
        //    {
        //        _timeInterval.Add(seconds, new WaitForSeconds(seconds));
        //    }
        //    return _timeInterval[seconds];
        //}

        //public static WaitForSecondsRealtime _delayRealTime(float seconds)
        //{
        //    if (!_realTimeInterval.ContainsKey(seconds))
        //    {
        //        _realTimeInterval.Add(seconds, new WaitForSecondsRealtime(seconds));
        //    }
        //    return _realTimeInterval[seconds];
        //}

        //==================================================================

        //==================================================================

        private void ResetInspectorVariables()
        {
            inspMenuIndex *= 0;
            inspTileListEnabled &= false;
            inspDebugMode &= false;
            inspGrassSelectorIndex *= 0;
            inspTreeSelectorIndex *= 0;
            inspGameObjectSelectorIndex *= 0;
        } // private void ResetInspectorVariables()

        //==================================================================

    } // public partial class EasyTerrain : MonoBehaviour

} // namespace MouseSoftware