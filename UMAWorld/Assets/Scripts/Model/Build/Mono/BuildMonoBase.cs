using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
// 修仙世界
namespace UMAWorld {
    public class BuildMonoBase : MonoBehaviour
    {
        public int wait = 0;


        WaitForEndOfFrame wairFrame = new WaitForEndOfFrame();
        WaitForSeconds oneSecond = new WaitForSeconds(1);
        DateTime beforDT = default;

        protected IEnumerator CheckWait() {
            //if (beforDT == default) {
            //    beforDT = System.DateTime.Now;
            //}

            //DateTime afterDT = System.DateTime.Now;
            //TimeSpan ts = afterDT.Subtract(beforDT);
            //Debug.LogFormat("DateTime总共花费{0}ms.", ts.TotalMilliseconds);

            if (false) {
                //if (ts.TotalMilliseconds > 15) {
                beforDT = default;
                yield return 0;
            }
        }
    }
}