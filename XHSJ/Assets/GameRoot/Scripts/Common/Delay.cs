using UnityEngine;
using System.Collections;

public class Delay : MonoBehaviour {

    public float delayTime = 0.0f;
    public float hideTime = 0.0f;

    private Animator animator;
    private bool initPlay = true;
    private bool isHide = false;

    private void OnEnable() {


        delayTime = 0.0f;
        hideTime = 0.0f;
        initPlay = true;
        isHide = false;
    }

    void Start() {
        if (!initPlay)
            return;

        if (hideTime > 0.0) {
            Invoke("HideFunc", hideTime);
        }

        animator = gameObject.GetComponent<Animator>();
        if (delayTime > 0) {
            gameObject.SetActive(false);
            Invoke("DelayFunc", delayTime);
        } else {
            PlayAni();
        }
    }

    void DelayFunc() {
        gameObject.SetActive(true);
        PlayAni();
    }

    void HideFunc() {
        if (isHide) {
            return;
        }
        isHide = true;

        gameObject.SetActive(false);
    }

    void PlayAni() {
        if (animator != null) {
            animator.SetTrigger("play");
        }
    }

    public void ShowEffect() {
        isHide = false;
        CancelInvoke();
        if (hideTime > 0.0) {
            Invoke("HideFunc", hideTime);
        }

        if (delayTime > 0.0) {
            gameObject.SetActive(false);
            Invoke("DelayFunc", delayTime);
        } else {
            gameObject.SetActive(true);
            PlayAni();
        }
    }

    public void SetInitPlay(bool flag) {
        initPlay = flag;
    }
}