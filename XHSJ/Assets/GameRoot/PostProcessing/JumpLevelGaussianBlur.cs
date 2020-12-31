using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class JumpLevelGaussianBlur : GaussianBlur
{
    private Action jumpFunc;
    //过度隐藏场景 清晰 => 模糊
    public void JumpLevel(Action func, float time = .2f,float speed = 20) {
        jumpFunc = func;
        enabled = true;
        iterations = 0;
        blurSpread = 0;
        downSample = 1;
        StartCoroutine(StartGauss(time, speed));
    }

    IEnumerator StartGauss(float time, float speed) {
        float endTime = Time.time + time;
        float iterations = this.iterations;
        float blurSpread = this.blurSpread;
        float downSample = this.downSample;
        while (endTime > Time.time) {
            var value = speed * Time.deltaTime;
            iterations += value;
            blurSpread += value;
            downSample += value;
            this.iterations = (int)iterations;
            this.blurSpread = (int)blurSpread;
            this.downSample = (int)downSample;
            yield return new WaitForEndOfFrame();
        }
        if (null != jumpFunc) {
            jumpFunc();
        }
    }
    
    // 过度显示场景 模糊=>清晰
    public void ShowLevel(Action func, float time = .2f, float speed = 20) {
        jumpFunc = func;
        enabled = true;
        var value = time * speed;
        iterations = (int)value;
        blurSpread = value;
        downSample = (int)value;
        StartCoroutine(ShowGauss(time, speed));
    }

    IEnumerator ShowGauss(float time, float speed) {
        float endTime = Time.time + time;
        float iterations = this.iterations;
        float blurSpread = this.blurSpread;
        float downSample = this.downSample;
        while (endTime > Time.time) {
            var value = speed * Time.deltaTime;
            iterations -= value;
            blurSpread -= value;
            downSample -= value;
            this.iterations = (int)iterations;
            this.blurSpread = (int)blurSpread;
            this.downSample = Mathf.Max((int)downSample, 1);
            yield return new WaitForEndOfFrame();
        }
        if (null != jumpFunc) {
            jumpFunc();
        }
    }
}
