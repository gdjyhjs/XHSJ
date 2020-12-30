// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)
// 场景shader
Shader "Legacy Shaders/Transparent/Cutout/Diffuse(rgb and a)" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_AlphaTex ("Base (RGB)", 2D) = "white" {}
	_Cutoff ("Alpha cutoff", Range(0,1.0)) = 0.1
}

SubShader {
	Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	LOD 200
	
CGPROGRAM
#pragma surface surf Lambert alphatest:_Cutoff
sampler2D _MainTex;
sampler2D _AlphaTex;
fixed4 _Color;

struct Input {
	float2 uv_MainTex;
	float2 uv_AlphaTex;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	fixed4 alpha = tex2D(_AlphaTex, IN.uv_AlphaTex) * _Color;
	o.Albedo = c.rgb;
	o.Alpha = (alpha.r+alpha.g+alpha.b);
}
ENDCG
}

Fallback "Legacy Shaders/Transparent/Cutout/VertexLit"
}
