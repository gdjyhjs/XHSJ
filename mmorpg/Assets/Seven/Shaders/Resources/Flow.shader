// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
// 流光

Shader "Seven/Flow" {
	Properties       
    {      
        _Color("Color", Color) = (1,1,1,1)        
        _MainTex("Albedo", 2D) = "white" {}      
        _AfterTex("_AfterTex", 2D) = "white" {} // 流光贴图 
        _AfterAlphaTex("_AfterAlphaTex", 2D) = "white" {} // 流光alpha贴图
        _AfterColor ("After Color", Color) = (0.435, 0.851, 1, 0.419)  
        _FlowSpeed("Flow Speed", Range(0, 10)) = 1   // 流光速度
    }      
          
    SubShader  
    {      
        Tags { "RenderType"="transparent" }      
        LOD 200      
        pass      
        {      
            CGPROGRAM    
            #pragma vertex vert      
            #pragma fragment frag      
            sampler2D _MainTex;      
            sampler2D _AfterTex;
            sampler2D _AfterAlphaTex;      
            float4  _AfterColor;  
  			fixed _FlowSpeed;

            struct appdata       
            {      
                float4 vertex : POSITION;      
                float4 texcoord : TEXCOORD0;   
                float3 normal : NORMAL;  
            };      
  
            struct v2f      
            {      
                float4 pos : POSITION;   
                float4 uv : TEXCOORD0;      
                float2 uvLight : TEXCOORD1;    
            };      
  
            v2f vert (appdata v)      
            {      
                v2f o;      
                o.pos = UnityObjectToClipPos(v.vertex);      
                o.uv = v.texcoord;      
                half2 nor;    
                nor.x = dot(UNITY_MATRIX_IT_MV[0].xyz,v.normal);    
                nor.y = dot(UNITY_MATRIX_IT_MV[1].xyz,v.normal);    
                o.uvLight = nor * 0.5 + 0.5;  
                return o;      
            }      
            float4 frag (v2f i) : COLOR      
            {      
                float4 col = tex2D(_MainTex, i.uv);      
                float4 lightCol = tex2D(_AfterTex, i.uvLight+_Time.xx * _FlowSpeed);  
                float4 alpha = tex2D(_AfterAlphaTex, i.uvLight+_Time.xx * _FlowSpeed); 
                lightCol.a *= alpha.r;  
                return col + lightCol * 1.0 * _AfterColor;      
            }      
            ENDCG  
        }  
    }  
}
