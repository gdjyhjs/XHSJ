using UnityEngine;

namespace MouseSoftware
{
    public class PlayerController : MonoBehaviour
    {
        private Vector3 inputMouse;
        private Vector3 inputWASD;
        private int inputTouchRotateID = -1;
        private int inpuTouchMoveID = -1;
        private Vector2 inputTouchMoveCenter;

        [Header("Rotation")]

        private float heading = 0f;
        private float pitch = 0f;
        private float roll = 0f;

        [SerializeField, Range(0f, 180f)]
        private float sensitivity = 30f;

        [SerializeField, Range(-90f, 0f)]
        private float pitchMin = -60f;

        [SerializeField, Range(0f, 90f)]
        private float pitchMax = 60f;

        private Quaternion newRotation;

        [Header("Translation")]

        [SerializeField, Range(0f, 100f)]
        private float acceleration = 10f;

        [SerializeField, Range(0f, 100f)]
        private float maxSpeed = 20f;

        [SerializeField, Range(0f, 10f)]
        private float speedMultiplier = 5f;
        private bool speedMultiplierEnabled = false;

        [SerializeField, Range(0f, 1000f)]
        private float maxHeight = 500f;

        [SerializeField, Range(0f, 100f)]
        private float minHeightToGround = 1.8f;

        private EasyTerrain.TerrainSample terrainSampleAtPlayer;
        private Rigidbody rb;
        private Vector3 localVelocity;
        private float speed;

        [Header("Smoothing")]

        [SerializeField, Range(0f, 0.5f)]
        private float smoothingTime = 0.1f;
        private float deltaTime;
        private float smoothFactor;

        [Header("Misc")]

        [SerializeField]
        private bool invertMouseY = true;

        [SerializeField]
        private bool hideMouse = true;

        //================================================================================

        private void Start()
        {
            Input.simulateMouseWithTouches = (SystemInfo.deviceType == DeviceType.Handheld) ? false : true;
            Cursor.visible = hideMouse ? true : false;
            Cursor.lockState = hideMouse ? CursorLockMode.Locked : CursorLockMode.None;
            rb = gameObject.GetComponent<Rigidbody>();
            rb.drag = 0.0f;
            rb.angularDrag = 0.01f;
            rb.useGravity = false;
            rb.isKinematic = false;
            rb.centerOfMass = Vector3.zero;
            rb.angularVelocity = Vector3.zero;
            rb.velocity = Vector3.zero;
            rb.constraints = RigidbodyConstraints.FreezeRotation;
            rb.interpolation = RigidbodyInterpolation.Interpolate;
            rb.collisionDetectionMode = CollisionDetectionMode.ContinuousDynamic;
        }

        //================================================================================

        private void OnApplicationQuit()
        {
            Cursor.visible = true;
            Cursor.lockState = CursorLockMode.None;
        }

        //================================================================================

        //private void OnCollisionEnter(Collision collision)
        //{
        //    Debug.Log("Time: " + Time.time + "   collided with: " + collision.collider.name);
        //}

        //================================================================================

