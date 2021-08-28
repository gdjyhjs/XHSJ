using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkillLine:SkillMono {
    private Vector3 dir;

    protected override void Start() {
        base.Start();
        dir = (targetPos - transform.position).normalized;
    }

    protected override void Update() {
        base.Update();
        transform.Translate(dir * Time.deltaTime * skillConf.speed);
    }
}
