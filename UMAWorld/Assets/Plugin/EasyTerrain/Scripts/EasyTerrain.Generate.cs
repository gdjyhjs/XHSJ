using System.Collections.Generic;
using UnityEngine;

namespace MouseSoftware
{
    public partial class EasyTerrain : MonoBehaviour
    {
        //==================================================================

        public void GenerateTerrainTiles()
        {
            // (re)setting some stuff
            transform.position = Vector3.zero;
            Initialize();
            ColliderAgentsCheckPopulation();
            DeleteTerrainTiles();

            // place player at center of the map
            if (player != null)
            {
                float terrainHeightAtPlayer = GetTerrainSample(new Vector3(0f, 0f, 0f)).height;
                player.position = new Vector3(0f, terrainHeightAtPlayer + playerStartupGroundDistance, 0f);
                if (autoAdjustPlayerCameraMaxDistance)
                {
                    AdjustPlayerCameraMaxDistance();
                }
            }

            // basemap heightmap resolution cannot exceed normal heightmap resolution
            heightmapBaseMapResolution.Max(heightmapResolution);
            // detail resolution cannot exceed alphaMap resolution
            detailResolution.Max(alphamapResolution);

            // Create blendCurves and prototypes
            CreateSplatTexturesBlendCurves();
            splatPrototypes = CreateSplatPrototypes();
            detailPrototypes = CreateDetailPrototypes();
            treePrototypes = CreateTreePrototypes();

            // Disable colliders on all gameobjects that will be assigned to the terrain through this script; 
            // Their colliders will be dynamically updated during runtime.
            for (int n = 0; n < gameObjectsProperties.Count; n++)
            {
                if (gameObjectsProperties[n].prototype != null)
                {
                    DisableAllColliders(gameObjectsProperties[n].prototype);
                    gameObjectsProperties[n].minDistance = gameObjectsProperties[n].preventMeshOverlap ? GetRadiusFromMeshBoundingBoxes(gameObjectsProperties[n].prototype) : 1f;
                }
            }

            // Generate all tiles and add them to the tileList
            int dgx = (tileLayout.horizontal - 1) / 2;
            int dgz = (tileLayout.vertical - 1) / 2;
            int uniqueID = 0;
            for (int gridZ = dgz; gridZ >= -dgz; gridZ--)
            {
                for (int gridX = -dgx; gridX <= dgx; gridX++)
                {
                    tileList.Add(GenerateTerrainTile(uniqueID, gridX, gridZ));
                    uniqueID++;
                }
            }

            // Sort the tileList. The tiles closest to the player will be updated first
            tileList.Sort((d1, d2) => d1.distanceToPlayer.CompareTo(d2.distanceToPlayer));

            // Only update tiles durng runtime
            if (!Application.isPlaying)
            {
                StartCoroutine(UpdateTiles());
            }
        } // public void GenerateTerrainTiles()

        //==================================================================

