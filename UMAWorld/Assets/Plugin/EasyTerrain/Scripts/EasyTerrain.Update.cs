using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Threading;
using System.Linq;

namespace MouseSoftware
{
    public partial class EasyTerrain : MonoBehaviour
    {
        //==================================================================

        public void Update()
        {
            // make sure the player can never get below the surface
            if (player != null)
            {
                float playerMinimumAllowedHeight = GetTerrainSample(player.position).height;
                //if (isIsland)
                //{
                //    playerMinimumAllowedHeight = Mathf.Max(playerMinimumAllowedHeight, heightmapMaxHeight * islandSeaLevel);
                //}
                if (player.position.y < playerMinimumAllowedHeight)
                {
                    player.position = new Vector3(player.position.x, playerMinimumAllowedHeight, player.position.z);
                }
            }
            // Are there any trees that need to be removed?
            ProcessDetachedTreesQueue();
        }

        //==================================================================

        private IEnumerator UpdateTiles()
        {
            do // while (Application.isPlaying);
            {
                if (player)
                {
                    UpdateTilesPositions();
                }
                
                // retrieve the number of tiles that needs to be updated
                int tileUpdateRequested = 0;
                foreach (Tile tile in tileList)
                {
                    if (tile.updateStatus == TileUpdateStatus.UpdateNeeded)
                    {
                        tileUpdateRequested++;
                    }
                }

                // only continue when there are tiles that needs to be updated
                if (tileUpdateRequested == 0)
                {
                    yield return _endOfFrame;
                    continue;
                }

                // reset the updateStatus and updateTime
                _updateStatus = 0;
                _updateStatusDelta = (Application.isPlaying) ? 0.90f / (tileUpdateRequested * 6f) : 1.0f / (tileUpdateRequested * 6f);
                _stopwatch.Reset();
                _stopwatch.Start();

                // Create some temporary variables that will be used to cache samples during a tile update proces
                int terrainSamplesResolutionInt = Mathf.Max(heightmapResolution.resolutionInt, alphamapResolution.resolutionInt);
                TerrainSample[,] terrainSamples = new TerrainSample[terrainSamplesResolutionInt, terrainSamplesResolutionInt];
                float[,] heightmap = new float[heightmapResolution.resolutionInt, heightmapResolution.resolutionInt];
                float[,,] splatmap = new float[alphamapResolution.resolutionInt, alphamapResolution.resolutionInt, splatTexturesHeightness.Count + splatTexturesSteepness.Count];
                Vector3 playerPosition = (player != null) ? player.position : Vector3.zero;
                List<GameObject> listOfChildGameObjects = new List<GameObject>();
                List<Transform> listOfChildTransforms = new List<Transform>();

                // Sort the tilelist, so tiles that are closest to the player will be updated first
                tileList.Sort((d1, d2) => d1.distanceToPlayer.CompareTo(d2.distanceToPlayer));

                // Move through the tilelist and update a tile when necessary
                foreach (Tile tile in tileList)
                {
                    if (tile.updateStatus == TileUpdateStatus.UpdateNeeded)
                    {
                        tile.updateStatus = TileUpdateStatus.UpdateInProgress;

                        // Disable all child gameobjects and their colliders
                        listOfChildTransforms.Clear();
                        listOfChildTransforms = tile.gameObject.GetComponentsInChildren<Transform>(true).ToList();
                        listOfChildTransforms.RemoveAt(0); // remove reference to tile itself;
                        foreach (Transform childTransform in listOfChildTransforms)
                        {
                            DisableAllColliders(childTransform.gameObject);
                            childTransform.gameObject.SetActive(false);
                        }

                        // do not show the tile during update proces
                        tile.terrain.enabled = false;
                        Vector3 tilePosition = tile.terrain.transform.position;

                        // Start separate thread to create terrainSamples
                        ThreadStart UpdateTiles_TerrainSamplesThreadStarter = () => UpdateTiles_TerrainSamplesThread(ref terrainSamples, tilePosition);
                        _terrainSamplesThread = new Thread(UpdateTiles_TerrainSamplesThreadStarter);
                        _terrainSamplesThread.Start();
                        while (_terrainSamplesThread.IsAlive)
                        {
                            yield return _endOfFrame;
                        }
                        _updateStatus += _updateStatusDelta;

                        // Start separate thread to create heightmap
                        ThreadStart UpdateTiles_HeightmapThreadStarter = () => UpdateTiles_HeightmapThread(ref heightmap, ref terrainSamples);
                        _heightmapThread = new Thread(UpdateTiles_HeightmapThreadStarter);
                        _heightmapThread.Start();
                        while (_heightmapThread.IsAlive)
                        {
                            yield return _endOfFrame;
                        }
                        tile.terrain.terrainData.SetHeights(0, 0, heightmap);
                        _updateStatus += _updateStatusDelta;

                        // Start separate thread to create alphamap
                        ThreadStart UpdateTiles_AlphamapThreadStarter = () => UpdateTiles_AlphamapThread(ref splatmap, ref terrainSamples);
                        _alphamapThread = new Thread(UpdateTiles_AlphamapThreadStarter);
                        _alphamapThread.Start();
                        while (_alphamapThread.IsAlive)
                        {
                            yield return _endOfFrame;
                        }
                        tile.terrain.terrainData.SetAlphamaps(0, 0, splatmap);
                        _updateStatus += _updateStatusDelta;

                        // Start separate thread to create grass/detailmap
                        if (drawTreesAndFoliage)
                        {
                            ThreadStart UpdateTiles_detailmapThreadStarter = () => UpdateTiles_detailmapThread(ref splatmap);
                            _detailmapThread = new Thread(UpdateTiles_detailmapThreadStarter);
                            _detailmapThread.Start();
                            while (_detailmapThread.IsAlive)
                            {
                                yield return _endOfFrame;
                            }
                            for (int detailIndex = 0; detailIndex < detailsProperties.Count; detailIndex++)
                            {
                                tile.terrain.terrainData.SetDetailLayer(0, 0, detailIndex, detailsProperties[detailIndex].detailLayer);
                            }
                        }
                        _updateStatus += _updateStatusDelta;

                        // Start separate thread to create gameobjects (part 1: only find suitable locations)
                        List<GameObjectToBePlaced> gameObjectsToBePlacedOnTile = new List<GameObjectToBePlaced>();
                        ThreadStart UpdateTiles_gameObjectsPlacementThreadStarter = () => UpdateTiles_gameObjectsPlacementThread(ref gameObjectsToBePlacedOnTile, ref splatmap, tilePosition, playerPosition);
                        _gameObjectsPlacementThread = new Thread(UpdateTiles_gameObjectsPlacementThreadStarter);
                        _gameObjectsPlacementThread.Start();
                        while (_gameObjectsPlacementThread.IsAlive)
                        {
                            yield return _endOfFrame;
                        }
                        _updateStatus += 0.5f * _updateStatusDelta;

                        // Start separate thread to create trees
                        if (drawTreesAndFoliage)
                        {
                            foreach (TreeInfo treeInstanceInfo in tile.treeInfoList)
                            {
                                if (treeInstanceInfo.colliderInstance != null)
                                {
                                    treeInstanceInfo.colliderInstance.SetActive(false);
                                    treeInstanceInfo.colliderInstance = null;
                                }
                            }
                            tile.treeInfoList.Clear();
                            TreeInstance[] treeInstances = new TreeInstance[0];
                            List<TreeInfo> treeInfoList = tile.treeInfoList.GetRange(0, tile.treeInfoList.Count);
                            ThreadStart UpdateTiles_treesPlacementThreadStarter = () => UpdateTiles_treesPlacementThread(ref treeInstances, ref splatmap, ref gameObjectsToBePlacedOnTile, tilePosition, playerPosition, ref treeInfoList);
                            _treesPlacementThread = new Thread(UpdateTiles_treesPlacementThreadStarter);
                            _treesPlacementThread.Start();
                            while (_treesPlacementThread.IsAlive)
                            {
                                yield return _endOfFrame;
                            }
                            tile.treeInfoList = treeInfoList;
                            tile.terrain.terrainData.treeInstances = treeInstances;
                        }
                        _updateStatus += _updateStatusDelta;

                        // Start separate thread to create GameObjects (part 2: Go through cache and reuse existing gameobjects, or create additional versions)
                        listOfChildGameObjects.Clear();
                        foreach (Transform childTransform in listOfChildTransforms)
                        {
                            listOfChildGameObjects.Add(childTransform.gameObject);
                        }
                        bool copyExistsInScene = false;
                        foreach (GameObjectToBePlaced gameObjectToBePlacedOnTile in gameObjectsToBePlacedOnTile)
                        {
                            copyExistsInScene = false;
                            foreach (GameObject childGameObject in listOfChildGameObjects)
                            {
                                if (!childGameObject.activeInHierarchy)
                                {
                                    if (childGameObject.name == gameObjectsProperties[gameObjectToBePlacedOnTile.gameObjectsPropertiesID].prototype.name)
                                    {
                                        childGameObject.SetActive(true);
                                        DisableAllColliders(childGameObject.gameObject);
                                        childGameObject.transform.position = gameObjectToBePlacedOnTile.position;
                                        childGameObject.transform.rotation = gameObjectToBePlacedOnTile.rotation;
                                        childGameObject.transform.localScale = gameObjectToBePlacedOnTile.scale * Vector3.one;
                                        copyExistsInScene = true;
                                        break;
                                    }
                                }
                            }
                            if (!copyExistsInScene)
                            {
                                Transform tempTransform = Instantiate(gameObjectsProperties[gameObjectToBePlacedOnTile.gameObjectsPropertiesID].prototype).transform;
                                tempTransform.position = gameObjectToBePlacedOnTile.position;
                                tempTransform.rotation = gameObjectToBePlacedOnTile.rotation;
                                tempTransform.parent = tile.terrain.transform;
                                tempTransform.localScale = gameObjectToBePlacedOnTile.scale * Vector3.one;
                                tempTransform.name = gameObjectsProperties[gameObjectToBePlacedOnTile.gameObjectsPropertiesID].prototype.name;
                                DisableAllColliders(tempTransform.gameObject);
                            }
                        }
                        _updateStatus += 0.5f * _updateStatusDelta;

                        // Finalize: Activate the tile and mark it to be flushed further on
                        tile.updateStatus = TileUpdateStatus.FlushNeeded;
                        tile.terrain.enabled = true;
                    }
                }

                // almost done ;-)
                _updateStatus = (Application.isPlaying) ? 0.90f : 1.0f; 

                // Make sure all tiles know who the (new) neighbours are, and obtain the number of tiles that need to be flushed
                UpdateTilesNeighbours();
                int flushRequested = 0;
                foreach (Tile tile in tileList)
                {
                    if (tile.updateStatus == TileUpdateStatus.FlushNeeded)
                    {
                        flushRequested++;
                    }
                }

                // Now flush all tiles that are marked "FlushNeeded". 
                // Flushing several terrain tiles in sequence might produce a decrease in FPS, so set a small waiting time between two flushes
                foreach (Tile tile in tileList)
                {
                    if (tile.updateStatus == TileUpdateStatus.FlushNeeded)
                    {
                        if (Application.isPlaying)
                        {
                            yield return new WaitForSecondsRealtime(2f / flushRequested);
                        }
                        tile.terrain.Flush();
                        _updateStatusDelta = 0.10f / flushRequested;
                        _updateStatus += _updateStatusDelta;
                    }
                    tile.updateStatus = TileUpdateStatus.Idle;
                }

                // And we're done!
                _updateStatus = 1f;
                _stopwatch.Stop();

                //Debug.Log("Update requested: " + tileUpdateRequested+" / Flushing requested " + flushRequested);
                //Debug.Log("EasyTerrain: update time = " + ((_stopwatch.Elapsed.Minutes * 60f) + (_stopwatch.Elapsed.Seconds) + (_stopwatch.Elapsed.Milliseconds * 0.001f)) + " seconds");

                yield return _endOfFrame;

            } while (Application.isPlaying && !isIsland);

            yield break;
        } // private IEnumerator UpdateTiles()

