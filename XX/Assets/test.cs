using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Wanderer.EmojiText;

public class test : MonoBehaviour
{
    public Text text;
    int str;
    private void OnGUI() {
        if (GUILayout.Button("  -  ")) {
            text.text = "[#emoji_" + --str + "]";
        }
        if (GUILayout.Button("  +  ")) {
            text.text = "[#emoji_" + ++str + "]";
        }
    }
}
