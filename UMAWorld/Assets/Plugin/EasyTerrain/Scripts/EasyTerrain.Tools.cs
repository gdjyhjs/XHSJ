using System.Collections.Generic;
using UnityEngine;

namespace MouseSoftware
{
    public partial class EasyTerrain : MonoBehaviour
    {
        //==================================================================

        public struct TerrainSample
        {
            public float height;
            public Vector3 derivative;
            public Vector3 normal;
            public float steepness;
        } // public struct TerrainSample

        //==================================================================

        static public TerrainSample GetTerrainSample(Vector3 coordinates)
        {
            Vector3 noiseCoordinates = new Vector3(coordinates.x - _heightmapNoiseSettings.offsetX, _heightmapNoiseSettings.offsetY, coordinates.z - _heightmapNoiseSettings.offsetZ);

            // get a NoiseSample at the given coordinates
            NoiseGenerator.NoiseSample noiseSample = NoiseGenerator.Sum(
                NoiseGenerator.methods[(int)_heightmapNoiseSettings.type],
                noiseCoordinates,
                _heightmapNoiseSettings.frequency,
                _heightmapNoiseSettings.octaves,
                _heightmapNoiseSettings.lacunarity,
                _heightmapNoiseSettings.persistence);
            if (!_isIsland)
            {
                noiseSample = (noiseSample + 1f) * 0.5f;
                //noiseSample.value = _heightmapNoiseSettings.adjustmentCurve.Evaluate(noiseSample.value);
                noiseSample *= _heightmapMaxHeight;
            }
            else
            {
                noiseSample = (noiseSample + 1f) * 0.5f;
                //noiseSample.value = _heightmapNoiseSettings.adjustmentCurve.Evaluate(noiseSample.value);
                float fallofStartRadius = _islandRadiusMin * _heightmapSize * 0.5f * _nTilesHorizontal;
                float fallofEndRadius = _islandRadiusMax * _heightmapSize * 0.5f * _nTilesHorizontal;
                noiseSample *= QuadraticFallofCurve(coordinates, fallofStartRadius, fallofEndRadius);
                noiseSample *= _heightmapMaxHeight;
            }

            // Return a new TerrainSample = adjusted NoiseSample + additional info about normal vector and steepness
            TerrainSample newTerrainSample = new TerrainSample
            {
                height = noiseSample.value,
                derivative = noiseSample.derivative,
                normal = new Vector3(-noiseSample.derivative.x, 1f, -noiseSample.derivative.z).normalized
            };
            newTerrainSample.steepness = Vector3.Angle(Vector3.up, newTerrainSample.normal);

            return newTerrainSample;
        } // static public TerrainSample GetTerrainSample(Vector3 coordinates)

        //==================================================================

        static private NoiseGenerator.NoiseSample QuadraticFallofCurve(Vector3 point, float fallofStartRadius, float fallofEndRadius)
        {
            float r = Mathf.Sqrt(point.x * point.x + point.z * point.z);
            r -= fallofStartRadius;
            r /= (fallofEndRadius - fallofStartRadius);
            if (r <= 0f)
            {
                return new NoiseGenerator.NoiseSample
                {
                    value = 1f,
                    derivative = Vector3.zero
                };
            }
            if (r >= 1f)
            {
                return new NoiseGenerator.NoiseSample
                {
                    value = 0f,
                    derivative = Vector3.zero
                };
            }

            float rSqr = r * r;
            float val = rSqr * (rSqr - 2f) + 1f;

            float theta = Mathf.Atan2(point.z, point.x);
            float diffPart = 4f * r * (rSqr - 1f);
            float diffX = diffPart * Mathf.Cos(theta);
            float diffZ = diffPart * Mathf.Sin(theta);

            diffX /= (fallofEndRadius - fallofStartRadius);
            diffZ /= (fallofEndRadius - fallofStartRadius);

            return new NoiseGenerator.NoiseSample
            {
                value = val,
                derivative = new Vector3(diffX, 0f, diffZ)
            };
        }

        //==================================================================