        //==================================================================

        private void UpdateTilesPositions()
        {
            // Cache some numbers and settings
            Vector3 playerPosition = player.position;
            Vector3 tilePosition;
            float hms = heightmapSize;
            int hor = tileLayout.horizontal;
            int ver = tileLayout.vertical;

            // Go through all tiles and update their positions if necesarry. In that case, also mark it as "UpdateNeeded"
            foreach (Tile tile in tileList)
            {
                tilePosition = tile.terrain.transform.position;

                while ((tilePosition.x - playerPosition.x) < -(hor + 1) * 0.505f * hms)
                {
                    tilePosition.x += hor * hms;
                    tile.gridX += hor;
                    tile.updateStatus = TileUpdateStatus.UpdateNeeded;
                }

                while ((tilePosition.x - playerPosition.x) > (hor - 1) * 0.505f * hms)
                {
                    tilePosition.x -= hor * hms;
                    tile.gridX -= hor;
                    tile.updateStatus = TileUpdateStatus.UpdateNeeded;
                }

                while ((tilePosition.z - playerPosition.z) < -(ver + 1) * 0.505f * hms)
                {
                    tilePosition.z += ver * hms;
                    tile.gridZ += ver;
                    tile.updateStatus = TileUpdateStatus.UpdateNeeded;
                }

                while ((tilePosition.z - playerPosition.z) > (ver - 1) * 0.505f * hms)
                {
                    tilePosition.z -= ver * hms;
                    tile.gridZ -= ver;
                    tile.updateStatus = TileUpdateStatus.UpdateNeeded;
                }

                if (tile.updateStatus == TileUpdateStatus.UpdateNeeded)
                {
                    tile.terrain.transform.position = tilePosition;
                    tile.gameObject.name = string.Format("Terrain [X={0:+#;-#;+0} & Y={1:+#;-#;+0}]", tile.gridX, tile.gridZ);
                    tile.terrain.enabled = false;
                }

                // Find and cache the current distance from this tile to the player (Closest tiles will be updated first)
                tile.distanceToPlayer = DistanceFromTileCenter(tile, playerPosition);
            }
        } // private void UpdateTilesPositions()