        public Tile GenerateTerrainTile(int uniqueID, int gridX, int gridZ)
        {
            Tile newtile = new Tile();

            newtile.uniqueID = uniqueID;
            newtile.gridX = gridX;
            newtile.gridZ = gridZ;

            // calculate position in world coordinates
            float posX = (-0.5f + gridX) * heightmapSize;
            float posZ = (-0.5f + gridZ) * heightmapSize;
            Vector3 position = new Vector3(posX, 0f, posZ);

            // create new TerrainData, from global settings
            TerrainData terrainData = new TerrainData();
            terrainData.heightmapResolution = heightmapResolution.resolutionInt;
            terrainData.baseMapResolution = heightmapBaseMapResolution.resolutionInt;
            terrainData.alphamapResolution = alphamapResolution.resolutionInt;
            terrainData.size = new Vector3(heightmapSize, heightmapMaxHeight, heightmapSize);
            terrainData.thickness = 10f;
            terrainData.SetDetailResolution(detailResolution.resolutionInt, detailResolutionIntPerPatch);

            // Create blendcurves and all prototypes (splatTextures, Detail and trees)
            CreateSplatTexturesBlendCurves();
#if UNITY_2018_3_OR_NEWER
            List<TerrainLayer> terrainLayers = new List<TerrainLayer>();
            terrainLayers.Clear();
            for (int i = 0; i < splatPrototypes.Length; i++)
            {
                TerrainLayer newTerrainLayer = new TerrainLayer()
                {
                    //newTerrainLayer.name = string.Format("Layer_{0:##}", i);

                    diffuseTexture = splatPrototypes[i].texture,
                    normalMapTexture = splatPrototypes[i].normalMap,

                    tileSize = splatPrototypes[i].tileSize,
                    tileOffset = splatPrototypes[i].tileOffset,

                    maskMapTexture = splatPrototypes[i].texture,

                    normalScale = 1f,
                    diffuseRemapMin = new Vector4(0, 0, 0, 0),
                    diffuseRemapMax = new Vector4(1, 0, 0, 0),
                    maskMapRemapMin = Vector4.zero,
                    maskMapRemapMax = Vector4.one,

                    metallic = splatPrototypes[i].metallic,
                    smoothness = splatPrototypes[i].smoothness,
                    specular = splatPrototypes[i].specular
                };
                Instantiate(newTerrainLayer);
                terrainLayers.Add(newTerrainLayer);
            }
            terrainData.terrainLayers = terrainLayers.ToArray();
#else
            terrainData.splatPrototypes = splatPrototypes;
#endif
            terrainData.detailPrototypes = detailPrototypes;
            terrainData.treePrototypes = treePrototypes;
            terrainData.RefreshPrototypes();

            // use the terraindata to create a new tile GameObject
            newtile.terrainData = terrainData;
            newtile.gameObject = Terrain.CreateTerrainGameObject(terrainData);
            newtile.gameObject.name = string.Format("Terrain [X={0:+#;-#;+0} & Y={1:+#;-#;+0}]", gridX, gridZ);
            newtile.gameObject.transform.position = position;
            Transform tileRoot = parentTransform.Find("_TerrainTiles_");
            if (tileRoot == null)
            {
                tileRoot = (new GameObject("_TerrainTiles_")).transform;
                tileRoot.parent = parentTransform;
                tileRoot.gameObject.isStatic = true;
            }
            newtile.gameObject.transform.parent = tileRoot;

            // and assign all relevant terrain settings to this new tile
            newtile.terrain = newtile.gameObject.GetComponent<Terrain>() as Terrain;
#if UNITY_2018_3_OR_NEWER
            newtile.terrain.drawInstanced = false;
            newtile.terrain.allowAutoConnect = true;
#endif
            newtile.terrain.heightmapPixelError = heightmapPixelError;
            newtile.terrain.materialType = (materialTemplate != null) ? Terrain.MaterialType.Custom : Terrain.MaterialType.BuiltInStandard;
            if (materialTemplate != null)
            {
                materialTemplate.SetVector("_TerrainTileSize", terrainData.size);
                materialTemplate.SetFloat("_MainTexDistance", heightmapBasemapDistance);
            }
            newtile.terrain.materialTemplate = materialTemplate;
            newtile.terrain.reflectionProbeUsage = UnityEngine.Rendering.ReflectionProbeUsage.Off;
            newtile.terrain.basemapDistance = heightmapBasemapDistance;
            newtile.terrain.castShadows = castShadows;
            newtile.terrain.drawTreesAndFoliage = drawTreesAndFoliage;
            newtile.terrain.editorRenderFlags = TerrainRenderFlags.All;
            newtile.terrain.detailObjectDensity = detailObjectDensity;
            newtile.terrain.detailObjectDistance = detailObjectDistance;
            newtile.terrain.treeDistance = treeDistance;
            newtile.terrain.treeBillboardDistance = treeBillboardDistance;
            newtile.terrain.treeCrossFadeLength = treeCrossFadeLength;
            newtile.terrain.enabled = true;

            // destroy and recreate terraincollider (Sometimes, a terrain collider wouldn't update itself; this seems to be an adequate fix)
            DestroyImmediate(newtile.gameObject.GetComponent<TerrainCollider>());
            newtile.gameObject.AddComponent<TerrainCollider>();
            newtile.terrain.GetComponent<TerrainCollider>().terrainData = newtile.terrainData;
            newtile.terrain.GetComponent<TerrainCollider>().enabled = true;

            // Flush
            newtile.terrain.Flush();

            // Mark tile as "update needed", so it's heightmap etc. will be automatically updated.
            newtile.updateStatus = TileUpdateStatus.UpdateNeeded;
            newtile.treeInfoList = new List<TreeInfo>();
            newtile.distanceToPlayer = DistanceFromTileCenter(newtile, Vector3.zero);

            return newtile;
        } // public Tile GenerateTerrainTile(int uniqueID, int gridX, int gridZ)

