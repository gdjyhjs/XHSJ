Shader "Custom/GaussianBlur"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _blurSize("blurSize", Float) = 1
        
    }
    SubShader
    {
        CGINCLUDE
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            half4 _MainTex_TexelSize;
            float _blurSize;

            struct v2f
            {
                float4 pos : SV_POSITION;
                half2 uv[5] : TEXCOORD0;
            };

            v2f verBlurHorizontal(appdata_img v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                half2 uv = v.texcoord;
                o.uv[0] = uv;
                o.uv[1] = uv + float2(0.0, _MainTex_TexelSize.x * 1.0) * _blurSize;
                o.uv[2] = uv - float2(0.0, _MainTex_TexelSize.x * 1.0) * _blurSize;
                o.uv[3] = uv + float2(0.0, _MainTex_TexelSize.x * 2.0) * _blurSize;
                o.uv[4] = uv - float2(0.0, _MainTex_TexelSize.x * 2.0) * _blurSize;
                return o;
            }

            v2f verBlurVertical(appdata_img v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                half2 uv = v.texcoord;
                o.uv[0] = uv;
                o.uv[1] = uv + float2(0.0, _MainTex_TexelSize.y * 1.0) * _blurSize;
                o.uv[2] = uv - float2(0.0, _MainTex_TexelSize.y * 1.0) * _blurSize;
                o.uv[3] = uv + float2(0.0, _MainTex_TexelSize.y * 2.0) * _blurSize;
                o.uv[4] = uv - float2(0.0, _MainTex_TexelSize.y * 2.0) * _blurSize;
                return o;
            }

            fixed4 fragBlur(v2f i) : SV_Target
            {
                //fixed3 sum = tex2D(_MainTex, i.uv[0]);
                float weight[3] = {0.4023, 0.2442, 0.0545};

                fixed3 sum = tex2D(_MainTex, i.uv[0]).rgb * weight[0];
                for (int it = 1; it < 3; it++) {
                    sum += tex2D(_MainTex, i.uv[it * 2 - 1]).rgb * weight[it];
                    sum += tex2D(_MainTex, i.uv[it * 2]).rgb * weight[it];
                }

                fixed4 col = fixed4(sum, 1.0);
                return col;
            }
        ENDCG


        ZTest Always
        Cull Off
        ZWrite Off
        Pass
        {
            NAME "GAUSSIAN_BLUR_VERTICAL"
            CGPROGRAM
            #pragma vertex verBlurVertical
            #pragma fragment fragBlur
            ENDCG
        }
        Pass
        {
            NAME "GAUSSIAN_BLUR_HORIZONTAL"
            CGPROGRAM
            #pragma vertex verBlurHorizontal
            #pragma fragment fragBlur
            ENDCG
        }
    }
    Fallback Off
}
