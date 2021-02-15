using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class RoleMove : MonoBehaviour
{
    public float speed = 30;
    NavMeshAgent nav;
    private void Awake() {
        nav = GetComponent<NavMeshAgent>();
        idle_objs = new List<GameObject>();
        use_objs = new List<GameObject>();
        arrwo_obj = Instantiate(wayarrow_prefab);
        arrwo_obj.transform.SetParent(transform);
        arrwo_obj.transform.position = new Vector3(0, 9999, 0);
    }

    private void Update() {
        if (Input.GetMouseButtonDown(0)) {
            Move();
        }
    }

    public Vector3 target;
    public Vector3[] path;
    private void Move() {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit)) {
            ClearWayLine();
            StopAllCoroutines();
            if (IsSame(hit.point, target)) {
                target = new Vector3(-100, -100, -100);
                StartCoroutine(BeginMove());
                return;
            }
            StartCoroutine(TryMove(hit.point));
        } else {
        }
    }

    private IEnumerator TryMove(Vector3 point) {
        target = point;
        nav.enabled = true;
        nav.SetDestination(point);
        while (true) {
            Vector3[] p = nav.path.corners;
            if (Vector3.Distance(p[p.Length - 1], point) < 1) {
                break;
            }
            yield return 0;
        }
        List<Vector3> result = new List<Vector3>();
        Vector3[] paths = nav.path.corners;
        nav.enabled = false;
        if (paths.Length > 1) {
            for (int i = 0; i < paths.Length - 1; i++) {
                Vector3 start = paths[i] / WorldCreate.instance.scale;
                Vector3 end = paths[i + 1] / WorldCreate.instance.scale;
                var list = Tools.CalLength(start, end);
                if (list.Length > 2) {
                    if (Vector3.Distance(list[0], start) < Vector3.Distance(list[list.Length - 1], start)) {
                        result.AddRange(list);
                    } else {
                        for (int j = list.Length - 1; j >= 0; j--) {
                            result.Add(list[j]);
                        }
                    }
                }
            }
        }

        for (int i = result.Count - 1; i > 0; i--) {
            if (result[i] == result[i - 1]) {
                result.RemoveAt(i);
            }
        }

        path = result.ToArray();
        if (path.Length > 0) {
            List<Vector3[]> result2 = new List<Vector3[]>();
            Vector3 start = path[0];
            Vector3 end = path[1];
            Vector3 dir = (end - start).normalized;
            for (int i = 2; i < path.Length; i++) {
                if ((path[i] - start).normalized == dir) {
                    end = path[i];
                } else {
                    result2.Add(new Vector3[] { start, end });
                    start = path[i - 1];
                    end = path[i];
                    dir = (end - start).normalized;
                }
            }
            result2.Add(new Vector3[] { start, end });

            DrawWayLine(result2.ToArray());
        } else {
            target = new Vector3(-100, -100, -100);
        }
    }

    private IEnumerator BeginMove() {
        for (int i = 0; i < path.Length; i++) {
            Vector3 target = (path[i] + new Vector3(0.5f, 0, 0.5f)) * WorldCreate.instance.scale;
            Debug.Log(Time.time + " -> " + target);

            while (Vector3.Distance(target, transform.position) > 1f) {
                yield return 0;
                float move = speed * Time.deltaTime;
                if (move > (target - transform.position).magnitude) {
                    transform.position = target;
                } else {
                    transform.position = transform.position + (target - transform.position).normalized * move;
                }
                if (Vector3.Distance(target, transform.position) < move) {
                    break;
                }
            }
        }
    }


    public GameObject wayline_prefab;
    public GameObject wayarrow_prefab;
    public GameObject arrwo_obj;
    public List<GameObject> idle_objs;
    public List<GameObject> use_objs;
    private void ClearWayLine() {
        for (int i = use_objs.Count - 1; i >= 0; i--) {
            PutObj(use_objs[i]);
        }
        arrwo_obj.transform.position = new Vector3(0, 9999, 0);
    }

    private void DrawWayLine(Vector3[][] vector3s) {
        for (int i = 0; i < vector3s.Length; i++) {
            float start_x = (Mathf.Round(vector3s[i][0].x ) + 0.5f) * WorldCreate.instance.scale;
            float start_z = (Mathf.Round(vector3s[i][0].z ) + 0.5f) * WorldCreate.instance.scale;
            float end_x = (Mathf.Round(vector3s[i][1].x ) + 0.5f) * WorldCreate.instance.scale;
            float end_z = (Mathf.Round(vector3s[i][1].z ) + 0.5f) * WorldCreate.instance.scale;

            GameObject obj = GetObj();
            Transform tf = obj.transform;
            if (start_x == end_x) {
                // 垂直
                tf.localScale = new Vector3(0.4f, 1, Mathf.Abs(end_z - start_z));
                tf.position = new Vector3(start_x, 0, Mathf.Min(end_z , start_z) + Mathf.Abs(end_z - start_z) * 0.5f);
            } else {
                // 水平
                tf.localScale = new Vector3(Mathf.Abs(end_x - start_x), 1, 0.4f);
                tf.position = new Vector3(Mathf.Min(end_x , start_x) + Mathf.Abs(end_x - start_x) * 0.5f, 0, start_z);
            }
            if (i == vector3s.Length - 1) {
                arrwo_obj.transform.position = new Vector3(end_x, 0, end_z);
                if (start_x == end_x) {
                    // 垂直
                    if (end_z > start_z) {
                        // 向右
                        arrwo_obj.transform.eulerAngles = new Vector3(0, 0, 0);
                    } else {
                        // 向左
                        arrwo_obj.transform.eulerAngles = new Vector3(0, 180, 0);
                    }
                } else {
                    // 水平
                    if (end_x > start_x) {
                        // 向上
                        arrwo_obj.transform.eulerAngles = new Vector3(0, 90, 0);
                    } else {
                        // 向下
                        arrwo_obj.transform.eulerAngles = new Vector3(0, -90, 0);
                    }
                }
            }
        }
    }

    private GameObject GetObj() {
        GameObject obj;
        if (idle_objs.Count > 0) {
            obj = idle_objs[0];
            idle_objs.RemoveAt(0);
        } else {
            obj = Instantiate(wayline_prefab);
            obj.transform.SetParent(transform, false);
        }
        use_objs.Add(obj);
        return obj;
    }

    private void PutObj(GameObject obj) {
        use_objs.Remove(obj);
        idle_objs.Add(obj);
        obj.transform.position = new Vector3(0, 9999, 0);
    }

    /// <summary>
    /// 矫正坐标
    /// </summary>
    private Vector3 CorrectPos(Vector3 pos) {
        WorldCreate world = WorldCreate.instance;
        float x = (Mathf.Round(pos.x / world.scale) + 0.5f) * world.scale;
        float z = (Mathf.Round(pos.z / world.scale) + 0.5f) * world.scale;
        return new Vector3(x, 0, z);
    }

    /// <summary>
    /// 是否一样的坐标
    /// </summary>
    private bool IsSame(Vector3 a, Vector3 b) {
        WorldCreate world = WorldCreate.instance;
        int ax = (int)(Mathf.Round(a.x / world.scale));
        int az = (int)(Mathf.Round(a.z / world.scale));
        int bx = (int)(Mathf.Round(b.x / world.scale));
        int bz = (int)(Mathf.Round(b.z / world.scale));
        if (ax == bx && az == bz) {
            return true;
        }
        return false;
    }

    private void OnDestroy() {
        ClearWayLine();
    }
}