        //==================================================================

        private float DistanceFromTileCenter(Tile tile, Vector3 point)
        {
            // Find the current distance from this tile to the player (Closest tiles will be updated first)
            Vector3 tileCenter = tile.terrain.transform.position + new Vector3(heightmapSize * 0.5f, 0f, heightmapSize * 0.5f);
            Vector3 pointCenter = new Vector3(point.x, 0f, point.z);
            return Vector3.Distance(tileCenter, pointCenter);
        } // private float DistanceFromTileCenter(Tile tile, Vector3 point)


        //==================================================================

        private void UpdateTiles_TerrainSamplesThread(ref TerrainSample[,] terrainSamples, Vector3 tilePosition)
        {
            // Get a TerrainSample for each possible vertex in the tile
            Vector3 point;
            int terrainSamplesResolutionInt = (int)Mathf.Max(heightmapResolution.resolutionInt, alphamapResolution.resolutionInt);
            float hmsDtsri = heightmapSize / (float)(terrainSamplesResolutionInt - 1);
            for (int v = 0; v < terrainSamplesResolutionInt; v++)
            {
                for (int u = 0; u < terrainSamplesResolutionInt; u++)
                {
                    point = new Vector3(tilePosition.x + hmsDtsri * u, 0f, tilePosition.z + hmsDtsri * v);
                    terrainSamples[v, u] = GetTerrainSample(point);
                }
            }
        } // private void UpdateTiles_TerrainSamplesThread(ref TerrainSample[,] terrainSamples, Vector3 tilePosition)

        //==================================================================

        private void UpdateTiles_HeightmapThread(ref float[,] heightmap, ref TerrainSample[,] terrainSamples)
        {
            // Use the cached TerrainSamples to build a new heightmap
            int terrainSamplesResolutionInt = Mathf.Max(heightmapResolution.resolutionInt, alphamapResolution.resolutionInt);
            int heightmapResolutionInt = heightmapResolution.resolutionInt;
            int resolutionDiffFactor = (int)((terrainSamplesResolutionInt - 1) / (heightmapResolutionInt - 1));
            float divByHmMX = 1f / heightmapMaxHeight;

            for (int v = 0; v < heightmapResolutionInt; v++)
            {
                for (int u = 0; u < heightmapResolutionInt; u++)
                {
                    heightmap[u, v] = terrainSamples[u * resolutionDiffFactor, v * resolutionDiffFactor].height * divByHmMX;
                }
            }
        } // private void UpdateTiles_HeightmapThread(ref float[,] heightmap, ref TerrainSample[,] terrainSamples)

        //==================================================================

        private void UpdateTiles_AlphamapThread(ref float[,,] splatmap, ref TerrainSample[,] terrainSamples)
        {
            // Use the cached TerrainSamples to build a new heightmap
            int nHeightnessTextures = splatTexturesHeightness.Count;
            int nSteepnessTextures = splatTexturesSteepness.Count;
            int heightmapResolutionInt = heightmapResolution.resolutionInt;
            int alphamapResolutionInt = alphamapResolution.resolutionInt;
            int terrainSamplesResolutionInt = (int)Mathf.Max(heightmapResolutionInt, alphamapResolutionInt);
            int resolutionDiffFactor = (int)((terrainSamplesResolutionInt - 1) / (alphamapResolutionInt - 1));
            float steepnessFactor;
            float divByHmMX = 1f / heightmapMaxHeight;

            for (int v = 0; v < alphamapResolutionInt; v++)
            {
                for (int u = 0; u < alphamapResolutionInt; u++)
                {
                    steepnessFactor = (nSteepnessTextures > 0) ? splatTexturesSteepness[0].blendCurve.Evaluate(terrainSamples[u * resolutionDiffFactor, v * resolutionDiffFactor].steepness) : 0f;
                    for (int hc = 0; hc < nHeightnessTextures; hc++)
                    {
                        splatmap[u, v, hc] = splatTexturesHeightness[hc].blendCurve.Evaluate(terrainSamples[u * resolutionDiffFactor, v * resolutionDiffFactor].height * divByHmMX) * (1f - steepnessFactor);
                    }

                    for (int sc = 0; sc < nSteepnessTextures; sc++)
                    {
                        splatmap[u, v, sc + nHeightnessTextures] = steepnessFactor;
                    }
                }
            }
        } // private void UpdateTiles_AlphamapThread(ref float[,,] splatmap, ref TerrainSample[,] terrainSamples)

        //==================================================================

