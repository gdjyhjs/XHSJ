Shader "Nature/Terrain/EasyTerrain_Standard" 
{
    Properties 
    {
        _TerrainTileSize ("Terrain size", Vector) = (1,1,1)

        // Splat Map Control Texture
        [HideInInspector] _Control ("Control (RGBA)", 2D) = "black" {}

        // Textures
        [HideInInspector] _Splat0 ("Layer 0 (R)", 2D) = "black" {}
        [HideInInspector] _Splat1 ("Layer 1 (G)", 2D) = "black" {}
        [HideInInspector] _Splat2 ("Layer 2 (B)", 2D) = "black" {}
        [HideInInspector] _Splat3 ("Layer 3 (A)", 2D) = "black" {}
        
        // Normal Maps
        [HideInInspector] _Normal0 ("Normal 0 (R)", 2D) = "bump" {}
        [HideInInspector] _Normal1 ("Normal 1 (G)", 2D) = "bump" {}
        [HideInInspector] _Normal2 ("Normal 2 (B)", 2D) = "bump" {}
        [HideInInspector] _Normal3 ("Normal 3 (A)", 2D) = "bump" {}
        
        // Used in fallback on old cards & also for distant base map
        [HideInInspector] _MainTex ("BaseMap (RGB)", 2D) = "black" {}
        
        // UV mixing Settings
        [Header(UV Mix Settings)]
        [PowerSlider(2.0)] _UVmixingMultiplier ("UV Multiplier", Range(0.001,0.5)) = 0.1

        [Header(UV Mix Distances)]
        [PowerSlider(2.0)] _UVmixingDistanceNear ("Near", Range(1,250)) = 8.0
        [PowerSlider(2.0)] _UVmixingDistanceFar ("Far", Range(1,250)) = 32.0
        
        [space(4)]
        [Toggle(_FADE_TO_BASEMAP_ON)] _FADE_TO_BASEMAP_ON("Fade to basemap", Int) = 1
        [PowerSlider(2.0)] _MainTexDistance ("Base Texture Distance", Range(1,1500)) = 750.0
        
        [space(4)]
        [Toggle(_TRIPLANAR_ON)] _TRIPLANAR_ON("Use TriPlanar Projection", Int) = 1
    }

    SubShader 
    {
        Tags 
        {
            "SplatCount" = "4"
            "Queue" = "Geometry-100"
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surf Standard fullforwardshadows finalcolor:SplatmapFinalColor
            #pragma target 3.0
            #pragma multi_compile_fog
            #pragma shader_feature _FADE_TO_BASEMAP_ON 
            #pragma shader_feature _TRIPLANAR_ON
            #pragma instancing_options assumeuniformscaling
            UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props) 
            
            #include "EasyTerrain_Standard_Tools.cginc"
            
            void surf (Input IN, inout SurfaceOutputStandard o) 
            {
                SetWorldVariables(IN, o);
                fixed3 color, normal;
                half4 splat_control = tex2D (_Control, IN.uv_Control);
                half weight = dot(splat_control, half4(1,1,1,1));
                #if defined(_EASYTERRAIN_STANDARD_SPLAT_ADDPASS)
                    clip(weight == 0 ? -1 : 1);
                #endif
                splat_control /= (weight + 1e-3f);
                
                #if _TRIPLANAR_ON
                    fixed3 colorXZ, normalXZ;
                    fixed3 colorXY, normalXY;
                    fixed3 colorYZ, normalYZ;
                    MultiUVmixingXZ(colorXZ,normalXZ, splat_control);
                    MultiUVmixingXY(colorXY,normalXY, splat_control);
                    MultiUVmixingYZ(colorYZ,normalYZ, splat_control);
                    fixed3 tpbf = abs(worldNormal); // tpbf = triplanar blend factor
                    tpbf /= (tpbf.x +  tpbf.y + tpbf.z);
                    color = (colorXZ * tpbf.y)  + (colorXY * tpbf.z) + (colorYZ * tpbf.x);
                    normal = normalize((normalXZ)  + (normalXY * tpbf.z) + (normalYZ * tpbf.x));
                #else
                    MultiUVmixingXZ(color,normal, splat_control);
                #endif
                   
                #if _FADE_TO_BASEMAP_ON
                    fixed3 mainTexColor = tex2D (_MainTex, IN.uv_MainTex);
                    mainTexColor = dot(splat_control,half4(1,1,1,1)) * mainTexColor;
                    fixed baseMapBlendValue = smoothstep(0.5*(_UVmixingDistanceFar + _MainTexDistance), _MainTexDistance, worldDistance);
                    o.Albedo = lerp (color, mainTexColor, baseMapBlendValue);
                    o.Normal = lerp (normal, fixed3(0,0,1), baseMapBlendValue);
                #else
                    o.Albedo = color;
                    o.Normal = normal;
                #endif
                
                o.Alpha = weight;
                o.Emission = half3(0,0,0);
                o.Metallic = 0;
                o.Smoothness = 0; 
                o.Occlusion = 1;
        }
    
		ENDCG
	} // END SubShader

    Dependency "AddPassShader" = "Hidden/TerrainEngine/Splatmap/EasyTerrain_Standard_AddPass"    
    Dependency "BaseMapShader" = "Hidden/TerrainEngine/Splatmap/EasyTerrain_Standard_Base" 

    Fallback "Nature/Terrain/Diffuse"
    
    CustomEditor "EasyTerrainShader_GUI"

} // END Shader