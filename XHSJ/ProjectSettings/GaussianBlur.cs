using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class GaussianBlur : PostEffectBase
{
    public Shader gaussinaBlurShader;
    private Material gaussinaBlurMaterial;
    public Material material
    {
        get
        {
            gaussinaBlurMaterial = CheckShaderAndCreateMaterial(gaussinaBlurShader, gaussinaBlurMaterial);
            return gaussinaBlurMaterial;
        }
    }

    [Range(0, 4)]
    public int iterations = 3;
    [Range(0.2f, 3)]
    public float blurSpread = .6f;
    [Range(1, 8)]
    public int downSample = 2;

    private void OnRenderImage(RenderTexture src, RenderTexture dest) {
        if (material != null) {
            int rtW = src.width / downSample;
            int rtH = src.height / downSample;
            RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
            buffer0.filterMode = FilterMode.Bilinear;

            Graphics.Blit(src, buffer0);

            for (int i = 0; i < iterations; i++) {
                material.SetFloat("_blurSize", 1.0f + i * blurSpread);

                RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

                Graphics.Blit(buffer0, buffer1, material, 0);

                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
                buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

                Graphics.Blit(buffer0, buffer1, material, 1);

                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
            }
            Graphics.Blit(buffer0, dest);
            RenderTexture.ReleaseTemporary(buffer0);
        } else {
            Graphics.Blit(src, dest);
        }
    }


    private void OnRenderImageThree(RenderTexture src, RenderTexture dest) {
        if (material != null) {
            int rtW = src.width / downSample;
            int rtH = src.height / downSample;
            RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);
            Graphics.Blit(src, buffer, material, 0);
            Graphics.Blit(buffer, dest, material, 1);
            RenderTexture.ReleaseTemporary(buffer);
        } else {
            Graphics.Blit(src, dest);
        }
    }


    private void OnRenderImageTwo(RenderTexture src, RenderTexture dest) {
        if (material != null) {
            int rtW = src.width / downSample;
            int rtH = src.height / downSample;
            RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);
            Graphics.Blit(src, buffer, material, 0);
            Graphics.Blit(buffer, dest, material, 1);
            RenderTexture.ReleaseTemporary(buffer);
        } else {
            Graphics.Blit(src, dest);
        }
    }


    private void OnRenderImageOne(RenderTexture src, RenderTexture dest) {
        if (material != null) {
            int rtW = src.width;
            int rtH = src.height;
            RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);
            material.SetInt("_iterations", iterations);
            material.SetFloat("_blurSpread", blurSpread);
            material.SetInt("_downSample", downSample);
            Graphics.Blit(src, buffer, material, 0);
            Graphics.Blit(buffer, dest, material, 1);
            RenderTexture.ReleaseTemporary(buffer);
        } else {
            Graphics.Blit(src, dest);
        }
    }
}