        private void UpdateTiles_detailmapThread(ref float[,,] splatmap)
        {
            // Use the cached splatmap to place grass / details
            int alphamapResolutionInt = alphamapResolution.resolutionInt;
            int detailResolutionInt = detailResolution.resolutionInt;
            int resolutionDiffFactor = (int)((alphamapResolutionInt - 1) / (detailResolutionInt - 1));
            float alphaValue;
            foreach (PropertiesGrass detailProperties in detailsProperties)
            {
                detailProperties.detailLayer = new int[detailResolutionInt, detailResolutionInt];
                int splatMapIndex = 0;
                foreach (bool applyToSplatTexture in detailProperties.applyToSplatTexture)
                {
                    if (applyToSplatTexture)
                    {
                        for (int j = 0; j < detailResolutionInt; j++)
                        {
                            for (int k = 0; k < detailResolutionInt; k++)
                            {
                                alphaValue = splatmap[(int)(resolutionDiffFactor * j), (int)(resolutionDiffFactor * k), splatMapIndex];
                                alphaValue *= detailProperties.strength;
                                detailProperties.detailLayer[j, k] += (int)Mathf.Round(alphaValue * ((float)detailResolutionIntPerPatch));
                            }
                        }
                    }
                    splatMapIndex++;
                }
            }
        } // private void UpdateTiles_detailmapThread(ref float[,,] splatmap)

        //==================================================================

        private void UpdateTiles_treesPlacementThread(ref TreeInstance[] treeInstances, ref float[,,] splatmap, ref List<GameObjectToBePlaced> gameObjectsToBePlaced, Vector3 tilePosition, Vector3 playerPosition, ref List<TreeInfo> treeInfoList)
        {
            // Use the cached splatmap and cached positions of gameobjects to determine where the trees shall be placed
            TreeInstance newTreeInstance = new TreeInstance();
            List<TreeInstance> newTreeInstancesList = new List<TreeInstance>();
            System.Random random = new System.Random(0);
            TerrainSample terrainSample;
            NoiseGenerator.NoiseSample noiseSample;
            int alphamapResolutionInt = alphamapResolution.resolutionInt;
            float worldPositionX, worldPositionY, worldPositionZ;
            Vector3 worldPosition;
            Vector3 localPosition;
            int totalTrees = 0;
            float playerMinDistance = playerStartupFreeRadius / heightmapSize;
            float playerMinDistanceSqr = playerMinDistance * playerMinDistance;
            float treeMinDistance = 0f;
            float treeMinDistanceSqr = 0f;
            float alphaValue = 0f;
            float noiseValue = 0f;
            float randomValue = 0f;
            AnimationCurve noiseValueCurve = AnimationCurve.Linear(0f, 0f, 1f, 1f);
            bool playerOnThisTile = (playerPosition.x > tilePosition.x &&
                                     playerPosition.x < tilePosition.x + heightmapSize &&
                                     playerPosition.z > tilePosition.z &&
                                     playerPosition.z < tilePosition.z + heightmapSize);

            if (treesProperties.Count > 0)
            {
                if (treesProperties[0].prototype == null)
                {
                    return;
                }
            }

            for (int n = 0; n < treesProperties.Count; n++)
            {
                totalTrees = (int)(treesProperties[n].density * heightmapSize * heightmapSize * 0.000001f);

                if (treesProperties[n].useNoiseLayer)
                {
                    noiseValueCurve = new AnimationCurve(new Keyframe(0f, 0f, 0f, 0f),
                                                         new Keyframe(treesProperties[n].noiseSettings.threshold, 0f, 0f, 0f),
                                                         new Keyframe(Mathf.Lerp(treesProperties[n].noiseSettings.threshold, 1f, treesProperties[n].noiseSettings.falloff), 1f, 0f, 0f),
                                                         new Keyframe(1f, 1f, 0f, 0f));
                }

                for (int i = 0; i < totalTrees; i++)
                {
                    newTreeInstance.prototypeIndex = n;
                    worldPositionX = random.Next((int)tilePosition.x, (int)(tilePosition.x + heightmapSize));
                    worldPositionY = 0f;
                    worldPositionZ = random.Next((int)tilePosition.z, (int)(tilePosition.z + heightmapSize));
                    worldPosition = new Vector3(worldPositionX, worldPositionY, worldPositionZ);
                    localPosition = new Vector3((worldPositionX - tilePosition.x) / heightmapSize, 0f, (worldPositionZ - tilePosition.z) / heightmapSize);

                    for (int splatMapIndex = 0; splatMapIndex < treesProperties[n].applyToSplatTexture.Length; splatMapIndex++)
                    {
                        if (treesProperties[n].applyToSplatTexture[splatMapIndex])
                        {
                            // Obtain a random value for this placement cycle
                            randomValue = random.Next(0, 1000) * 0.001f;

                            // Only place tree if this is the right texture, otherwise try the next texture 
                            alphaValue = splatmap[(int)(alphamapResolutionInt * localPosition.z), (int)(alphamapResolutionInt * (localPosition.x)), splatMapIndex];
                            if (randomValue >= alphaValue)
                            {
                                continue;
                            }

                            // only place tree if it's within the right noise limits, otherwise try the next texture
                            if (treesProperties[n].useNoiseLayer)
                            {
                                noiseSample = NoiseGenerator.Sum(
                                    NoiseGenerator.methods[(int)treesProperties[n].noiseSettings.type],
                                    new Vector3(worldPosition.x, treesProperties[n].noiseSettings.offsetY, worldPosition.z),
                                treesProperties[n].noiseSettings.frequency,
                                 treesProperties[n].noiseSettings.octaves,
                                treesProperties[n].noiseSettings.lacunarity,
                                treesProperties[n].noiseSettings.persistence);
                                noiseValue = noiseSample.value;
                                noiseValue = (noiseValue + 1f) * 0.5f;
                                noiseValue = noiseValueCurve.Evaluate(noiseValue);
                            }
                            else
                            {
                                noiseValue = 1f;
                            }

                            // try the next texture, if the above is not met...
                            if (randomValue >= noiseValue)
                            {
                                continue;
                            }

                            // or continue with this texture, and initialize some settings
                            terrainSample = GetTerrainSample(worldPosition);
                            localPosition = new Vector3(localPosition.x, terrainSample.height / heightmapMaxHeight, localPosition.z);
                            worldPosition = new Vector3(worldPosition.x, terrainSample.height, worldPosition.z);
                            //if (isIsland)
                            //{
                            //    if (terrainSample.height < islandSeaLevel*heightmapMaxHeight)
                            //    {
                            //        continue;
                            //    }
                            //}
                            newTreeInstance.position = localPosition;
                            newTreeInstance.heightScale = random.Next(0, 1000) * 0.001f * Mathf.Min(alphaValue, noiseValue);
                            newTreeInstance.heightScale *= treesProperties[n].maxScale - treesProperties[n].minScale;
                            newTreeInstance.heightScale += treesProperties[n].minScale;
                            newTreeInstance.widthScale = newTreeInstance.heightScale;
                            newTreeInstance.color = Color.LerpUnclamped(treesProperties[n].color1, treesProperties[n].color2, random.Next(0, 1000) * 0.001f);
                            newTreeInstance.lightmapColor = newTreeInstance.color;

                            // do not place near tile edges: in this case, skip all texture and start a new tree placement cycle
                            float treeToBePlacedSize = newTreeInstance.widthScale * treesProperties[n].minDistance;
                            if ((worldPosition.x + treeToBePlacedSize > tilePosition.x + heightmapSize) ||
                                (worldPosition.x - treeToBePlacedSize < tilePosition.x) ||
                                (worldPosition.z + treeToBePlacedSize > tilePosition.z + heightmapSize) ||
                                (worldPosition.z - treeToBePlacedSize < tilePosition.z))
                            {
                                break;
                            }

                            // do not place near (0,0,0) (=starting point player): in this case, skip all texture and start a new tree placement cycle
                            if (playerOnThisTile)
                            {
                                float sqrDist = (new Vector3(newTreeInstance.position.x - 0.5f, 0f, newTreeInstance.position.z - 0.5f)).sqrMagnitude;
                                if (sqrDist < playerMinDistanceSqr)
                                {
                                    break;
                                }
                            }

                            // If meshes may not overlap, iterate all currently placed trees and gameobjects, to check if they do not overlap with the current new tree
                            if (treesProperties[n].preventMeshOverlap)
                            {
                                bool continueToNextIteration = false;
                                foreach (TreeInstance existingTreeInstance in newTreeInstancesList)
                                {
                                    treeMinDistance = treesProperties[existingTreeInstance.prototypeIndex].minDistance * existingTreeInstance.widthScale;
                                    treeMinDistance += treesProperties[n].minDistance * newTreeInstance.widthScale;
                                    treeMinDistanceSqr = (treeMinDistance * treeMinDistance) / (heightmapSize * heightmapSize);
                                    if ((existingTreeInstance.position - newTreeInstance.position).sqrMagnitude < treeMinDistanceSqr)
                                    {
                                        continueToNextIteration = true;
                                        break;
                                    }
                                }
                                foreach (GameObjectToBePlaced gameObjectToBePlaced in gameObjectsToBePlaced)
                                {
                                    treeMinDistance = gameObjectToBePlaced.minDistance * gameObjectToBePlaced.scale;
                                    treeMinDistance += treesProperties[n].minDistance * newTreeInstance.widthScale;
                                    treeMinDistanceSqr = (treeMinDistance * treeMinDistance);
                                    if ((gameObjectToBePlaced.position - worldPosition).sqrMagnitude < treeMinDistanceSqr)
                                    {
                                        continueToNextIteration = true;
                                        break;
                                    }
                                }
                                if (continueToNextIteration)
                                {
                                    continue;
                                }
                            }

                            // Everything is ok, so finally add the new tree and break current loop, to move on to the next new tree
                            newTreeInstancesList.Add(newTreeInstance);
                            treeInfoList.Add(new TreeInfo());
                            int lastIndex = treeInfoList.Count - 1;
                            treeInfoList[lastIndex].worldPosition = worldPosition;
                            treeInfoList[lastIndex].localPosition = localPosition;
                            treeInfoList[lastIndex].scale = new Vector3(newTreeInstance.widthScale, newTreeInstance.heightScale, newTreeInstance.widthScale);
                            treeInfoList[lastIndex].hasActiveCollider = false;
                            //treeInfoList[lastIndex].colliderInstance = null;
                            treeInfoList[lastIndex].prototypeIndex = n;
                            break;
                        }
                    }
                }
            }
            // Convert the List to an Array, because that's how Unity's terrain engine wants it.
            treeInstances = newTreeInstancesList.ToArray();
        } // private void UpdateTiles_treesPlacementThread(ref TreeInstance[] treeInstances, ref float[,,] splatmap, ref List<GameObjectToBePlaced> gameObjectsToBePlaced, Vector3 tilePosition, Vector3 playerPosition, ref List<TreeInfo> treeInfoList)

