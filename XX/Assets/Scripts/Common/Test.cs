using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{

    private void Update() {
        if (Input.GetKeyDown(KeyCode.B)) {

            int ride_id = RoleData.mainRole.attribute[(int)RoleAttribute.ride_id] + 1;
            if (ride_id >= UIAssets.instance.ridePrefab.Length) {
                ride_id = -1;
            }
            RoleData.mainRole.attribute[(int)RoleAttribute.ride_id] = ride_id;

            RoleShow.mainRole.InitRole(RoleData.mainRole);
        }
    }
}
