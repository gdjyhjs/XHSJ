using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIAssets : MonoBehaviour {
    public static UIAssets instance;
    private void Awake() {
        if (instance == null) {
            instance = this;
        }
    }

    public Sprite[] itemColor;


}
