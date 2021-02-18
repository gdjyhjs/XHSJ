using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoleShow : MonoBehaviour {
    public static RoleShow mainRole;

    public bool isMainRole;
    public Animator playerAnim;
    public Animator rideAnim;
    public Transform mainModel;
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

    public void InitRole(RoleData roleData) {
        if (playerAnim) {
            Destroy(playerAnim.gameObject);
            playerAnim = null;
        }
        if (rideAnim) {
            Destroy(rideAnim.gameObject);
            rideAnim = null;
        }

        GameObject player_obj;
        if (roleData.sex == Sex.Girl) {
            player_obj = UIAssets.instance.grilPrefab[roleData.appearance.body];
        } else {
            player_obj = UIAssets.instance.boyPrefab[roleData.appearance.body];
        }
        player_obj = Instantiate(player_obj);
        playerAnim = player_obj.GetComponent<Animator>();

        int ride_id = roleData.attribute[(int)RoleAttribute.ride_id];
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
        } else {
            //没坐骑
            playerAnim.transform.SetParent(transform, false);
            mainModel = playerAnim.transform;
            playerAnim.SetBool("ride_idle", false);
        }
        mainModel.transform.localScale = new Vector3(.5f, .5f, .5f);
        mainModel.localPosition = new Vector3(0, 0, 0);

        SetPos(roleData);
    }

    void SetPos(RoleData roleData) {
        int longitude = roleData.attribute[(int)RoleAttribute.longitude];
        int latitude = roleData.attribute[(int)RoleAttribute.latitude];
        transform.position = new Vector3(longitude, 0, latitude) * WorldCreate.instance.scale + new Vector3(2.5f, 0, 0.5f);
        if (isMainRole) {
            MainCamera.SetPos(transform.position);
        }
    }


    void Update()
    {
        
    }
}
