using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices.WindowsRuntime;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public abstract class PostEffectBase : MonoBehaviour
{
    protected void CheckResources()
    {
        bool isSupported = CheckSupport();
        if (isSupported == false) {
            NotStpported();
        }
    }

    private bool CheckSupport() {
        if (SystemInfo.supportsImageEffects == false || SystemInfo.supportsRenderTextures == false) {
            return false;
        }
        return true;
    }

    private void NotStpported() {
        enabled = false;
    }

    protected void Start() {
        CheckResources();
    }

    protected Material CheckShaderAndCreateMaterial(Shader shader, Material material) {
        if (shader == null) {
            return null;
        }
        if (shader.isSupported && material && material.shader == shader) {
            return material;
        }
        if (!shader.isSupported) {
            return null;
        } else {
            material = new Material(shader);
            material.hideFlags = HideFlags.DontSave;
            if (material)
                return material;
            else
                return null;
        }
    }


}
