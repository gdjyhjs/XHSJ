Shader "Hidden/TerrainEngine/Splatmap/EasyTerrain_Standard_Base" 
{
    Properties 
    {
        _MainTex ("Base (RGB)", 2D) = "black" {}
    }

    SubShader 
    {
        Tags 
        { 
            "RenderType"="Opaque" 
            "Queue" = "Geometry-100"
        }
        LOD 200

        CGPROGRAM
            #pragma surface surf Standard fullforwardshadows
            #pragma target 3.0
            #pragma multi_compile_fog
            #pragma instancing_options assumeuniformscaling
            UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props) 
            
            // Access the Shaderlab properties
            uniform sampler2D _MainTex;  
        
            struct Input 
            {
                half2 uv_MainTex;
            };
            
            void surf (Input IN, inout SurfaceOutputStandard o) 
            {
                fixed4 color = tex2D (_MainTex, IN.uv_MainTex);
                o.Albedo = color.rgb;
                o.Alpha = color.a;
                o.Normal = half3(0,0,1);
                o.Emission = half3(0,0,0);
                o.Metallic = 0;
                o.Smoothness = 0;
                o.Occlusion = 1;
            }
        ENDCG
    }

    FallBack "Hidden/TerrainEngine/Splatmap/Standard-Base"
    FallBack "Diffuse"
}