using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;

public class FileHelper {


    public static string StreamingAssetsPath(string path) {
        string streamingAssetsPath = Path.Combine(Application.streamingAssetsPath, path);
        return streamingAssetsPath;
    }

    public static void WriteAllText(string path, string text) {
        File.WriteAllText(path, text);
    }

    public static string ReadAllText(string path) {
        return File.ReadAllText(path);
    }

    public static string DataPath(string path) {
        string dataPath = Path.Combine(Application.dataPath, path);
        return dataPath;
    }



    public static string GetSK(string k, string v, string str) {
        RijndaelManaged rijndaelCipher = new RijndaelManaged();
        rijndaelCipher.Mode = CipherMode.CBC;
        rijndaelCipher.Padding = PaddingMode.Zeros;
        rijndaelCipher.KeySize = 128;
        rijndaelCipher.BlockSize = 128;
        byte[] pwdBytes = System.Text.Encoding.UTF8.GetBytes(k);
        byte[] keyBytes = new byte[16];
        int len = pwdBytes.Length;
        if (len > keyBytes.Length)
            len = keyBytes.Length;
        System.Array.Copy(pwdBytes, keyBytes, len);
        rijndaelCipher.Key = keyBytes;
        rijndaelCipher.IV = Encoding.UTF8.GetBytes(v);
        ICryptoTransform transform = rijndaelCipher.CreateEncryptor();
        byte[] plainText = Encoding.UTF8.GetBytes(str);
        byte[] cipherBytes = transform.TransformFinalBlock(plainText, 0, plainText.Length);
        string result = Convert.ToBase64String(cipherBytes);
        return result;
    }

    /// <summary>
    /// 计算字符串的MD5值
    /// </summary>
    public static string md5(string source) {
        MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
        byte[] data = System.Text.Encoding.UTF8.GetBytes(source);
        byte[] md5Data = md5.ComputeHash(data, 0, data.Length);
        md5.Clear();
        string destString = "";
        for (int i = 0; i < md5Data.Length; i++) {
            destString += System.Convert.ToString(md5Data[i], 16).PadLeft(2, '0');
        }
        destString = destString.PadLeft(32, '0');
        return destString;
    }
}

public class WriteByteFile
{
    FileStream file;
    private WriteByteFile() {
    }
    public WriteByteFile(string path) {
        file = new FileStream(path, FileMode.Create);
    }
    public void Close() {
        file.Close();
    }

    public void Write(byte[] array) {
        int count = array.Length;
        file.Write(array, 0, count);
    }

    public void Write(bool value) {
        byte[] array = BitConverter.GetBytes(value);
        Write(array);
    }

    public void Write(byte value) {
        byte[] array = new byte[] { value };
        Write(array);
    }

    public void Write(char value) {
        byte[] array = BitConverter.GetBytes(value);
        Write(array);
    }

    public void Write(double value) {
        byte[] array = BitConverter.GetBytes(value);
        Write(array);
    }

    public void Write(float value) {
        byte[] array = BitConverter.GetBytes(value);
        Write(array);
    }

    public void Write(int value) {
        byte[] array = BitConverter.GetBytes(value);
        Write(array);
    }

    public void Write(long value) {
        byte[] array = BitConverter.GetBytes(value);
        Write(array);
    }

    public void Write(sbyte value) {
        byte[] array = new byte[] { (byte)value };
        Write(array);
    }

    public void Write(short value) {
        byte[] array = BitConverter.GetBytes(value);
        Write(array);
    }

    public void Write(uint value) {
        byte[] array = BitConverter.GetBytes(value);
        Write(array);
    }

    public void Write(ulong value) {
        byte[] array = BitConverter.GetBytes(value);
        Write(array);
    }

    public void Write(ushort value) {
        byte[] array = BitConverter.GetBytes(value);
        Write(array);
    }

    public void Write(string value) {
        byte[] array = Encoding.UTF8.GetBytes(value);
        int len = array.Length;
        Write(len);
        Write(array);
        Debug.LogError(len+" 保存字符串 " + value);
    }
}

public class ReadByteFile
{
    FileStream file;
    private ReadByteFile() {
    }
    public ReadByteFile(string path) {
        file = new FileStream(path, FileMode.Open);
    }
    public void Close() {
        file.Close();
    }

    public void Read(out bool value) {
        byte[] data = new byte[sizeof(bool)];
        file.Read(data, 0, data.Length);
        value = BitConverter.ToBoolean(data, 0);
    }

    public void Read(out byte value) {
        byte[] data = new byte[sizeof(byte)];
        file.Read(data, 0, data.Length);
        value = data[0];
    }

    public void Read(out char value) {
        byte[] data = new byte[sizeof(char)];
        file.Read(data, 0, data.Length);
        value = BitConverter.ToChar(data, 0);
    }

    public void Read(out double value) {
        byte[] data = new byte[sizeof(double)];
        file.Read(data, 0, data.Length);
        value = BitConverter.ToDouble(data, 0);
    }

    public void Read(out float value) {
        byte[] data = new byte[sizeof(float)];
        file.Read(data, 0, data.Length);
        value = BitConverter.ToSingle(data, 0);
    }

    public void Read(out int value) {
        byte[] data = new byte[sizeof(int)];
        file.Read(data, 0, data.Length);
        value = BitConverter.ToInt32(data, 0);
    }

    public void Read(out long value) {
        byte[] data = new byte[sizeof(long)];
        file.Read(data, 0, data.Length);
        value = BitConverter.ToInt64(data, 0);
    }

    public void Read(out sbyte value) {
        byte[] data = new byte[sizeof(sbyte)];
        file.Read(data, 0, data.Length);
        value = (sbyte)data[0];
    }

    public void Read(out short value) {
        byte[] data = new byte[sizeof(short)];
        file.Read(data, 0, data.Length);
        value = BitConverter.ToInt16(data, 0);
    }

    public void Read(out uint value) {
        byte[] data = new byte[sizeof(uint)];
        file.Read(data, 0, data.Length);
        value = BitConverter.ToUInt32(data, 0);
    }

    public void Read(out ulong value) {
        byte[] data = new byte[sizeof(ulong)];
        file.Read(data, 0, data.Length);
        value = BitConverter.ToUInt64(data, 0);
    }

    public void Read(out ushort value) {
        byte[] data = new byte[sizeof(ushort)];
        file.Read(data, 0, data.Length);
        value = BitConverter.ToUInt16(data, 0);
    }

    public void Read(out string value) {
        Read(out int len);
        byte[] data = new byte[len];
        file.Read(data, 0, data.Length);
        value = Encoding.UTF8.GetString(data);
        Debug.LogError(len + " 读取字符串 " + value);
    }
}