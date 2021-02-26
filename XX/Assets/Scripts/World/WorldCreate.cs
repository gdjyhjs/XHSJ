using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 世界创建
/// </summary>
public class WorldCreate : MonoBehaviour
{
    public static WorldCreate instance;
    public int scale = 5;
    public int size = 250;
    public Transform tf;
    public PointCreate point;

    public int[] units;
    public WorldUnit get_units(int x, int z) {
        return (WorldUnit)units[x * size + z];
    }
    public void set_units(int x, int z, WorldUnit value) {
        units[x * size + z] = (int)value;
    }
    public int units_count() {
        return units.Length;
    }
    public bool has_units() {
        return units != null;
    }

    private void Awake() {
        instance = this;
        Init();
    }

    void Start() {
        Create();
        //GetComponent<GameObjectCreate>().CreateWorld();
        GetComponent<GameObjectCreate>().CreatePoint();
    }

    public void Init() {
#if UNITY_EDITOR
        unit_size = new Vector3(scale, 2, scale);
#endif
        if (units == null) {
            byte[] byt = Tools.ReadAllBytes("config/map.data");
            units = Tools.DeserializeObject(byt) as int[];
            size = (int)Mathf.Sqrt(units_count());
        }

        gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTextureScale("_MainTex", new Vector2(size, size));
        tf.localScale = new Vector3(size * scale, size * scale, 0);
        tf.position = new Vector3(size * 0.5f * scale, 0, size * 0.5f * scale);
    }


    void Create() {
        point.Init();
    }

#if UNITY_EDITOR

    public Dictionary<WorldUnit, Color> drawColor = new Dictionary<WorldUnit, Color>() {
        { WorldUnit.Impede, new Color(1,0,0,0.3f )},
        { WorldUnit.Monster, new Color(0,0,1,0.3f ) },
        { WorldUnit.City, new Color(0,1,0,0.3f ) },
        { WorldUnit.Mountain, new Color(1,0,1,0.5f ) },
        { WorldUnit.NewVillage, new Color(0,1,1,0.5f ) },
        { WorldUnit.Level1, new Color(0.2f,0.2f,0,0.3f) },
        { WorldUnit.Level2, new Color(0.4f,0.4f,0,0.3f) },
        { WorldUnit.Level3, new Color(0.6f,0.6f,0,0.3f) },
        { WorldUnit.Level4, new Color(0.8f,0.8f,0,0.3f) },
        { WorldUnit.Level5, new Color(1,1,0,0.3f) },
    };


    Vector3 unit_size;
    private void OnDrawGizmos() {
        if (!Application.isPlaying) {
            if (null != units) {
                //Debug.Log("to OnDrawGizmosSelected");
                for (int x = 0; x < size; x++) {
                    for (int y = 0; y < size; y++) {
                        WorldUnit unit = get_units(x, y);
                        //Debug.Log(x + "," + y + ":" + unit);
                        if (unit != WorldUnit.None) {

                            float px = (x + 0.5f) * scale;
                            float pz = (y + 0.5f) * scale;

                            if ((WorldUnit.Impede & unit) == WorldUnit.Impede) {
                                Gizmos.color = drawColor[WorldUnit.Impede];
                                Gizmos.DrawCube(new Vector3(px, 0, pz), unit_size);
                            }
                            if ((WorldUnit.Monster & unit) == WorldUnit.Monster) {
                                Gizmos.color = drawColor[WorldUnit.Monster];
                                Gizmos.DrawCube(new Vector3(px, 0, pz), unit_size);

                            }
                            if ((WorldUnit.City & unit) == WorldUnit.City) {
                                Gizmos.color = drawColor[WorldUnit.City];
                                Gizmos.DrawCube(new Vector3(px, 0, pz), unit_size);

                            }
                            if ((WorldUnit.Mountain & unit) == WorldUnit.Mountain) {
                                Gizmos.color = drawColor[WorldUnit.Mountain];
                                Gizmos.DrawCube(new Vector3(px, 0, pz), unit_size);

                            }
                            if ((WorldUnit.NewVillage & unit) == WorldUnit.NewVillage) {
                                Gizmos.color = drawColor[WorldUnit.NewVillage];
                                Gizmos.DrawCube(new Vector3(px, 0, pz), unit_size);

                            }
                            if ((WorldUnit.Level1 & unit) == WorldUnit.Level1) {
                                Gizmos.color = drawColor[WorldUnit.Level1];
                                Gizmos.DrawCube(new Vector3(px, 0, pz), unit_size);
                            }
                            if ((WorldUnit.Level2 & unit) == WorldUnit.Level2) {
                                Gizmos.color = drawColor[WorldUnit.Level2];
                                Gizmos.DrawCube(new Vector3(px, 0, pz), unit_size);

                            }
                            if ((WorldUnit.Level3 & unit) == WorldUnit.Level3) {
                                Gizmos.color = drawColor[WorldUnit.Level3];
                                Gizmos.DrawCube(new Vector3(px, 0, pz), unit_size);

                            }
                            if ((WorldUnit.Level4 & unit) == WorldUnit.Level4) {
                                Gizmos.color = drawColor[WorldUnit.Level4];
                                Gizmos.DrawCube(new Vector3(px, 0, pz), unit_size);

                            }
                            if ((WorldUnit.Level5 & unit) == WorldUnit.Level5) {
                                Gizmos.color = drawColor[WorldUnit.Level5];
                                Gizmos.DrawCube(new Vector3(px, 0, pz), unit_size);

                            }
                        }
                    }
                }
            } else {
                //Debug.Log("not OnDrawGizmosSelected");
            }
        }
    }

#endif
}