        //==================================================================

        private struct GameObjectToBePlaced
        {
            public int gameObjectsPropertiesID;
            public Vector3 position;
            public Quaternion rotation;
            public float scale;
            public float minDistance;
        } // private struct GameObjectToBePlaced

        //==================================================================

        private void UpdateTiles_gameObjectsPlacementThread(ref List<GameObjectToBePlaced> gameObjectsToBePlacedOnTile, ref float[,,] splatmap, Vector3 tilePosition, Vector3 playerPosition)
        {
            // Use the cached splatmap to determine where the gameobjects shall be placed
            gameObjectsToBePlacedOnTile.Clear();
            int totalGameObjects = 0;
            System.Random random = new System.Random(100000);
            GameObjectToBePlaced gameObjectToBePlaced;
            TerrainSample terrainSample;
            NoiseGenerator.NoiseSample noiseSample;
            int alphamapResolutionInt = alphamapResolution.resolutionInt;
            float pointX, pointY, pointZ;
            Vector3 point;
            Vector3 relPoint;
            float minDistance = 0f;
            float minDistanceSqr = 0f;
            float alphaValue = 0f;
            float noiseValue = 0f;
            float randomValue = 0f;
            AnimationCurve noiseValueCurve = AnimationCurve.Linear(0f, 0f, 1f, 1f);
            bool playerOnThisTile = (playerPosition.x > tilePosition.x &&
                                     playerPosition.x < tilePosition.x + heightmapSize &&
                                     playerPosition.z > tilePosition.z &&
                                     playerPosition.z < tilePosition.z + heightmapSize);

            for (int n = 0; n < gameObjectsProperties.Count; n++)
            {
                if (gameObjectsProperties[n].prototype == null)
                {
                    continue;
                }

                totalGameObjects = (int)(gameObjectsProperties[n].density * heightmapSize * heightmapSize * 0.000001f);

                if (gameObjectsProperties[n].useNoiseLayer)
                {
                    noiseValueCurve = new AnimationCurve(new Keyframe(0f, 0f, 0f, 0f),
                                                         new Keyframe(gameObjectsProperties[n].noiseSettings.threshold, 0f, 0f, 0f),
                                                         new Keyframe(Mathf.Lerp(gameObjectsProperties[n].noiseSettings.threshold, 1f, gameObjectsProperties[n].noiseSettings.falloff), 1f, 0f, 0f),
                                                         new Keyframe(1f, 1f, 0f, 0f));
                }


                for (int i = 0; i < totalGameObjects; i++)
                {
                    gameObjectToBePlaced = new GameObjectToBePlaced();

                    pointX = random.Next((int)tilePosition.x, (int)(tilePosition.x + heightmapSize));
                    pointY = 0f;
                    pointZ = random.Next((int)tilePosition.z, (int)(tilePosition.z + heightmapSize));
                    point = new Vector3(pointX, pointY, pointZ);
                    relPoint = new Vector3((pointX - tilePosition.x) / heightmapSize, 0f, (pointZ - tilePosition.z) / heightmapSize);

                    for (int splatMapIndex = 0; splatMapIndex < gameObjectsProperties[n].applyToSplatTexture.Length; splatMapIndex++)
                    {
                        if (gameObjectsProperties[n].applyToSplatTexture[splatMapIndex])
                        {
                            // Obtain a random value for this placement cycle
                            randomValue = random.Next(0, 1000) * 0.001f;

                            // Only place gameobejct if this is the right texture, otherwise try the next texture 
                            alphaValue = splatmap[(int)(alphamapResolutionInt * relPoint.z), (int)(alphamapResolutionInt * (relPoint.x)), splatMapIndex];
                            if (randomValue >= alphaValue)
                            {
                                continue;
                            }

                            // only place gameobject if it's within the right noise limits, otherwise try the next texture
                            if (gameObjectsProperties[n].useNoiseLayer)
                            {
                                noiseSample = NoiseGenerator.Sum(
                                    NoiseGenerator.methods[(int)gameObjectsProperties[n].noiseSettings.type],
                                    new Vector3(point.x, gameObjectsProperties[n].noiseSettings.offsetY, point.z),
                                    gameObjectsProperties[n].noiseSettings.frequency, 1, 1, 1);
                                noiseValue = noiseSample.value;
                                noiseValue = (noiseValue + 1f) * 0.5f;
                                noiseValue = noiseValueCurve.Evaluate(noiseValue);
                            }
                            else
                            {
                                noiseValue = 1f;
                            }

                            // try yhe next texture, if the above is not met...
                            if (randomValue >= noiseValue)
                            {
                                continue;
                            }

                            // Get some properties of the terrain at this point
                            terrainSample = GetTerrainSample(point);

                            //// don't place objects below sealevel
                            //if (isIsland)
                            //{
                            //    if (terrainSample.height < islandSeaLevel * heightmapMaxHeight)
                            //    {
                            //        continue;
                            //    }
                            //}

                            // only place gameobject if the terrain is not to steep
                            if (terrainSample.steepness >= gameObjectsProperties[n].maxSteepness)
                            {
                                continue;
                            }

                            // Configure some settings
                            gameObjectToBePlaced.gameObjectsPropertiesID = n;
                            gameObjectToBePlaced.scale = gameObjectsProperties[n].minScale + random.Next(0, 1000) * 0.001f * (gameObjectsProperties[n].maxScale - gameObjectsProperties[n].minScale);
                            gameObjectToBePlaced.minDistance = gameObjectsProperties[n].minDistance;

                            // Should the gameobject be placed horizontally, or follow the curvature of the terrain?
                            if (gameObjectsProperties[n].forceHorizontalPlacement)
                            {
                                float offsetY = -Mathf.Tan(Mathf.Deg2Rad * terrainSample.steepness) * gameObjectToBePlaced.minDistance;
                                gameObjectToBePlaced.position = new Vector3(point.x, terrainSample.height + offsetY, point.z);
                                gameObjectToBePlaced.rotation = Quaternion.AngleAxis(random.Next(0, 359), Vector3.up);
                            }
                            else
                            {
                                gameObjectToBePlaced.position = new Vector3(point.x, terrainSample.height, point.z);
                                gameObjectToBePlaced.rotation = Quaternion.FromToRotation(Vector3.up, terrainSample.normal);
                                gameObjectToBePlaced.rotation *= Quaternion.AngleAxis(random.Next(0, 359), Vector3.up);
                            }

                            // do not place near tile edges
                            float gameObjectToBePlacedSize = gameObjectToBePlaced.scale * gameObjectsProperties[n].minDistance;
                            if ((gameObjectToBePlaced.position.x + gameObjectToBePlacedSize > tilePosition.x + heightmapSize) ||
                                (gameObjectToBePlaced.position.x - gameObjectToBePlacedSize < tilePosition.x) ||
                                (gameObjectToBePlaced.position.z + gameObjectToBePlacedSize > tilePosition.z + heightmapSize) ||
                                (gameObjectToBePlaced.position.z - gameObjectToBePlacedSize < tilePosition.z))
                            {
                                break;
                            }

                            // do not place near (0,0,0) (=starting point player)
                            if (playerOnThisTile)
                            {
                                float sqrDist = (new Vector3(gameObjectToBePlaced.position.x, 0f, gameObjectToBePlaced.position.z)).sqrMagnitude;
                                if (sqrDist < playerStartupFreeRadius * playerStartupFreeRadius)
                                {
                                    break;
                                }
                            }

                            // If meshes may not overlap, iterate all currently placed gameobjects, to check if they do not overlap with the current new gameObject
                            if (gameObjectsProperties[n].preventMeshOverlap)
                            {
                                bool continueToNextIteration = false;
                                foreach (GameObjectToBePlaced existingGameObjectsToBePlacedOnTile in gameObjectsToBePlacedOnTile)
                                {
                                    minDistance = existingGameObjectsToBePlacedOnTile.minDistance * existingGameObjectsToBePlacedOnTile.scale;
                                    minDistance += gameObjectToBePlaced.minDistance * gameObjectToBePlaced.scale;
                                    minDistanceSqr = (minDistance * minDistance);
                                    if ((existingGameObjectsToBePlacedOnTile.position - gameObjectToBePlaced.position).sqrMagnitude < minDistanceSqr)
                                    {
                                        continueToNextIteration = true;
                                        break;
                                    }
                                }
                                if (continueToNextIteration)
                                {
                                    continue;
                                }
                            }

                            // Finally, add the gameobject to the list, so it can be placed further on
                            gameObjectsToBePlacedOnTile.Add(gameObjectToBePlaced);
                            break;
                        }
                    }
                }
            }
        } // private void UpdateTiles_gameObjectsPlacementThread(ref List<GameObjectToBePlaced> gameObjectsToBePlacedOnTile, ref float[,,] splatmap, Vector3 tilePosition, Vector3 playerPosition)

