// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "Qtz/Unity/Mobile/Mobile-Diffuse-Vertex-Color" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	//_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 150
	ZWrite On 
	Blend SrcAlpha OneMinusSrcAlpha

CGPROGRAM
//#pragma surface surf Lambert noforwardadd
#pragma surface surf Lambert noforwardadd keepalpha

sampler2D _MainTex;

struct Input {
	float2 uv_MainTex;
	float4 vertexColor : COLOR;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * IN.vertexColor;
	o.Albedo = c.rgb;
	o.Alpha = c.a;
}
ENDCG
}

Fallback "Qtz/Unity/Mobile/Mobile-VertexLit"
}