        static private bool PointsWithinSqrRange(Vector3 A, Vector3 B, float range)
        {
            return (Vector3.SqrMagnitude(A - B) < range * range);
        } // static private bool PointsWithinSqrRange(Vector3 A, Vector3 B, float range)

        //==================================================================

        static private void CopyColliders(ref GameObject source, ref GameObject destiny, bool disableCollidersOnSource)
        {
            // Copy all colliders from a source gameobject, and assign them to a destiny gameobject.
            // Optionally, the colliders can be deactivated on the source
            foreach (CapsuleCollider col in source.GetComponentsInChildren<CapsuleCollider>(true))
            {
                GameObject newCollGameObject = new GameObject("Capsule");
                newCollGameObject.transform.parent = destiny.transform;
                CapsuleCollider newColl = newCollGameObject.AddComponent<CapsuleCollider>();
                newColl.transform.position = col.transform.position;
                newColl.transform.localPosition = col.transform.localPosition;
                newColl.transform.rotation = col.transform.rotation;
                newColl.transform.localRotation = col.transform.localRotation;
                newColl.transform.localScale = col.transform.localScale;
                newColl.contactOffset = col.contactOffset;
                newColl.center = col.center;
                newColl.direction = col.direction;
                newColl.height = col.height;
                newColl.radius = col.radius;
                newColl.material = col.material;
                newColl.sharedMaterial = col.sharedMaterial;
                newColl.enabled = true;
                if (disableCollidersOnSource)
                {
                    col.enabled = false;
                }
            }
            foreach (SphereCollider col in source.GetComponentsInChildren<SphereCollider>(true))
            {
                GameObject newCollGameObject = new GameObject("Sphere");
                newCollGameObject.transform.parent = destiny.transform;
                SphereCollider newColl = newCollGameObject.AddComponent<SphereCollider>();
                newColl.transform.position = col.transform.position;
                newColl.transform.localPosition = col.transform.localPosition;
                newColl.transform.rotation = col.transform.rotation;
                newColl.transform.localRotation = col.transform.localRotation;
                newColl.transform.localScale = col.transform.localScale;
                newColl.contactOffset = col.contactOffset;
                newColl.center = col.center;
                newColl.radius = col.radius;
                newColl.material = col.material;
                newColl.sharedMaterial = col.sharedMaterial;
                newColl.enabled = true;
                if (disableCollidersOnSource)
                {
                    col.enabled = false;
                }
            }
            foreach (BoxCollider col in source.GetComponentsInChildren<BoxCollider>(true))
            {
                GameObject newCollGameObject = new GameObject("Box");
                newCollGameObject.transform.parent = destiny.transform;
                BoxCollider newColl = newCollGameObject.AddComponent<BoxCollider>();
                newColl.transform.position = col.transform.position;
                newColl.transform.localPosition = col.transform.localPosition;
                newColl.transform.rotation = col.transform.rotation;
                newColl.transform.localRotation = col.transform.localRotation;
                newColl.transform.localScale = col.transform.localScale;
                newColl.contactOffset = col.contactOffset;
                newColl.center = col.center;
                newColl.size = col.size;
                newColl.material = col.material;
                newColl.sharedMaterial = col.sharedMaterial;
                newColl.enabled = true;
                if (disableCollidersOnSource)
                {
                    col.enabled = false;
                }
            }
            foreach (MeshCollider col in source.GetComponentsInChildren<MeshCollider>(true))
            {
                GameObject newCollGameObject = new GameObject("Mesh");
                newCollGameObject.transform.parent = destiny.transform;
                MeshCollider newColl = newCollGameObject.AddComponent<MeshCollider>();
                newColl.transform.position = col.transform.position;
                newColl.transform.localPosition = col.transform.localPosition;
                newColl.transform.rotation = col.transform.rotation;
                newColl.transform.localRotation = col.transform.localRotation;
                newColl.transform.localScale = col.transform.localScale;
                newColl.contactOffset = col.contactOffset;
                newColl.convex = col.convex;
#if !UNITY_2018_3_OR_NEWER
                newColl.inflateMesh = col.inflateMesh;
                newColl.skinWidth = col.skinWidth;
#endif
                newColl.sharedMesh = col.sharedMesh;
                newColl.material = col.material;
                newColl.sharedMaterial = col.sharedMaterial;
                newColl.enabled = true;
                if (disableCollidersOnSource)
                {
                    col.enabled = false;
                }
            }
        } // static private void CopyColliders(ref GameObject source, ref GameObject destiny, bool disableCollidersOnSource)

