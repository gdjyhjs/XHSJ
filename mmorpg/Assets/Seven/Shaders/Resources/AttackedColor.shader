Shader "Seven/AttackedColor" {
	 Properties {  
        _MainTex ("Base (RGB)", 2D) = "white" {}  
        _FlashColor ("Flash Color", Color) = (1,1,1,1)  
    }  
    SubShader  
    {  
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }  
      
        CGPROGRAM  
        #pragma surface surf Lambert alpha exclude_path:prepass noforwardadd  
  
        sampler2D _MainTex;  
        float4 _FlashColor;  
              
        struct Input   
        {  
            half2 uv_MainTex;  
        };  
             
        void surf (Input IN, inout SurfaceOutput o)  
        {                  
            half4 texCol = tex2D(_MainTex, IN.uv_MainTex);            
            o.Albedo = texCol.rgb + _FlashColor.rgb;  
            o.Alpha = texCol.a;  
        }  
          
        ENDCG       
    }  
      
    FallBack "Unlit/Transparent"  
}