        //==================================================================

        private void UpdateTilesNeighbours()
        {
            Terrain left;
            Terrain top;
            Terrain right;
            Terrain bottom;

            // Loop through all terrains...
            foreach (Tile tile in tileList)
            {
                left = null;
                top = null;
                right = null;
                bottom = null;

                // .... and check which terrains are on the left, right, top or bottom, by checking their gridXYZ values
                for (int index = 0; index < tileList.Count; index++)
                {
                    if ((tileList[index].gridX == tile.gridX - 1) && (tileList[index].gridZ == tile.gridZ))
                    {
                        left = tileList[index].terrain;
                    }
                    if ((tileList[index].gridX == tile.gridX + 1) && (tileList[index].gridZ == tile.gridZ))
                    {
                        right = tileList[index].terrain;
                    }
                    if ((tileList[index].gridX == tile.gridX) && (tileList[index].gridZ == tile.gridZ - 1))
                    {
                        bottom = tileList[index].terrain;
                    }
                    if ((tileList[index].gridX == tile.gridX) && (tileList[index].gridZ == tile.gridZ + 1))
                    {
                        top = tileList[index].terrain;
                    }
                }

                if (tile.neighbourLeft != left || tile.neighbourRight != right || tile.neighbourTop != top || tile.neighbourBottom != bottom)
                {
                    // Mark each tile as "FlushNeeded", when they have different neighbours then before. 
                    tile.terrain.SetNeighbors(left, top, right, bottom);
                    tile.updateStatus = TileUpdateStatus.FlushNeeded;
                    // and assign the new neighbours
                    tile.neighbourLeft = left;
                    tile.neighbourRight = right;
                    tile.neighbourTop = top;
                    tile.neighbourBottom = bottom;
                }
            }
        } // public void UpdateTilesNeighbours()

