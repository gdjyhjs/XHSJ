#ifndef EasyTerrain_Standard_Tools
#define EasyTerrain_Standard_Tools

    // Access the Shaderlab properties
    uniform sampler2D _Control;
    uniform sampler2D _Splat0,_Splat1,_Splat2,_Splat3;
    uniform half4 _Splat0_ST,_Splat1_ST,_Splat2_ST,_Splat3_ST;
    uniform sampler2D _Normal0,_Normal1,_Normal2,_Normal3;
    uniform sampler2D _MainTex;
    
    uniform half3 _TerrainTileSize = half3(1,1,1);
    uniform half _UVmixingMultiplier = 0.1;
    uniform half _UVmixingDistanceNear = 4.0;
    uniform half _UVmixingDistanceFar = 16.0;
    uniform half _MainTexDistance = 200.0;

    uniform float3 worldPosition;
    uniform float3 worldNormal;
    uniform float worldDistance;
    uniform half2 UVyA, UVyB, UVyC;
        
    // Surface shader input structure
    struct Input 
    {
        float2 uv_Control;
        float2 uv_MainTex;
        //float2 uv_Splat0, uv_Splat1, uv_Splat2, uv_Splat3;
        //float2 uv_Normal0, uv_Normal1, uv_Normal2, uv_Normal3;
        float3 worldPos; // Contains world space position.
        float3 worldNormal; INTERNAL_DATA   // Contains world normal vector if surface shader writes to o.Normal. 
                                            // To get the normal vector based on per-pixel normal map, use WorldNormalVector (IN, o.Normal).
    };
    
    // Set variables for World Position and Distance
    void SetWorldVariables(in Input IN, in SurfaceOutputStandard o) 
    {
        worldPosition = IN.worldPos;
        float3 direction = worldPosition - _WorldSpaceCameraPos;
        worldDistance = sqrt(dot(direction,direction));
        worldNormal = normalize(WorldNormalVector (IN, o.Normal));
    }

    // Blend Splat and Normal
    void MultiUVmixing(out fixed3 splatColor, 
                       out fixed3 normalColor, 
                       in sampler2D SplatTexture, 
                       in sampler2D NormalTexture, 
                       in float2 UV,
                       in half blendFactor)
    {
        if (blendFactor > 0)
        {
            float2 UVyA = UV;
            float2 UVyB = -UVyA * _UVmixingMultiplier; 
            float2 UVyC = -UVyB * _UVmixingMultiplier; 
            fixed4 subSplatA = tex2D (SplatTexture, UVyA);
            fixed4 subSplatB = tex2D (SplatTexture, UVyB);
            fixed4 subSplatC = tex2D (SplatTexture, UVyC);
            splatColor = lerp (0.8*subSplatA+0.15*subSplatB+0.05*subSplatC,0.3*subSplatA+0.6*subSplatB+0.1*subSplatC, smoothstep(0, _UVmixingDistanceNear, worldDistance));  
            splatColor = lerp (splatColor,0.5*subSplatB+0.5*subSplatC, smoothstep(0, _UVmixingDistanceFar, worldDistance)); 
            splatColor *= blendFactor; 
            fixed3 subNormalA = UnpackNormal(tex2D(NormalTexture, UVyA));
            fixed3 subNormalB = UnpackNormal(tex2D(NormalTexture, UVyB));
            fixed3 subNormalC = UnpackNormal(tex2D(NormalTexture, UVyC));
            normalColor = lerp (0.5*subNormalA+0.3*subNormalB+0.2*subNormalC,0.8*subNormalB+0.2*subNormalC, smoothstep(0, _UVmixingDistanceNear, worldDistance));  
            normalColor = lerp (normalColor,0.5*subNormalB+0.5*subNormalC, smoothstep(_UVmixingDistanceNear, _UVmixingDistanceFar, worldDistance));
            normalColor *= blendFactor;
        }
        else
        {
            splatColor = fixed3(0,0,0);
            normalColor = fixed3(0,0,0);
        }
    }
      
    void MultiUVmixingXZ(inout fixed3 color, inout fixed3 normal, in half4 splat_control)
    {
        half3 color0, color1, color2, color3;
        half3 normal0, normal1, normal2, normal3;
        MultiUVmixing(color0, normal0, _Splat0, _Normal0, worldPosition.xz * _Splat0_ST.xy / _TerrainTileSize.xz, splat_control.r);
        MultiUVmixing(color1, normal1, _Splat1, _Normal1, worldPosition.xz * _Splat1_ST.xy / _TerrainTileSize.xz, splat_control.g);
        MultiUVmixing(color2, normal2, _Splat2, _Normal2, worldPosition.xz * _Splat2_ST.xy / _TerrainTileSize.xz, splat_control.b);
        MultiUVmixing(color3, normal3, _Splat3, _Normal3, worldPosition.xz * _Splat3_ST.xy / _TerrainTileSize.xz, splat_control.a);
        color = color0 + color1 + color2 + color3;
        normal = fixed3(0,0,0.001) + normal0 + normal1 + normal2 + normal3;
        normal = normalize(normal);
    }        
      
          
    void MultiUVmixingXY(inout fixed3 color, inout fixed3 normal, in half4 splat_control)
    {
        half3 color0, color1, color2, color3;
        half3 normal0, normal1, normal2, normal3;
        MultiUVmixing(color0, normal0, _Splat0, _Normal0, worldPosition.xy * _Splat0_ST.xy / _TerrainTileSize.xy, splat_control.r);
        MultiUVmixing(color1, normal1, _Splat1, _Normal1, worldPosition.xy * _Splat1_ST.xy / _TerrainTileSize.xy, splat_control.g);
        MultiUVmixing(color2, normal2, _Splat2, _Normal2, worldPosition.xy * _Splat1_ST.xy / _TerrainTileSize.xy, splat_control.b);
        MultiUVmixing(color3, normal3, _Splat3, _Normal3, worldPosition.xy * _Splat1_ST.xy / _TerrainTileSize.xy, splat_control.a);        
        color = color0 + color1 + color2 + color3;
        normal = fixed3(0,0,0.001) + normal0 + normal1 + normal2 + normal3;
        normal = normalize(normal);
    } 
    
    void MultiUVmixingYZ(inout fixed3 color, inout fixed3 normal, in half4 splat_control)
    {
        half3 color0, color1, color2, color3;
        half3 normal0, normal1, normal2, normal3;
        MultiUVmixing(color0, normal0, _Splat0, _Normal0, worldPosition.zy * _Splat0_ST.xy / _TerrainTileSize.zy, splat_control.r);
        MultiUVmixing(color1, normal1, _Splat1, _Normal1, worldPosition.zy * _Splat0_ST.xy / _TerrainTileSize.zy, splat_control.g);
        MultiUVmixing(color2, normal2, _Splat2, _Normal2, worldPosition.zy * _Splat0_ST.xy / _TerrainTileSize.zy, splat_control.b);
        MultiUVmixing(color3, normal3, _Splat3, _Normal3, worldPosition.zy * _Splat0_ST.xy / _TerrainTileSize.zy, splat_control.a);        
        color = color0 + color1 + color2 + color3;
        normal = fixed3(0,0,0.001) + normal0 + normal1 + normal2 + normal3;
        normal = normalize(normal);
    } 

    void SplatmapFinalColor(Input IN, SurfaceOutputStandard o, inout fixed4 color)
    {
        color *= o.Alpha;
        //#ifdef TERRAIN_SPLAT_ADDPASS
        //    UNITY_APPLY_FOG_COLOR(IN.fogCoord, color, fixed4(0,0,0,0));
        //#else
        //    UNITY_APPLY_FOG(IN.fogCoord, color);
        //#endif
    }

#endif