        //==================================================================

        public void GenerateTerrainTilesAtStart()
        {
            if (randomizeAtStart)
            {
                // randomize all relevant settings, and make sure the center of the map is exceptable for the player to start 
                // (e.g. texture and steepness within given parameters)
                bool placementIsOK = false;
                int attempt = -1;
                TerrainSample terrainSample;
                do
                {
                    attempt++;
                    RandomizeSettings();
                    terrainSample = GetTerrainSample(Vector3.zero);
                    player.position = new Vector3(0f, terrainSample.height + playerStartupGroundDistance, 0f);
                    if (terrainSample.steepness < allowedPlayerStartMaxSteepness)
                    {
                        int splatIndex = 0;
                        foreach (PropertiesSplatTexture sth in splatTexturesHeightness)
                        {
                            if ((sth.blendCurve.Evaluate(terrainSample.height / heightmapMaxHeight) > 0.8f) && allowedPlayerStartSplatTextures[splatIndex] == true)
                            {
                                placementIsOK = true;
                                break;
                            }
                            splatIndex++;
                        }
                        foreach (PropertiesSplatTexture sts in splatTexturesSteepness)
                        {
                            if ((sts.blendCurve.Evaluate(terrainSample.steepness) > 0.5f) && allowedPlayerStartSplatTextures[splatIndex] == true)
                            {
                                placementIsOK = true;
                                break;
                            }
                            splatIndex++;
                        }
                    }
                } while (!placementIsOK && attempt < 1000);
                if (!placementIsOK)
                {
                    Debug.Log("Warning (EasyTerrain): Failed to generate terrain with requested player start settings --> please check the settings in the inspector \"Runtime\"-menu");
                }
                //Debug.Log("==> Player starts at height=" + terrainSample.height + " and steepness=" + terrainSample.steepness);
            }

            GenerateTerrainTiles();
        } // public void GenerateTerrainTilesAtStart()

        //==================================================================

        private void RandomizeSettings()
        {
            // Randomize rekevant heightmap settings
            heightmapNoiseSettings.offsetX = (int)Random.Range(-5000, 5000);
            heightmapNoiseSettings.offsetY = (int)Random.Range(-5000, 5000);
            heightmapNoiseSettings.offsetZ = (int)Random.Range(-5000, 5000);
            // Randomize relevant tree settings
            int randomTreeOffset = (int)Random.Range(-5000, 5000);
            foreach (PropertiesTree treeProperties in treesProperties)
            {
                treeProperties.noiseSettings.offsetY += randomTreeOffset;
                while (treeProperties.noiseSettings.offsetY > 5000f)
                {
                    treeProperties.noiseSettings.offsetY -= 5000f;
                }
                while (treeProperties.noiseSettings.offsetY < -5000f)
                {
                    treeProperties.noiseSettings.offsetY += 5000f;
                }
            }
            // Randomize relevant gameobject settings
            int randomGameObjectOffset = (int)Random.Range(-5000, 5000);
            foreach (PropertiesGameObject gameObjectProperties in gameObjectsProperties)
            {
                gameObjectProperties.noiseSettings.offsetY += randomGameObjectOffset;
                while (gameObjectProperties.noiseSettings.offsetY > 5000f)
                {
                    gameObjectProperties.noiseSettings.offsetY -= 5000f;
                }
                while (gameObjectProperties.noiseSettings.offsetY < -5000f)
                {
                    gameObjectProperties.noiseSettings.offsetY += 5000f;
                }
            }
        } // private void RandomizeSettings()

