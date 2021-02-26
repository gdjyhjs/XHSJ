using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class RoleMove : MonoBehaviour
{
    public bool isMainRole;
    public float speed = 30;
    Vector3 last_pos;
    NavMeshAgent nav;
    RoleShow show;
    bool onMove;
    private void Awake() {
        nav = GetComponent<NavMeshAgent>();
    }

    private void Start() {
        if (isMainRole) {
            last_pos = transform.position;
            RoleData roleData = RoleData.mainRole;
            nav.speed = roleData.GetAttr( RoleAttribute.stamina) * 0.025f;
            show = RoleShow.mainRole;
            transform.localEulerAngles = new Vector3(0, roleData.GetAttr(RoleAttribute.orientation), 0);

            int longitude = roleData.GetAttr(RoleAttribute.longitude);
            int latitude = roleData.GetAttr(RoleAttribute.latitude);
            MinCamera.SetPos(Tools.UnitPosToWorldPoint(new Vector2Int(longitude, latitude)));
        }
    }

    private void Update() {
        if (isMainRole) {
            if (transform.position != last_pos) {
                last_pos = transform.position;
                MainCamera.SetPos(transform.position);
                Vector3 pos = CorrectPos(transform.position);
                Vector2Int p = Tools.WorldPointToUnitPos(pos);
                RoleData.mainRole.SetAttrebuteValue(RoleAttribute.longitude, p.x, false);
                RoleData.mainRole.SetAttrebuteValue(RoleAttribute.latitude, p.y, false);
                RoleData.mainRole.SetAttrebuteValue(RoleAttribute.orientation, (int)transform.eulerAngles.y, false);
                EventManager.SendEvent(EventTyp.SpaceChange, p);
            } else if (onMove && Vector3.Distance(transform.position, target) < 2) {
                show.SetIdle();
            }
        }

        float x = Input.GetAxis("Horizontal");
        float z = Input.GetAxis("Vertical");
        if (x != 0|| z != 0) {
            MoveTo(transform.position + new Vector3(x * WorldCreate.instance.scale, 0, z * WorldCreate.instance.scale), true);
        }
    }

    private void OnEnable() {
        EventManager.AddEvent(EventTyp.ClickWorld, OnClickWorld);
    }

    private void OnDisable() {
        EventManager.RemoveEvent(EventTyp.ClickWorld, OnClickWorld);
    }

    public void OnClickWorld(object param) {
        Move();
    }

    public Vector3 target;
    private void Move() {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit)) {
            MoveTo(hit.point);
        }
    }

    private void MoveTo(Vector3 pos, bool move = false) {
        float x = pos.x;
        float z = pos.z;
        if (x < 0)
            x = 0;
        if (z < 0)
            z = 0;
        float max = WorldCreate.instance.size * WorldCreate.instance.scale - 1;
        if (x > max) {
            x = max;
        }
        if (z > max) {
            z = max;
        }
        Vector3 point = CorrectPos(new Vector3(x, pos.y, z));

        if (isMainRole) {
            MinCamera.SetPos(point);
            Vector2Int p = Tools.WorldPointToUnitPos(point);
            EventManager.SendEvent(EventTyp.ChangePos, p);
        }

        if (IsSame(point, target) || move) {
            BeginMove(point);
        } else {
            target = point;
        }
    }

    private void BeginMove(Vector3 point) {
        onMove = true;
        nav.enabled = true;
        nav.SetDestination(point);
        target = point;
        show.SetWalk();
    }

    /// <summary>
    /// 矫正坐标
    /// </summary>
    private static Vector3 CorrectPos(Vector3 pos) {
        WorldCreate world = WorldCreate.instance;
        float x = (Mathf.Floor(pos.x / world.scale) + 0.5f) * world.scale;
        float z = (Mathf.Floor(pos.z / world.scale) + 0.5f) * world.scale;
        return new Vector3(x, 0, z);
    }

    /// <summary>
    /// 是否一样的坐标
    /// </summary>
    private static bool IsSame(Vector3 a, Vector3 b) {
        WorldCreate world = WorldCreate.instance;
        int ax = (int)(Mathf.Floor(a.x / world.scale));
        int az = (int)(Mathf.Floor(a.z / world.scale));
        int bx = (int)(Mathf.Floor(b.x / world.scale));
        int bz = (int)(Mathf.Floor(b.z / world.scale));
        if (ax == bx && az == bz) {
            return true;
        }
        return false;
    }
}