        //==================================================================

        //==================================================================

        private IEnumerator UpdateColliders()
        {
            // first wait untill the center tile has been updated (because that's where the player starts)
            do
            {
                yield return _endOfFrame;
            } while (tileList[0].updateStatus == TileUpdateStatus.UpdateInProgress || tileList[0].updateStatus == TileUpdateStatus.UpdateNeeded);

            do // while (Application.isPlaying);
            {
                bool forceColliderUpdate = false;
                // Are there any new colliderAgents that the user wants to be added?
                foreach (ColliderAgent newColliderAgent in newColliderAgentsQueue)
                {
                    colliderAgents.Add(newColliderAgent);
                    forceColliderUpdate = true;
                }
                newColliderAgentsQueue.Clear();

                // Are there any collideragents that the user wants to be removed?
                foreach (Transform removeColliderAgent in removeColliderAgentsQueue)
                {
                    for (int cai = colliderAgents.Count - 1; cai >= 0; cai--)
                    {
                        if (colliderAgents[cai].agentTransform.Equals(removeColliderAgent))
                        {
                            colliderAgents.RemoveAt(cai);
                            forceColliderUpdate = true;
                        }
                    }
                }
                removeColliderAgentsQueue.Clear();

                // perform some default checks: is the player still an colliderAgent? Do all colliderAgents still exist?
                ColliderAgentsCheckPopulation();

                // Update the colliders by force if necessary...
                if (forceColliderUpdate)
                {
                    foreach (ColliderAgent collAgent in colliderAgents)
                    {
                        collAgent.positionCache = collAgent.agentTransform.position;
                    }
                    int tileIndex = 0;
                    foreach (Tile tile in tileList)
                    {
                        if ((tile.updateStatus == TileUpdateStatus.UpdateInProgress || tile.updateStatus == TileUpdateStatus.UpdateNeeded))
                        {
                            continue;
                        }
                        UpdateTreeColliders(tileIndex);
                        UpdateGameObjectColliders(tileIndex);

                        tileIndex++;
                    }
                }
                // ... or check if a collider update is necessary, because the colliderAgents have moved too far.
                else
                {
                    foreach (ColliderAgent colliderAgent in colliderAgents)
                    {
                        if (!PointsWithinSqrRange(colliderAgent.agentTransform.position, colliderAgent.positionCache, 0.1f * Mathf.Min(colliderAgent.treeColliderDistance, colliderAgent.gameObjectColliderDistance)))
                        {
                            foreach (ColliderAgent collAgent in colliderAgents)
                            {
                                collAgent.positionCache = collAgent.agentTransform.position;
                            }
                            int tileIndex = 0;
                            foreach (Tile tile in tileList)
                            {
                                if ((tile.updateStatus == TileUpdateStatus.UpdateInProgress || tile.updateStatus == TileUpdateStatus.UpdateNeeded))
                                {
                                    continue;
                                }
                                UpdateTreeColliders(tileIndex);
                                UpdateGameObjectColliders(tileIndex);

                                tileIndex++;
                            }
                            break;
                        }
                    }
                }

                yield return new WaitForSecondsRealtime(1f);
            }
            while (Application.isPlaying);
        } // private IEnumerator UpdateColliders()

        //==================================================================