        //==================================================================

        public void DeleteTerrainTiles()
        {
            // delete tile gameobjects...
            foreach (Tile tile in tileList)
            {
                DestroyImmediate(tile.gameObject);
            }
            tileList.Clear();

            // ... and their parent Transform
            if (parentTransform.Find("_TerrainTiles_"))
            {
                DestroyImmediate(parentTransform.Find("_TerrainTiles_").gameObject);
            }

            // delete all template treeCollider prefabs in the scene
            foreach (PropertiesTree treeProperties in treesProperties)
            {
                DestroyImmediate(treeProperties.colliderPrefab);
                foreach (GameObject treeCollider in treeProperties.colliders)
                {
                    DestroyImmediate(treeCollider);
                }
                treeProperties.colliders.Clear();
            }

            // ... and their parent Transform
            if (transform.Find("_TreeColliders_"))
            {
                DestroyImmediate(transform.Find("_TreeColliders_").gameObject);
            }
        } // public void DeleteTerrainTiles()

        //==================================================================

        private SplatPrototype[] CreateSplatPrototypes()
        {
            // Create SplatPrototypes, using the global settings on steepness textures (max 1) and heightness textures (max 7 or 8)
            int nSplatHeightnessTotal = splatTexturesHeightness.Count;
            int nSplatSteepnessTotal = splatTexturesSteepness.Count;

            int nSplatTotal = nSplatHeightnessTotal + nSplatSteepnessTotal;
            SplatPrototype[] newSplatPrototypes = new SplatPrototype[nSplatTotal];
            for (int n = 0; n < nSplatTotal; n++)
            {
                newSplatPrototypes[n] = new SplatPrototype();
                if (n < nSplatHeightnessTotal)
                {
                    newSplatPrototypes[n].texture = splatTexturesHeightness[n].diffuseTexture;
                    newSplatPrototypes[n].normalMap = splatTexturesHeightness[n].normalTexture;
                    newSplatPrototypes[n].metallic = 0f;
                    newSplatPrototypes[n].smoothness = 0f;
                    newSplatPrototypes[n].specular = Color.white;
                    newSplatPrototypes[n].tileOffset = new Vector2(0f, 0f);
                    newSplatPrototypes[n].tileSize = new Vector2(splatTexturesHeightness[n].tileSize, splatTexturesHeightness[n].tileSize);
                }
                else
                {
                    int m = n - nSplatHeightnessTotal;
                    newSplatPrototypes[n].texture = splatTexturesSteepness[m].diffuseTexture;
                    newSplatPrototypes[n].normalMap = splatTexturesSteepness[m].normalTexture;
                    newSplatPrototypes[n].smoothness = 0f;
                    newSplatPrototypes[n].specular = Color.white;
                    newSplatPrototypes[n].tileOffset = new Vector2(0f, 0f);
                    newSplatPrototypes[n].tileSize = new Vector2(splatTexturesSteepness[m].tileSize, splatTexturesSteepness[m].tileSize);
                }
            }
            return newSplatPrototypes;
        } // private SplatPrototype[] CreateSplatPrototypes()

        //==================================================================

        //private void CreateIslandBlendCurve()
        //{
        //    islandCurve = new AnimationCurve(
        //        new Keyframe(-islandRadiusMax * heightmapSize * 0.5f * tileLayout.horizontal, islandSeaFloorMax, 0f, 0f),
        //        new Keyframe(-islandRadiusMin * heightmapSize * 0.5f * tileLayout.horizontal, 1f, 0f, 0f),
        //        new Keyframe(islandRadiusMin * heightmapSize * 0.5f * tileLayout.horizontal, 1f, 0f, 0f),
        //        new Keyframe(islandRadiusMax * heightmapSize * 0.5f * tileLayout.horizontal, islandSeaFloorMax, 0f, 0f)
        //        );
        //    _islandCurve = islandCurve;
        //}