        //==================================================================

        private void DisableAllColliders(GameObject source)
        {
            // Find and disable all attached colliders on the source gameObject
            foreach (CapsuleCollider col in source.GetComponentsInChildren<CapsuleCollider>(true))
            {
                col.enabled = false;
            }

            foreach (SphereCollider col in source.GetComponentsInChildren<SphereCollider>(true))
            {
                col.enabled = false;
            }

            foreach (BoxCollider col in source.GetComponentsInChildren<BoxCollider>(true))
            {
                col.enabled = false;
            }

            foreach (MeshCollider col in source.GetComponentsInChildren<MeshCollider>(true))
            {
                col.enabled = false;
            }
        } // private void DisableAllColliders(GameObject source)

        //==================================================================

        private void EnableAllColliders(GameObject source)
        {
            // Find and enable all attached colliders on the source gameObject
            foreach (CapsuleCollider col in source.GetComponentsInChildren<CapsuleCollider>(true))
            {
                col.enabled = true;
            }

            foreach (SphereCollider col in source.GetComponentsInChildren<SphereCollider>(true))
            {
                col.enabled = true;
            }

            foreach (BoxCollider col in source.GetComponentsInChildren<BoxCollider>(true))
            {
                col.enabled = true;
            }

            foreach (MeshCollider col in source.GetComponentsInChildren<MeshCollider>(true))
            {
                col.enabled = true;
            }
        } // private void EnableAllColliders(GameObject source)

        //==================================================================

        //==================================================================


        static public float GetUpdateStatusPercentage()
        {
            return Mathf.Clamp(_updateStatus, 0f, 1f) * 100f;
        } // static public float GetUpdateStatusPercentage()

        //==================================================================

        static public float GetUpdateStatusFactor()
        {
            return Mathf.Clamp(_updateStatus, 0f, 1f);
        } // static public float GetUpdateStatusFactor()

        //==================================================================

        static public float GetStopwatchElapsedSeconds()
        {
            return (_stopwatch.Elapsed.Minutes * 60f) + (_stopwatch.Elapsed.Seconds) + (_stopwatch.Elapsed.Milliseconds * 0.001f);
        } // static public float GetStopwatchElapsedSeconds()

        //==================================================================

        //==================================================================

        private struct DetachTreesRequest
        {
            public Vector3 point;
            public float radius;
            public string message;
            public object objectMessageValue;
            public Transform parentTransform;
        } // private struct DetachTreesRequest

        //==================================================================

        static public void DetachTreesFromTerrain(Vector3 point, float radius)
        {
            // Create a new DetachTreeRequest and add this to the detachTreesRequestQueue
            DetachTreesRequest newDetachTreesRequest = new DetachTreesRequest();
            newDetachTreesRequest.point = point;
            newDetachTreesRequest.radius = radius;
            newDetachTreesRequest.message = null;
            newDetachTreesRequest.objectMessageValue = null;
            newDetachTreesRequest.parentTransform = null;
            detachTreesRequestQueue.Add(newDetachTreesRequest);
        } // static public void DetachTreesFromTerrain(Vector3 point, float radius)

        //==================================================================

        static public void DetachTreesFromTerrain(Vector3 point, float radius, Transform parentTransform)
        {
            // Create a new DetachTreeRequest and add this to the detachTreesRequestQueue
            DetachTreesRequest newDetachTreesRequest = new DetachTreesRequest();
            newDetachTreesRequest.point = point;
            newDetachTreesRequest.radius = radius;
            newDetachTreesRequest.message = null;
            newDetachTreesRequest.objectMessageValue = null;
            newDetachTreesRequest.parentTransform = parentTransform;
            detachTreesRequestQueue.Add(newDetachTreesRequest);
        } // static public void DetachTreesFromTerrain(Vector3 point, float radius, Transform parentTransform)