        private void UpdateTreeColliders(int tileIndex)
        {
            // reset all tree colliders
            foreach (TreeInfo treeInstanceInfo in tileList[tileIndex].treeInfoList)
            {
                treeInstanceInfo.hasActiveCollider = false;
            }

            // Check if a tree is within the right distance from a colliderAgent, then tag it with an active collider
            foreach (ColliderAgent colliderAgent in colliderAgents)
            {
                if ((tileList[tileIndex].gameObject.transform.position.x > colliderAgent.agentTransform.position.x + colliderAgent.treeColliderDistance) ||
                    (tileList[tileIndex].gameObject.transform.position.x < colliderAgent.agentTransform.position.x - colliderAgent.treeColliderDistance - heightmapSize) ||
                    (tileList[tileIndex].gameObject.transform.position.z > colliderAgent.agentTransform.position.z + colliderAgent.treeColliderDistance) ||
                    (tileList[tileIndex].gameObject.transform.position.z < colliderAgent.agentTransform.position.z - colliderAgent.treeColliderDistance - heightmapSize))
                {
                    continue;
                }

                foreach (TreeInfo treeInstanceInfo in tileList[tileIndex].treeInfoList)
                {
                    if (treesProperties[treeInstanceInfo.prototypeIndex].prototype == null || treesProperties[treeInstanceInfo.prototypeIndex].colliderPrefab == null)
                    {
                        continue;
                    }

                    if (PointsWithinSqrRange(colliderAgent.agentTransform.position, treeInstanceInfo.worldPosition, colliderAgent.treeColliderDistance))
                    {
                        treeInstanceInfo.hasActiveCollider = true;
                    }
                }
            }

            // go through all cached treeCollider, and reuse colliders where possible. Otherwise, create a new instance of the treeCollider.
            int[] treeInstanceIndex = new int[treesProperties.Count];
            GameObject currentCollider;
            foreach (TreeInfo treeInstanceInfo in tileList[tileIndex].treeInfoList)
            {
                if (treeInstanceInfo.hasActiveCollider == false)
                {
                    if (treeInstanceInfo.colliderInstance != null)
                    {
                        treeInstanceInfo.colliderInstance.SetActive(false);
                        treeInstanceInfo.colliderInstance = null;
                    }
                }
                if (treeInstanceInfo.hasActiveCollider == true && treeInstanceInfo.colliderInstance == null)
                {
                    if (treesProperties[treeInstanceInfo.prototypeIndex].colliders.Count <= treeInstanceIndex[treeInstanceInfo.prototypeIndex])
                    {
                        currentCollider = Instantiate(treesProperties[treeInstanceInfo.prototypeIndex].colliderPrefab);
                        currentCollider.transform.parent = treeCollidersRoot;
                        currentCollider.transform.position = treeInstanceInfo.worldPosition;
                        currentCollider.transform.localScale = treeInstanceInfo.scale;
                        currentCollider.layer = treeColliderLayer;
                        currentCollider.SetActive(true);
                        treesProperties[treeInstanceInfo.prototypeIndex].colliders.Add(currentCollider);

                        treeInstanceInfo.colliderInstance = currentCollider;
                        treeInstanceIndex[treeInstanceInfo.prototypeIndex]++;
                        continue;
                    }

                    while (treesProperties[treeInstanceInfo.prototypeIndex].colliders[treeInstanceIndex[treeInstanceInfo.prototypeIndex]].activeInHierarchy)
                    {
                        treeInstanceIndex[treeInstanceInfo.prototypeIndex]++;
                        if (treesProperties[treeInstanceInfo.prototypeIndex].colliders.Count <= treeInstanceIndex[treeInstanceInfo.prototypeIndex])
                        {
                            currentCollider = Instantiate(treesProperties[treeInstanceInfo.prototypeIndex].colliderPrefab);
                            currentCollider.transform.parent = treeCollidersRoot;
                            treesProperties[treeInstanceInfo.prototypeIndex].colliders.Add(currentCollider);
                            break;
                        }
                    }
                    currentCollider = treesProperties[treeInstanceInfo.prototypeIndex].colliders[treeInstanceIndex[treeInstanceInfo.prototypeIndex]];
                    currentCollider.transform.position = treeInstanceInfo.worldPosition;
                    currentCollider.transform.localScale = treeInstanceInfo.scale;
                    currentCollider.SetActive(true);
                    treeInstanceInfo.colliderInstance = currentCollider;
                }
            }
        } // private void UpdateTreeColliders(int tileIndex)

        //==================================================================

        private void UpdateGameObjectColliders(int tileIndex)
        {
            // Disable all colliders of all the gameobjects on this tile
            List<Transform> childTransforms = tileList[tileIndex].gameObject.GetComponentsInChildren<Transform>(true).ToList();
            childTransforms.RemoveAt(0); // remove reference to tile itself;
            foreach (Transform childTransform in childTransforms)
            {
                DisableAllColliders(childTransform.gameObject);
            }

            // now iterate through all gameobjects and (re)activate the collider if it;s within range of a ColliderAgent
            foreach (ColliderAgent colliderAgent in colliderAgents)
            {
                if ((tileList[tileIndex].gameObject.transform.position.x > colliderAgent.agentTransform.position.x + colliderAgent.gameObjectColliderDistance) ||
                    (tileList[tileIndex].gameObject.transform.position.x < colliderAgent.agentTransform.position.x - colliderAgent.gameObjectColliderDistance - heightmapSize) ||
                    (tileList[tileIndex].gameObject.transform.position.z > colliderAgent.agentTransform.position.z + colliderAgent.gameObjectColliderDistance) ||
                    (tileList[tileIndex].gameObject.transform.position.z < colliderAgent.agentTransform.position.z - colliderAgent.gameObjectColliderDistance - heightmapSize))
                {
                    continue;
                }

                foreach (Transform childTransform in childTransforms)
                {
                    if (PointsWithinSqrRange(colliderAgent.agentTransform.position, childTransform.position, colliderAgent.gameObjectColliderDistance))
                    {
                        EnableAllColliders(childTransform.gameObject);
                    }
                }
            }
        } // private void UpdateGameObjectColliders(int tileIndex)

        //==================================================================

        private void ColliderAgentsCheckPopulation()
        {
            // always place player in top slot (if available)
            if (player)
            {
                int playerIndex = -1;

                for (int index = 0; index < colliderAgents.Count; index++)
                {
                    if (colliderAgents[index].agentTransform == player)
                    {
                        playerIndex = index;
                        break;
                    }
                }

                if (playerIndex == -1)
                {
                    ColliderAgent playerAgent = new ColliderAgent();
                    playerAgent.agentTransform = player;
                    playerAgent.positionCache = new Vector3(0, -100000, 0);
                    playerAgent.treeColliderDistance = 50f;
                    playerAgent.gameObjectColliderDistance = 200f;
                    colliderAgents.Insert(0, playerAgent);
                    playerIndex = 0;
                }

                if (playerIndex != 0)
                {
                    ColliderAgent swapAgent = colliderAgents[playerIndex];
                    colliderAgents[playerIndex] = colliderAgents[0];
                    colliderAgents[0] = swapAgent;
                    playerIndex = 0;
                }
            }

            // remove duplicate slots
            for (int indexLow = 0; indexLow < colliderAgents.Count; indexLow++)
            {
                for (int indexHigh = colliderAgents.Count - 1; indexHigh > indexLow; indexHigh--)
                {
                    if (colliderAgents[indexLow].agentTransform == colliderAgents[indexHigh].agentTransform)
                    {
                        colliderAgents.RemoveAt(indexHigh);
                    }
                }
            }

            // remove empty slots
            for (int index = colliderAgents.Count - 1; index > 0; index--)
            {
                if (!colliderAgents[index].agentTransform)
                {
                    colliderAgents.RemoveAt(index);
                }
            }
        } // private void ColliderAgentsCheckPopulation()

        //==================================================================

    } // public partial class EasyTerrain : MonoBehaviour

} // namespace MouseSoftware