        //==================================================================

        private void CreateSplatTexturesBlendCurves()
        {
            // Create blendcurves, from the global settings on steepness textures (max 1) and heightness textures (max 7 or 8)
            // this will be used to create the SplatPrototypes
            switch (splatTexturesHeightness.Count)
            {
                case 0:
                    break;
                case 1:
                    splatTexturesHeightness[0].blendStart = 0f;
                    splatTexturesHeightness[0].blendEnd = 1f;
                    splatTexturesHeightness[0].blendCurve = new AnimationCurve(
                        new Keyframe(splatTexturesHeightness[0].blendStart, 1f, 0f, 0f),
                        new Keyframe(splatTexturesHeightness[0].blendEnd, 1f, 0f, 0f));
                    break;
                default:
                    splatTexturesHeightness[0].blendStart = 0f;
                    splatTexturesHeightness[splatTexturesHeightness.Count - 1].blendEnd = 1f;
                    for (int index = 1; index < splatTexturesHeightness.Count; index++)
                    {
                        if (splatTexturesHeightness[index].blendStart > splatTexturesHeightness[index - 1].blendEnd)
                        {
                            float temp = splatTexturesHeightness[index - 1].blendEnd;
                            splatTexturesHeightness[index - 1].blendEnd = splatTexturesHeightness[index].blendStart;
                            splatTexturesHeightness[index].blendStart = temp;
                        }

                        if (index >= 2)
                        {
                            if (splatTexturesHeightness[index].blendStart < splatTexturesHeightness[index - 2].blendEnd)
                            {
                                float temp = splatTexturesHeightness[index - 2].blendEnd;
                                splatTexturesHeightness[index - 2].blendEnd = splatTexturesHeightness[index].blendStart;
                                splatTexturesHeightness[index].blendStart = temp;
                            }
                        }
                    }
                    splatTexturesHeightness[0].blendCurve = new AnimationCurve(
                        new Keyframe(splatTexturesHeightness[0].blendStart, 1f, 0f, 0f),
                        new Keyframe(splatTexturesHeightness[1].blendStart, 1f, 0f, 0f),
                        new Keyframe(splatTexturesHeightness[0].blendEnd, 0f, 0f, 0f),
                        new Keyframe(1f, 0f, 0f, 0f));
                    for (int index = 1; index < splatTexturesHeightness.Count - 1; index++)
                    {
                        splatTexturesHeightness[index].blendCurve = new AnimationCurve(
                            new Keyframe(0f, 0f, 0f, 0f),
                            new Keyframe(splatTexturesHeightness[index].blendStart, 0f, 0f, 0f),
                            new Keyframe(splatTexturesHeightness[index - 1].blendEnd, 1f, 0f, 0f),
                            new Keyframe(splatTexturesHeightness[index + 1].blendStart, 1f, 0f, 0f),
                            new Keyframe(splatTexturesHeightness[index].blendEnd, 0f, 0f, 0f),
                            new Keyframe(1f, 0f, 0f, 0f));
                    }
                    splatTexturesHeightness[splatTexturesHeightness.Count - 1].blendCurve = new AnimationCurve(
                        new Keyframe(0f, 0f, 0f, 0f),
                        new Keyframe(splatTexturesHeightness[splatTexturesHeightness.Count - 1].blendStart, 0f, 0f, 0f),
                        new Keyframe(splatTexturesHeightness[splatTexturesHeightness.Count - 2].blendEnd, 1f, 0f, 0f),
                        new Keyframe(1f, 1f, 0f, 0f));
                    break;
            }

            if (splatTexturesSteepness.Count != 0)
            {
                splatTexturesSteepness[0].blendCurve = new AnimationCurve(
                    new Keyframe(0f, 0f, 0f, 0f),
                    new Keyframe(splatTexturesSteepness[0].blendStart, 0f, 0f, 0f),
                    new Keyframe(splatTexturesSteepness[0].blendEnd, 1f, 0f, 0f),
                    new Keyframe(90f, 1f, 0f, 0f));
            }
        } // private void CreateSplatTexturesBlendCurves()