        //==================================================================

        static public void DetachTreesFromTerrain(Vector3 point, float radius, string message)
        {
            // Create a new DetachTreeRequest and add this to the detachTreesRequestQueue
            DetachTreesRequest newDetachTreesRequest = new DetachTreesRequest();
            newDetachTreesRequest.point = point;
            newDetachTreesRequest.radius = radius;
            newDetachTreesRequest.message = null;
            newDetachTreesRequest.objectMessageValue = message;
            newDetachTreesRequest.parentTransform = null;
            detachTreesRequestQueue.Add(newDetachTreesRequest);
        } // static public void DetachTreesFromTerrain(Vector3 point, float radius, string message)

        //==================================================================

        static public void DetachTreesFromTerrain(Vector3 point, float radius, string message, Transform parentTransform)
        {
            // Create a new DetachTreeRequest and add this to the detachTreesRequestQueue
            DetachTreesRequest newDetachTreesRequest = new DetachTreesRequest();
            newDetachTreesRequest.point = point;
            newDetachTreesRequest.radius = radius;
            newDetachTreesRequest.message = null;
            newDetachTreesRequest.objectMessageValue = message;
            newDetachTreesRequest.parentTransform = parentTransform;
            detachTreesRequestQueue.Add(newDetachTreesRequest);
        } // static public void DetachTreesFromTerrain(Vector3 point, float radius, string message, Transform parentTransform)

        //==================================================================

        static public void DetachTreesFromTerrain(Vector3 point, float radius, string message, object messageValue)
        {
            // Create a new DetachTreeRequest and add this to the detachTreesRequestQueue
            DetachTreesRequest newDetachTreesRequest = new DetachTreesRequest();
            newDetachTreesRequest.point = point;
            newDetachTreesRequest.radius = radius;
            newDetachTreesRequest.message = null;
            newDetachTreesRequest.objectMessageValue = messageValue;
            newDetachTreesRequest.parentTransform = null;
            detachTreesRequestQueue.Add(newDetachTreesRequest);
        } // static public void DetachTreesFromTerrain(Vector3 point, float radius, string message, object messageValue)

        //==================================================================

        static public void DetachTreesFromTerrain(Vector3 point, float radius, string message, object messageValue, Transform parentTransform)
        {
            // Create a new DetachTreeRequest and add this to the detachTreesRequestQueue
            DetachTreesRequest newDetachTreesRequest = new DetachTreesRequest();
            newDetachTreesRequest.point = point;
            newDetachTreesRequest.radius = radius;
            newDetachTreesRequest.message = null;
            newDetachTreesRequest.objectMessageValue = messageValue;
            newDetachTreesRequest.parentTransform = parentTransform;
            detachTreesRequestQueue.Add(newDetachTreesRequest);
        } // static public void DetachTreesFromTerrain(Vector3 point, float radius, string message, object messageValue, Transform parentTransform)

        //==================================================================

