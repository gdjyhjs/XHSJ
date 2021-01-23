using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Reflection;
using UnityEngine;

namespace GenerateWorld {
    public static class MapTools {

        public static int IntegerSqrt(int value) {
            int result = 0;
            while (result * result < value) {
                result++;
            }
            return result;
        }

        public static string GetEnumName<T>(T value) where T : new() {
            Type t = typeof(T);
            foreach (MemberInfo mInfo in t.GetMembers()) {
                if (mInfo.Name == t.GetEnumName(value)) {
                    foreach (Attribute attr in Attribute.GetCustomAttributes(mInfo)) {
                        if (attr.GetType() == typeof(DescriptionAttribute)) {
                            return ((DescriptionAttribute)attr).Description;
                        }
                    }
                }
            }
            return "";
        }

        static System.Random rand = new System.Random();
        public static void SetRandomSeed(int seed) {
            rand = new System.Random(seed);
        }
        public static int RandomRange(int min, int max) {
            if (max < min) {
                int tmp = min;
                min = max;
                max = tmp;
            }
            return rand.Next(min, max);
        }
        public static float RandomRange(float min, float max) {
            return RandomRange((int)(min * 100), (int)(max * 100)) * 0.01f;
        }

    }

    [System.Serializable]
    public struct Vector {
        public float x, y, z;
        public Vector(float x, float y,float z) {
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
    }


}