        //==================================================================

        private DetailPrototype[] CreateDetailPrototypes()
        {
            // Create detail prototypes, using global settings as defined by user
            int nDetailPrototypeTotal = detailsProperties.Count;
            DetailPrototype[] newDetailPrototypes = new DetailPrototype[nDetailPrototypeTotal];
            for (int n = 0; n < nDetailPrototypeTotal; n++)
            {
                newDetailPrototypes[n] = new DetailPrototype();
                newDetailPrototypes[n].bendFactor = detailsProperties[n].bendFactor;
                newDetailPrototypes[n].dryColor = detailsProperties[n].color1;
                newDetailPrototypes[n].healthyColor = detailsProperties[n].color2;
                newDetailPrototypes[n].minHeight = detailsProperties[n].minScale;
                newDetailPrototypes[n].maxHeight = detailsProperties[n].maxScale;
                newDetailPrototypes[n].minWidth = detailsProperties[n].minScale;
                newDetailPrototypes[n].maxWidth = detailsProperties[n].maxScale;
                newDetailPrototypes[n].noiseSpread = 1f;
                newDetailPrototypes[n].renderMode = (detailsProperties[n].billboard) ? DetailRenderMode.GrassBillboard : DetailRenderMode.Grass;
                // 
                if (detailsProperties[n].prototypeTexture == null && detailsProperties[n].prototype == null)
                {
                    newDetailPrototypes[n].prototype = null;
                    Texture2D tempTexture2D = new Texture2D(1, 1, TextureFormat.ARGB32, false);
                    tempTexture2D.SetPixel(0, 0, Color.grey);
                    tempTexture2D.Apply();
                    newDetailPrototypes[n].prototypeTexture = tempTexture2D;
                    newDetailPrototypes[n].usePrototypeMesh = false;
                }
                else
                {
                    newDetailPrototypes[n].prototype = detailsProperties[n].prototype;
                    newDetailPrototypes[n].prototypeTexture = detailsProperties[n].prototypeTexture;
                    newDetailPrototypes[n].usePrototypeMesh = (newDetailPrototypes[n].prototype == null) ? false : true;
                }
            }
            return newDetailPrototypes;
        } // public DetailPrototype[] CreateDetailPrototypes()

        //==================================================================

        private TreePrototype[] CreateTreePrototypes()
        {
            // create 
            // - new tree prototypes, using global settings as defined by user
            // - their corresponding collider template prefabs.
            CreateTreeCollidersRootTransform();
            int ntreesTotal = treesProperties.Count;
            List<TreePrototype> newTreePrototypes = new List<TreePrototype>();

            if (treesProperties.Count > 0)
            {
                if (treesProperties[0].prototype == null)
                {
                    return new TreePrototype[0];
                }
            }
            for (int n = 0; n < ntreesTotal; n++)
            {
                newTreePrototypes.Add(new TreePrototype());
                if (treesProperties[n].prototype == null && n > 0)
                {
                    treesProperties[n].prototype = treesProperties[n - 1].prototype;
                }
                newTreePrototypes[n].prefab = treesProperties[n].prototype;
                newTreePrototypes[n].bendFactor = treesProperties[n].bendFactor;
                treesProperties[n].colliderPrefab = new GameObject("TreeColliderPrefab_" + n + "_(" + treesProperties[n].prototype.name + ")");
                treesProperties[n].colliderPrefab.transform.parent = treeCollidersRoot;
                treesProperties[n].colliderPrefab.layer = treeColliderLayer;
                treesProperties[n].colliderPrefab.SetActive(false);
                CopyColliders(source: ref treesProperties[n].prototype,
                    destiny: ref treesProperties[n].colliderPrefab,
                    disableCollidersOnSource: true);
                if (treesProperties[n].preventMeshOverlap)
                {
                    treesProperties[n].minDistance = GetRadiusFromMeshBoundingBoxes(treesProperties[n].prototype);
                }
                else
                {
                    treesProperties[n].minDistance = 1f / (Mathf.Sqrt(treesProperties[n].density) * 0.01f);
                }
            }
            return newTreePrototypes.ToArray();// as TreePrototype[];
        } // private TreePrototype[] CreateTreePrototypes()

