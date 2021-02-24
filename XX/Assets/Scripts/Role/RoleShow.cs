using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoleShow : MonoBehaviour {
    public static RoleShow mainRole;

    public bool isMainRole;
    public Animator playerAnim;
    public Animator rideAnim;
    public Transform mainModel;
    public RoleData showRoleData;
    void Awake()
    {
        if (isMainRole) {
            mainRole = this;
        }
    }

    private void Start() {
        if (isMainRole) {
            InitRole(RoleData.mainRole);
        }
    }

    private void OnEnable() {
        EventManager.AddEvent(EventTyp.ChangeRide, OnRideChange);
    }

    private void OnDisable() {
        EventManager.RemoveEvent(EventTyp.ChangeRide, OnRideChange);
    }

    void OnRideChange(object param) {
        RoleData roleData = (RoleData)param;
        if (roleData == showRoleData) {
            InitRole(roleData);
        }
    }

    public void InitRole(RoleData roleData) {
        showRoleData = roleData;
        if (playerAnim) {
            Destroy(playerAnim.gameObject);
            playerAnim = null;
        }
        if (rideAnim) {
            Destroy(rideAnim.gameObject);
            rideAnim = null;
        }

        GameObject player_obj;
        if (showRoleData.sex == Sex.Girl) {
            player_obj = UIAssets.instance.grilPrefab[showRoleData.appearance.body];
        } else {
            player_obj = UIAssets.instance.boyPrefab[showRoleData.appearance.body];
        }
        player_obj = Instantiate(player_obj);
        playerAnim = player_obj.GetComponent<Animator>();

        int ride_id = showRoleData.GetAttr(RoleAttribute.ride_id);
        if (ride_id >= 0) {
            GameObject ride_obj = UIAssets.instance.ridePrefab[ride_id];
            ride_obj = Instantiate(ride_obj);
            rideAnim = ride_obj.GetComponent<Animator>();
        } else {
            rideAnim = null;
        }

        playerAnim.SetBool("idle", true);
        if (rideAnim) {
            ///有坐骑
            rideAnim.transform.SetParent(transform, false);
            playerAnim.transform.SetParent(rideAnim.GetComponent<RideBind>().bind, false);
            playerAnim.transform.localPosition = Vector3.zero;
            if (ride_id != 13 && ride_id != 10 && ride_id != 9) {
                playerAnim.transform.localEulerAngles = new Vector3(0, -90, 0);
            }
            mainModel = rideAnim.transform;
            rideAnim.SetBool("idle", true);
            playerAnim.SetBool("ride_idle", true);
            mainModel.transform.localScale = new Vector3(1f, 1f, 1f);
        } else {
            //没坐骑
            playerAnim.transform.SetParent(transform, false);
            mainModel = playerAnim.transform;
            playerAnim.SetBool("ride_idle", false);
            mainModel.transform.localScale = new Vector3(2f, 2f, 2f);
        }
        mainModel.localPosition = new Vector3(0, 0, 0);

        SetIdle();
        SetPos(showRoleData);
    }

    void SetPos(RoleData roleData) {
        int longitude = roleData.GetAttr(RoleAttribute.longitude);
        int latitude = roleData.GetAttr(RoleAttribute.latitude);
        float scale = WorldCreate.instance.scale;
        transform.position = new Vector3(longitude, 0, latitude) * scale + new Vector3(scale, 0, scale) * 0.5f;
        if (isMainRole) {
            MainCamera.SetPos(transform.position);
        }
    }

    public void SetIdle() {
        playerAnim.SetBool("move", false);
        if (rideAnim) {
            ///有坐骑
            rideAnim.SetBool("move", false);
        }
    }
    public void SetWalk() {
        playerAnim.SetBool("move", true);
        if (rideAnim) {
            ///有坐骑
            rideAnim.SetBool("move", true);
        }
    }
}
