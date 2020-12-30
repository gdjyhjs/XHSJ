// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)
//图片圆角处理（调整radius）
Shader "Seven/UISprites/Circular"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		[PerRendererData] _AlphaTex("Sprite Alpha Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15
		[Toggle(SEVEN_UI_CIRCULAR)] _UseUIAlphaClip ("Sprite Circular", Float) = 0

        // 以 1 - _Radius 长度为半径的圆形
        _Radius ("Radius", Range(0,0.5)) = 0.5

        //处理图集偏移
        _WidthRate ("Sprite.rect.width/MainTex.width", float) = 1  
	    _HeightRate ("Sprite.rect.height/MainTex.height", float) = 1  
	    _XOffset("offsetX Sprite.rect.x/MainTex.width", float) = 0
	    _YOffset("offsetY Sprite.rect.y/MainTex.height", float) = 0
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}
		
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		Pass
		{
			Name "Default"
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ SEVEN_UI_CIRCULAR
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
			};
			
			fixed4 _Color;
			fixed4 _TextureSampleAdd;
			float4 _ClipRect;
			float _Radius;
			float _WidthRate;  
            float _HeightRate;  
            float _XOffset;   
            float _YOffset;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.worldPosition = IN.vertex;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				#ifdef UNITY_HALF_TEXEL_OFFSET
				OUT.vertex.xy += (_ScreenParams.zw-1.0) * float2(-1,1) * OUT.vertex.w;
				#endif
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			sampler2D _MainTex;
			sampler2D _AlphaTex;

			fixed4 frag(v2f i) : SV_Target
			{
				float2 uv = i.texcoord.xy;
                float4 c = i.color;
                float radius = _Radius;
                float maxuv = 1;
                 #ifdef SEVEN_UI_CIRCULAR
                 uv.x -= _XOffset;
                 uv.y -= _YOffset;
                 radius *= _WidthRate;
                 maxuv *= _WidthRate;
                 #endif

                // 左下四方块
                if(uv.x < radius && uv.y < radius)
                {
                    float2 r;
                    r.x = uv.x - radius;
                    r.y = uv.y - radius;
                    float rr = length(r);
                    // 裁剪
                    if(rr > radius)
                    {
                        c.a = 0;
                    }
                }
                // 左上四方块
                else if(uv.x < radius && uv.y > maxuv- radius)
                {
                    float2 r;
                    r.x = uv.x - radius;
                    r.y = uv.y + radius - maxuv;
                    float rr = length(r);
                    // 裁剪
                    if(rr > radius)
                    {
                        c.a = 0;
                    }   
                }
                // 右下四方块
                else if(uv.x > maxuv - radius && uv.y < radius)
                {
                    float2 r;
                    r.x = uv.x + radius - maxuv;
                    r.y = uv.y - radius;
                    float rr = length(r);
                    // 裁剪
                    if(rr > radius)
                    {
                        c.a = 0;
                    }   
                }
                // 右上四方块
                else if(uv.x > maxuv - radius && uv.y > maxuv- radius)
                {
                    float2 r;
                    r.x = uv.x + radius - maxuv;
                    r.y = uv.y + radius - maxuv;
                    float rr = length(r);
                    // 裁剪
                    if(rr > radius)
                    {
                        c.a = 0;
                    }   
                }                                   

				half4 color = (tex2D(_MainTex, i.texcoord) + _TextureSampleAdd) * i.color;
				#ifdef SEVEN_UI_CIRCULAR
				fixed4 alpha = tex2D(_AlphaTex, i.texcoord) + _TextureSampleAdd;
				color.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
				color.a = color.a * alpha.b*c.a;
				#else
				color.a = c.a;
				#endif


                return color;
			}
		ENDCG
		}
	}
}