        //==================================================================

        private void CreateTreeCollidersRootTransform()
        {
            // All treeColliders will be placed under this root
            treeCollidersRoot = transform.Find("_TreeColliders_");
            if (treeCollidersRoot == null)
            {
                treeCollidersRoot = (new GameObject("_TreeColliders_")).transform;
                treeCollidersRoot.parent = transform;
                treeCollidersRoot.gameObject.isStatic = true;
            }
        } // private void CreateTreeCollidersRootTransform()

        //==================================================================

        private float GetRadiusFromMeshBoundingBoxes(GameObject source)
        {
            // Get the radius from the Mesh bounding box
            float radius = 0f;
            MeshFilter[] meshFilters = source.GetComponentsInChildren<MeshFilter>();
            foreach (MeshFilter meshFilter in meshFilters)
            {
                Bounds bounds = meshFilter.sharedMesh.bounds;
                radius = Mathf.Max(radius, bounds.extents.x, bounds.extents.z);
            }
            return radius;
        } // private float GetRadiusFromMeshBoundingBoxes(GameObject source)

        //==================================================================

        private float GetRadiusFromRendererBoundingBoxes(GameObject source)
        {
            // Get the radius from the Renderer bounding box
            float radius = 0f;
            Renderer[] renderers = source.GetComponentsInChildren<Renderer>();
            foreach (Renderer rend in renderers)
            {
                Bounds bounds = rend.bounds;
                radius = Mathf.Max(radius, bounds.extents.x, bounds.extents.z);
            }
            return radius;
        } // private float GetRadiusFromRendererBoundingBoxes(GameObject source)

        //==================================================================

        private float GetRadiusFromColliders(GameObject source)
        {
            // Get the radius from the colliders (assuming capsule colliders to be oriented allong the world's Y-axis; for Mesh Colliders, the bounding box will be used.
            float radius = 0f;
            CapsuleCollider[] capsuleColliders = source.GetComponentsInChildren<CapsuleCollider>();
            foreach (CapsuleCollider capsuleCollider in capsuleColliders)
            {
                radius = Mathf.Max(radius, capsuleCollider.radius);
            }
            SphereCollider[] sphereColliders = source.GetComponentsInChildren<SphereCollider>();
            foreach (SphereCollider sphereCollider in sphereColliders)
            {
                radius = Mathf.Max(radius, sphereCollider.radius);
            }
            BoxCollider[] boxColliders = source.GetComponentsInChildren<BoxCollider>();
            foreach (BoxCollider boxCollider in boxColliders)
            {
                radius = Mathf.Max(radius, 0.5f * boxCollider.size.x, 0.5f * boxCollider.size.z);
            }
            MeshCollider[] meshColliders = source.GetComponentsInChildren<MeshCollider>();
            foreach (MeshCollider meshCollider in meshColliders)
            {
                radius = Mathf.Max(radius, meshCollider.sharedMesh.bounds.extents.x, meshCollider.sharedMesh.bounds.extents.x);
            }
            return radius;
        } // private float GetRadiusFromColliders(GameObject source)

        //==================================================================

        public void AdjustPlayerCameraMaxDistance()
        {
            // Adjust the main camera far clipping plane; it will be set to it's maximum value, where it will never be able to "look beyond the edge"
            if (player != null)
            {
                Camera.main.farClipPlane = Mathf.Max(1, tileLayout.vertical - 1) * heightmapSize * 0.5f;
            }
        } // public void AdjustPlayerCameraMaxDistance()

        //==================================================================

    } // public partial class EasyTerrain : MonoBehaviour

} // namespace MouseSoftware