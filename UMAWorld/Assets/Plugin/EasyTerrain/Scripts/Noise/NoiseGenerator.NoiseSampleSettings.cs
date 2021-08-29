using UnityEngine;

namespace MouseSoftware
{
    public static partial class NoiseGenerator
    {
        [System.Serializable]
        public class NoiseSampleSettings
        {
            public NoiseGenerator.NoiseMethodType type = NoiseGenerator.NoiseMethodType.Perlin3D;
            [Range(-5000f, 5000f)]
            public float offsetX = 0f;
            [Range(-5000f, 5000f)]
            public float offsetY = 0f;
            [Range(-5000f, 5000f)]
            public float offsetZ = 0f;
            [Range(0.0001f, 0.01f)]
            public float frequency = 0.001f;
            [Range(1, 8)]
            public int octaves = 1;
            [Range(1f, 8f)]
            public float lacunarity = 2f;
            [Range(0f, 1f)]
            public float persistence = 0.5f;
            //public AnimationCurve adjustmentCurve = new AnimationCurve(new Keyframe(0f, 0f, 0f, 1f), new Keyframe(1f, 1f, 1f, 0f));
            [Range(0f, 1f)]
            public float threshold = 0.5f;
            [Range(0f, 1f)]
            public float falloff = 0.5f;
        } 
    } 
}