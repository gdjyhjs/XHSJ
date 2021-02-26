using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class WorldClick : MonoBehaviour {
    private void OnMouseDown() {
        if (!EventSystem.current.IsPointerOverGameObject()) {
            EventManager.SendEvent(EventTyp.ClickWorld, null);
        }
    }
}