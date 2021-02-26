
using UnityEngine;
[System.Serializable]
public struct Vector {
    public float x, y, z;
    public Vector(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public static implicit operator Vector(Vector3 v3) {
        return new Vector(v3.x, v3.y, v3.z);
    }
    public static implicit operator Vector3(Vector v) {
        return new Vector3(v.x, v.y, v.z);
    }

    public static Vector operator *(Vector a, int value) {
        Vector res = new Vector(a.x * value, a.y * value, a.z * value);
        return res;
    }
}
