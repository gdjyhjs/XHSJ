using UnityEngine;

namespace MouseSoftware
{
    public partial class EasyTerrain : MonoBehaviour
    {
        //==================================================================

        public void Initialize()
        {
            parentTransform = transform;
            parentTransform.gameObject.isStatic = true;

            // apply getters and setters (during Editor Update)
            tileLayout.layout = tileLayout.layout;
            heightmapResolution.resolution = heightmapResolution.resolution;
            detailResolution.resolution = detailResolution.resolution;
            heightmapBaseMapResolution.resolution = heightmapBaseMapResolution.resolution;
            alphamapResolution.resolution = alphamapResolution.resolution;

            // set max values
            heightmapBaseMapResolution.Max(heightmapResolution);
            detailResolution.Max(alphamapResolution);
            if (autoTreeDistance)
            {
                if (autoAdjustPlayerCameraMaxDistance)
                {
                    treeDistance = Mathf.Max(1, tileLayout.vertical) * heightmapSize * 0.5f * Mathf.Cos(Camera.main.fieldOfView * Camera.main.aspect * 0.5f * Mathf.Deg2Rad);
                    //(float)tileLayout.vertical * heightmapSize * 0.5f * Mathf.Cos(Camera.main.fieldOfView * Camera.main.aspect * 0.5f * Mathf.Deg2Rad);
                }
                else
                {
                    treeDistance = Mathf.Max(1, tileLayout.vertical) * heightmapSize * 0.5f;
                }
            }

            // to be used in static functions
            _heightmapMaxHeight = heightmapMaxHeight;
            _heightmapSize = heightmapSize;
            _heightmapNoiseSettings = heightmapNoiseSettings;
            _isIsland = isIsland;
            _islandRadiusMin = islandRadiusMin;
            _islandRadiusMax = islandRadiusMax;
            _nTilesHorizontal = tileLayout.horizontal;
            if (isIsland)
            {
                if (waterTransform != null)
                {
                    waterTransform.position = new Vector3(waterTransform.position.x, waterHeight, waterTransform.position.z);
                }
            }

            // 
            CreateTreeCollidersRootTransform();
            CreateSplatTexturesBlendCurves();
        } // public void Initialize()

        //==================================================================

        public void Start()
        {
            Initialize();

            // Check the population of the collider agents
            ColliderAgentsCheckPopulation();

            // If necessary / requested... generate new tiles
            if ((tileList.Count == 0) || generateAtStart)
            {
                GenerateTerrainTilesAtStart();
            }
            else
            {
                float terrainHeightAtPlayer = GetTerrainSample(new Vector3(0f, 0f, 0f)).height;
                player.position = new Vector3(0f, terrainHeightAtPlayer + playerStartupGroundDistance, 0f);
            }

            // Create treeColliders pool
            foreach (PropertiesTree treeProperty in treesProperties)
            {
                int poolSize = 0;
                GameObject tempTreeCollider;
                foreach (ColliderAgent colliderAgent in colliderAgents)
                {
                    //poolSize += (int)(Mathf.PI * colliderAgent.treeColliderDistance * colliderAgent.treeColliderDistance * treeProperty.density * 0.000002f);
                    poolSize += (int)(colliderAgent.treeColliderDistance * colliderAgent.treeColliderDistance * treeProperty.density * 0.000004f);
                }
                for (int poolIndex = 0; poolIndex < poolSize; poolIndex++)
                {
                    tempTreeCollider = Instantiate(treeProperty.colliderPrefab);
                    tempTreeCollider.transform.parent = treeCollidersRoot;
                    tempTreeCollider.transform.position = Vector3.zero;
                    tempTreeCollider.transform.localScale = Vector3.one;
                    tempTreeCollider.layer = treeColliderLayer;
                    tempTreeCollider.SetActive(false);
                    treeProperty.colliders.Add(tempTreeCollider);
                }
            }

            // Create GameObjects pool(based on 2, 5 % of full density occupation)
            // [disabled: it didn't seem to significantly increase performance, but with many gameobjects shows hick-ups at gae start] 
            //foreach (Tile tile in tileList)
            //{
            //    List<Transform> listOfChildTransforms = new List<Transform>();
            //    listOfChildTransforms = tile.gameObject.GetComponentsInChildren<Transform>(true).ToList();
            //    listOfChildTransforms.RemoveAt(0); // remove reference to tile itself;
            //    List<GameObject> listOfChildGameObjects = new List<GameObject>();
            //    foreach (Transform childTransform in listOfChildTransforms)
            //    {
            //        listOfChildGameObjects.Add(childTransform.gameObject);
            //    }
            //    foreach (PropertiesGameObject gameObjectProperty in gameObjectsProperties)
            //    {
            //        int poolSize = (int)(gameObjectProperty.density * 0.000001f * heightmapSize * heightmapSize * 0.025f);
            //        int currentItemsInPool = 0;
            //        foreach (GameObject childGameObject in listOfChildGameObjects)
            //        {
            //            if (childGameObject.name == gameObjectProperty.prototype.name)
            //            {
            //                currentItemsInPool++;
            //            }
            //        }
            //        for (int poolIndex = currentItemsInPool; poolIndex < poolSize; poolIndex++)
            //        {
            //            Transform tempTransform = Instantiate(gameObjectProperty.prototype).transform;
            //            tempTransform.parent = tile.terrain.transform;
            //            tempTransform.position = Vector3.zero;
            //            tempTransform.localScale = Vector3.one;
            //            tempTransform.rotation = Quaternion.identity;
            //            tempTransform.name = gameObjectProperty.prototype.name;
            //            DisableAllColliders(tempTransform.gameObject);
            //            tempTransform.gameObject.SetActive(false);
            //        }
            //    }
            //}

            // Start coroutines to update all tiles
            StartCoroutine(UpdateTiles());
            // Start coroutines to update all Runtime Colliders (Trees and other gameobejcts placed on the terrain)
            StartCoroutine(UpdateColliders());
        } // public void Start()

        //==================================================================

        private void OnEnable()
        {
            Initialize();
        } // private void OnEnable()

        //==================================================================

        public void StopUpdate()
        {
            foreach (Tile tile in tileList)
            {
                tile.updateStatus = TileUpdateStatus.Idle;
            }
            OnApplicationQuit();
        } // public void StopUpdate()

        //==================================================================

        void OnApplicationQuit()
        {
            // When the application quits, make sure all threads are terminated
            if (_terrainSamplesThread != null)
            {
                _terrainSamplesThread.Abort();
            }
            if (_heightmapThread != null)
            {
                _heightmapThread.Abort();
            }
            if (_alphamapThread != null)
            {
                _alphamapThread.Abort();
            }
            if (_detailmapThread != null)
            {
                _detailmapThread.Abort();
            }
            if (_treesPlacementThread != null)
            {
                _treesPlacementThread.Abort();
            }
            if (_gameObjectsPlacementThread != null)
            {
                _gameObjectsPlacementThread.Abort();
            }

            _stopwatch.Stop();
            _updateStatus = 1f;
        } // void OnApplicationQuit()

        //==================================================================

    }
}