        private void ProcessDetachedTreesQueue()
        {
            if (detachTreesRequestQueue.Count == 0)
            {
                return;
            }

            TerrainData terrainData;
            TreeInstance[] treeInstances;
            List<TreeInstance> treeInstancesList;

            Vector3 point;
            float radius;
            string message;
            object messageValue;
            bool hasChanged;

            Transform treeCollider;
            GameObject detachedTree;
            Rigidbody[] detachedTreeRigidbodies;
            Rigidbody detachedTreeRigidbody;

            foreach (DetachTreesRequest dtr in detachTreesRequestQueue)
            {
                point = dtr.point;
                radius = dtr.radius;
                message = dtr.message;
                messageValue = dtr.objectMessageValue;

                hasChanged = false;
                foreach (Tile tile in tileList)
                {
                    // Find all trees on the tile
                    terrainData = tile.terrain.terrainData;
                    treeInstances = terrainData.treeInstances;
                    treeInstancesList = new List<TreeInstance>(tile.terrain.terrainData.treeInstances);

                    for (int tic = treeInstancesList.Count - 1; tic > 0; tic--)
                    {
                        Vector3 treePosition = Vector3.Scale(treeInstancesList[tic].position, tile.terrain.terrainData.size);
                        treePosition += tile.terrain.transform.position;
                        // Check if this tree is within a 'radius' around 'point'
                        if (PointsWithinSqrRange(treePosition, point, radius))
                        {
                            hasChanged = true;
                            // Remove the tree from the terrain and replace it by a regular GameObject
                            detachedTree = Instantiate(treesProperties[treeInstancesList[tic].prototypeIndex].prototype);
                            detachedTree.transform.position = treePosition;
                            detachedTree.transform.parent = dtr.parentTransform;
                            detachedTree.layer = 0;
                            detachedTree.transform.localScale = Vector3.one * treeInstancesList[tic].widthScale;
                            // make sure all colliders of the new tree are active
                            foreach (CapsuleCollider col in detachedTree.GetComponentsInChildren<CapsuleCollider>(true))
                            {
                                col.enabled = true;
                            }
                            foreach (SphereCollider col in detachedTree.GetComponentsInChildren<SphereCollider>(true))
                            {
                                col.enabled = true;
                            }
                            foreach (BoxCollider col in detachedTree.GetComponentsInChildren<BoxCollider>(true))
                            {
                                col.enabled = true;
                            }
                            foreach (MeshCollider col in detachedTree.GetComponentsInChildren<MeshCollider>(true))
                            {
                                col.enabled = true;
                            }
                            // if no rigidbody is present, assign a new one. Or else the tree won't fall
                            detachedTreeRigidbodies = detachedTree.GetComponents<Rigidbody>();
                            if (detachedTreeRigidbodies.Length == 0)
                            {
                                detachedTreeRigidbody = detachedTree.AddComponent<Rigidbody>();
                                detachedTreeRigidbody.SetDensity(750f); //~oak
                                detachedTreeRigidbody.mass = detachedTreeRigidbody.mass * 0.05f;
                                detachedTreeRigidbody.isKinematic = false;
                                detachedTreeRigidbody.useGravity = true;
                            }
                            else
                            {
                                foreach (Rigidbody detachedTreeRb in detachedTreeRigidbodies)
                                {
                                    detachedTreeRb.isKinematic = false;
                                    detachedTreeRb.useGravity = true;
                                }
                            }
                            // Send a message to the new tree
                            if (message != null)
                            {
                                detachedTree.SendMessage(message, messageValue, SendMessageOptions.DontRequireReceiver);
                            }
                            // remove the original tree from the list
                            treeInstancesList.RemoveAt(tic);
                            tile.treeInfoList.RemoveAt(tic);
                        }
                    }

                    if (hasChanged)
                    {
                        // Remove Tree Colliders
                        for (int i = 0; i < treeCollidersRoot.childCount; i++)
                        {
                            treeCollider = treeCollidersRoot.GetChild(i);
                            if (PointsWithinSqrRange(treeCollider.position, point, radius))
                            {
                                treeCollider.gameObject.SetActive(false);
                            }
                        }
                        terrainData.treeInstances = treeInstancesList.ToArray();
                    }

                    hasChanged = false;
                }
            }

            detachTreesRequestQueue.Clear();
        } // private void ProcessDetachedTreesQueue()

        //==================================================================

        static public void AddColliderAgent(Transform agentTransform, float treeColliderDistance, float gameobjectColliderDistance)
        {
            ColliderAgent newColliderAgent = new ColliderAgent
            {
                agentTransform = agentTransform,
                treeColliderDistance = treeColliderDistance,
                gameObjectColliderDistance = gameobjectColliderDistance,
                positionCache = agentTransform.position - new Vector3(0f, -10000f, 0f)
            };
            newColliderAgentsQueue.Add(newColliderAgent);
        } // static public void AddColliderAgent(Transform agentTransform, float treeColliderDistance, float gameobjectColliderDistance)

        //==================================================================

        static public void RemoveColliderAgent(Transform agentTransform)
        {
            removeColliderAgentsQueue.Add(agentTransform);
        }

    } // public partial class EasyTerrain : MonoBehaviour

} // namespace MouseSoftware