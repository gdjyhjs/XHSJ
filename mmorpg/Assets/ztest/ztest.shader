Shader "ztest/Normal Mapping" {  
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}

        //1
        _Bump ("Bump", 2D) = "bump" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;

        //2
        sampler2D _Bump;                

        struct Input {
            float2 uv_MainTex;

            //3
            float2 uv_Bump;
        };

        void surf (Input IN, inout SurfaceOutput o) {
            half4 c = tex2D (_MainTex, IN.uv_MainTex);

            //4
            o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));

            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    } 
    FallBack "Diffuse"
}