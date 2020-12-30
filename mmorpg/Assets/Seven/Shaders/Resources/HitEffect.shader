Shader "Seven/HitEffect" {
	Properties {  
        _Color ("Main Color", Color) = (1,1,1,1)  
	    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}  
	    _Alpha("Alpha", Range (0.01,1.0)) = 0.5  
	}  
	SubShader {  
	    Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }  
	    LOD 200  
	     Pass {  
	    ZWrite Off  
	    ColorMask 0  
	}  
	  
	    CGPROGRAM  
	    #pragma surface surf Lambert alpha  
	  
	    sampler2D _MainTex;  
	    float _Alpha;  
	    fixed4 _Color;  
	  
	    struct Input {  
	        float2 uv_MainTex;  
	    };  
	  
	    void surf (Input IN, inout SurfaceOutput o) {  
	        half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;  
	        o.Emission = c.rgb;  
	        o.Alpha = _Alpha;  
	    }  
	    ENDCG  
	}   
	FallBack "Diffuse"
}

