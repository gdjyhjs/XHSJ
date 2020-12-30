using UnityEngine;
using System.Collections;
using System.IO;
using System.Text;
using System;
using System.Linq;

namespace Seven
{
	public class ByteBuffer
	{
	    MemoryStream stream = null;
	    BinaryWriter writer = null;
	    BinaryReader reader = null;

	    public ByteBuffer()
	    {
	        stream = new MemoryStream();
	        writer = new BinaryWriter(stream);
	    }

	    public ByteBuffer(byte[] data)
	    {
	        if (data != null)
	        {
	            stream = new MemoryStream(data);
	            reader = new BinaryReader(stream);
	        }
	        else
	        {
	            stream = new MemoryStream();
	            writer = new BinaryWriter(stream);
	        }
	    }

	    public ByteBuffer(MemoryStream ms)
	    {
	        stream = ms;
	        reader = new BinaryReader(stream);
	    }

	    public void Close()
	    {
	        if (writer != null) writer.Close();
	        if (reader != null) reader.Close();

	        stream.Close();
	        writer = null;
	        reader = null;
	        stream = null;
	    }

	    #region Writer

	    public void WriteByte(byte v)
	    {
	        if (writer == null) return;
	        writer.Write(v);
	    }

	    public void WriteInt(int v)
	    {
	        if (writer == null) return;
	        writer.Write((int)v);
	    }

	    public void WriteShort(ushort v)
	    {
	        if (writer == null) return;
	        writer.Write((ushort)v);
	    }

	    public void WriteLong(long v)
	    {
	        if (writer == null) return;
	        writer.Write((long)v);
	    }

	    public void WriteFloat(float v)
	    {
	        if (writer == null) return;

	        byte[] temp = BitConverter.GetBytes(v);
	        Array.Reverse(temp);
	        writer.Write(BitConverter.ToSingle(temp, 0));
	    }

	    public void WriteDouble(double v)
	    {
	        if (writer == null) return;

	        byte[] temp = BitConverter.GetBytes(v);
	        Array.Reverse(temp);
	        writer.Write(BitConverter.ToDouble(temp, 0));
	    }

	    public void WriteString(string v)
	    {
	        if (writer == null) return;

	        byte[] bytes = Encoding.UTF8.GetBytes(v);
	        writer.Write(bytes);
	    }

	    public void WriteBytes(byte[] v)
	    {
	        if (writer == null) return;

	        writer.Write(v);
	    }

	    public void Flush()
	    {
	        if (writer != null)
	            writer.Flush();
	    }

	    #endregion

	    #region Reader

	    public byte ReadByte()
	    {
	        return reader.ReadByte();
	    }

	    public int ReadInt()
	    {
	        return (int)reader.ReadInt32();
	    }

	    public ushort ReadShort()
	    {
	        return (ushort)reader.ReadInt16();
	    }

	    public long ReadLong()
	    {
	        return (long)reader.ReadInt64();
	    }

	    public float ReadFloat()
	    {
	        byte[] temp = BitConverter.GetBytes(reader.ReadSingle());
	        Array.Reverse(temp);
	        return BitConverter.ToSingle(temp, 0);
	    }

	    public double ReadDouble()
	    {
	        byte[] temp = BitConverter.GetBytes(reader.ReadDouble());
	        Array.Reverse(temp);
	        return BitConverter.ToDouble(temp, 0);
	    }

	    public string ReadString()
	    {
	        ushort len = ReadShort();
	        byte[] buffer = new byte[len];
	        buffer = reader.ReadBytes(len);
	        return Encoding.UTF8.GetString(buffer);
	    }

	    public byte[] ReadBytes()
	    {
	        int len = ReadInt();
	        return reader.ReadBytes(len);
	    }

	    #endregion

	    //public LuaByteBuffer ReadBuffer() {
	    //    byte[] bytes = ReadBytes();
	    //    return new LuaByteBuffer(bytes);
	    //}

	    public byte[] ToBytes()
	    {
	        Flush();
	        return stream.ToArray();
	    }

	    public string ToBase64()
	    {
	        var bytes = ToBytes();
	        return Convert.ToBase64String(bytes);
	    }

	    public string ToByteStr()
	    {
	        var bytes = ToBytes();
	        return bytes.Aggregate("", (current, b) => current + (b + ","));
	    }
	}
}
