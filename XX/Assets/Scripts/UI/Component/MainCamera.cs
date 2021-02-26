using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainCamera : MonoBehaviour {
    public static MainCamera instance;
    private void Awake() {
        if (instance == null) {
            instance = this;
        }
        cam = GetComponentsInChildren<Camera>();
        SetSize();
    }

    public static void SetPos(Vector3 pos) {
        Tools.SetCameraPos(instance.transform, pos);
    }

    public Camera[] cam;
    public float max_size = 50;
    public float min_size = 10;
    public float size_speed = 1000;
    public float value = 25;
    
    public Vector3 downMap;
    public Vector3 downMouse;
    public float map_move_speed = 0.01f;
    private void Update() {
        float value = Input.GetAxisRaw("Mouse ScrollWheel");
        if (value != 0) {
            if (!UnityEngine.EventSystems.EventSystem.current.IsPointerOverGameObject()) {
                value = this.value - size_speed * Time.deltaTime * value;
                if (value > max_size)
                    value = max_size;
                if (value < min_size)
                    value = min_size;
                this.value = value;
                SetSize();
            }
        }

        if (Input.GetMouseButtonDown(2)) {
            downMap = transform.position;
            downMouse = Input.mousePosition;
        }
        if (Input.GetMouseButton(2)) {
            Vector3 move = (Input.mousePosition - downMouse) * this.value * map_move_speed;
            float max = WorldCreate.instance.size * WorldCreate.instance.scale;
            float x = Mathf.Max(Mathf.Min(downMap.x + move.x, max), 0);
            float z = Mathf.Max(Mathf.Min(downMap.z + move.y, max), 0);
            transform.position = new Vector3(x, transform.position.y, z);
        }
    }

    private void SetSize() {
        foreach (var item in cam) {
            item.orthographicSize = value;
        }
    }
}
