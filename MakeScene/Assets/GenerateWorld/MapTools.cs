using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Reflection;
using System.Threading;
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

        //static System.Random rand = new System.Random();
        public static void SetRandomSeed(int seed, out System.Random rand) {
            rand = new System.Random(seed);
        }
        public static int RandomRange(int min, int max, System.Random rand) {
            if (max < min) {
                int tmp = min;
                min = max;
                max = tmp;
            }
            lock (rand) {
                return rand.Next(min, max);
            }
        }
        public static float RandomRange(float min, float max, System.Random rand) {
            return RandomRange((int)(min * 100), (int)(max * 100), rand) * 0.01f;
        }

    }

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
    }

    public class FileTools {
        public string err;
        public bool isdone = false;
        public float progress = 0; // 读取进度
        protected Thread thread;
        public byte[] result;
        public void Close() {
            if (thread != null) {
                thread.Abort();
            }
        }
    }

    public class FileWriteTools: FileTools {
        public FileWriteTools(string path, byte[] data) {
            thread = new Thread(() => {
                using (FileStream wr = new FileStream(path, FileMode.OpenOrCreate, FileAccess.Write)) {
                    long count = data.Length; // 文件长度
                    if (count <= 0) {
                        err = "The file is too small";
                        isdone = true;
                        return;
                    }
                    int start = 0; // 开始写入
                    int num = 0; // 每次读取的长度
                    long end = count; // 剩余写入长度
                    long length = (long)(count * 1f / 10000);
                    if (length < 1024)
                        length = 1024;
                    if (length > (int.MaxValue - 1024)) {
                        length = int.MaxValue - 1024;
                    }
                    int maxlength = Convert.ToInt32(length); // 每次读取的数量
                    byte[] bytes = new byte[maxlength];
                    while (end > 0) {
                        if (end < maxlength) {
                            num = Convert.ToInt32(end);
                        } else {
                            num = maxlength;
                        }
                        Array.Copy(data, start, bytes, 0, num); //复制需要写入的字节
                        if (num == 0)
                            break;
                        wr.Write(bytes, 0, num);
                        start += num;
                        end -= num;
                        progress = System.Math.Min((count - end) * 1f / count, 1);
                    }
                    isdone = true;
                    progress = 1;
                }
            });
            thread.Start();
        }
    }

    public class FileReadTools : FileTools {
        public FileReadTools(string path) {
            thread = new Thread(() => {
                using (FileStream fs = new FileStream(path, FileMode.OpenOrCreate, FileAccess.Read)) {
                    long count = fs.Length; // 文件长度
                    if (count > int.MaxValue) {
                        err = "The file is too large";
                        isdone = true;
                        return;
                    }
                    int start = 0; // 开始读取
                    int num = 0; // 每次读取的长度
                    long end = count; // 剩余读取长度
                    long length = (long)(count * 1f / 10000);
                    if (length < 1024)
                        length = 1024;
                    if (length > (int.MaxValue - 1024)) {
                        length = int.MaxValue - 1024;
                    }
                    int maxlength = Convert.ToInt32(length); // 每次读取的数量
                    List<byte> cache = new List<byte>(Convert.ToInt32(count));
                    byte[] bytes = new byte[maxlength];
                    while (end > 0) {
                        fs.Position = start;
                        if (end < maxlength) {
                            num = fs.Read(bytes, 0, Convert.ToInt32(end)); //读取文件
                        } else {
                            num = fs.Read(bytes, 0, maxlength);
                        }
                        cache.AddRange(bytes);
                        if (num == 0)
                            break;
                        start += num;
                        end -= num;
                        progress = Math.Min((count - end) * 1f / count, 1);
                    }
                    result = cache.ToArray();
                    isdone = true;
                    progress = 1;
                }
            });
            thread.Start();

        }
    }
}