        private void FixedUpdate()
        {
            deltaTime = Time.fixedDeltaTime;
            smoothFactor = (smoothingTime > deltaTime) ? deltaTime / smoothingTime : 1f;

            inputMouse = Vector3.zero;
            inputWASD = Vector3.zero;

            // mouse input (desktop / laptop)
            if (SystemInfo.deviceType == DeviceType.Desktop)
            {
                inputMouse = (SystemInfo.deviceType != DeviceType.Handheld) ? new Vector3(Input.GetAxis("Mouse Y"), Input.GetAxis("Mouse X"), 0f) : Vector3.zero;
                inputMouse *= deltaTime * sensitivity * 5f;
                if (invertMouseY)
                {
                    inputMouse.x *= -1;
                }
                inputWASD = new Vector3(Input.GetAxis("Horizontal"), 0f, Input.GetAxis("Vertical"));
                speedMultiplierEnabled = (Input.GetKey(KeyCode.LeftShift)) ? true : false;
            }

            // touch input (mobile devices)
            if (SystemInfo.deviceType == DeviceType.Handheld)
            {
                foreach (Touch touch in Input.touches)
                {
                    if (touch.fingerId == inputTouchRotateID)
                    {
                        if (touch.phase == TouchPhase.Canceled || touch.phase == TouchPhase.Ended)
                        {
                            inputTouchRotateID = -1;
                            continue;
                        }
                    }
                    if (touch.fingerId == inpuTouchMoveID)
                    {
                        if (touch.phase == TouchPhase.Canceled || touch.phase == TouchPhase.Ended)
                        {
                            inpuTouchMoveID = -1;
                            speedMultiplierEnabled = false;
                            continue;
                        }
                    }
                    if (touch.phase == TouchPhase.Began)
                    {
                        if (touch.position.x > Screen.width * 0.5)
                        {
                            inputTouchRotateID = touch.fingerId;
                            continue;
                        }
                        if (touch.position.x < Screen.width * 0.5)
                        {
                            inpuTouchMoveID = touch.fingerId;
                            inputTouchMoveCenter = touch.position;
                            speedMultiplierEnabled = (touch.tapCount > 1) ? true : false;
                            continue;
                        }
                        continue;
                    }
                    if (touch.fingerId == inputTouchRotateID)
                    {
                        if (touch.phase == TouchPhase.Moved)
                        {
                            inputMouse = new Vector3(-touch.deltaPosition.y, touch.deltaPosition.x, 0f);
                            inputMouse *= deltaTime * sensitivity * 0.2f;
                        }
                    }
                    if (touch.fingerId == inpuTouchMoveID)
                    {

                        inputWASD = new Vector3(touch.position.x - inputTouchMoveCenter.x, 0f, touch.position.y - inputTouchMoveCenter.y);
                        inputWASD /= Screen.height;
                        inputWASD *= 10f;
                        if (inputWASD.sqrMagnitude > 1f)
                        {
                            inputWASD.Normalize();
                        }
                    }
                }
            }

            // rotation
            heading = Mathf.MoveTowardsAngle(heading, heading + inputMouse.y, sensitivity);
            pitch = Mathf.MoveTowardsAngle(pitch, pitch + inputMouse.x, sensitivity);
            pitch = Mathf.Clamp(pitch, pitchMin, pitchMax);
            roll = 0f;
            newRotation = Quaternion.Euler(0f, heading, 0f) * Quaternion.Euler(pitch, 0f, 0f) * Quaternion.Euler(0f, 0f, roll);
            transform.rotation = Quaternion.Slerp(transform.rotation, newRotation, smoothFactor);
            rb.angularVelocity = Vector3.zero;

            // translation
            float speedMultiplierTemp = speedMultiplierEnabled ? speedMultiplier : 1f;
            localVelocity = transform.InverseTransformDirection(rb.velocity);
            localVelocity += inputWASD * acceleration * deltaTime * speedMultiplierTemp;
            rb.velocity = transform.TransformDirection(localVelocity);

            terrainSampleAtPlayer = EasyTerrain.GetTerrainSample(transform.position);
			if (transform.position.y < terrainSampleAtPlayer.height + minHeightToGround)
            {
                transform.position = new Vector3(transform.position.x, Mathf.Clamp(transform.position.y, terrainSampleAtPlayer.height + minHeightToGround, maxHeight), transform.position.z);
                rb.velocity = Vector3.RotateTowards(rb.velocity, Vector3.ProjectOnPlane(rb.velocity, terrainSampleAtPlayer.normal) * rb.velocity.magnitude, Mathf.PI * 0.5f * deltaTime, 1f * deltaTime);
            }
            else
            {
                rb.velocity = Vector3.RotateTowards(rb.velocity, transform.TransformDirection(inputWASD) * rb.velocity.magnitude, Mathf.PI * 0.5f * deltaTime, 1f * deltaTime);
            }

            if (inputWASD.sqrMagnitude > 0.01f)
            {
                rb.drag = 0.0f;
            }
            else
            {
                rb.drag = 0.75f;
                rb.velocity *= 0.5f;
            }

            if (rb.velocity.magnitude > maxSpeed * speedMultiplierTemp)
            {
                speed = Mathf.Lerp(rb.velocity.magnitude, maxSpeed * speedMultiplierTemp, smoothFactor);
                rb.velocity = rb.velocity.normalized * speed;
            }

        }

        //================================================================================

    }
}