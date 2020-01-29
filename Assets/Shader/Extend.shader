// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TextureTilling"
{
    Properties
    {
        _Color ("Diffuse Color", Color) = (1, 1, 1, 1)
        _MainTex ("Base layer (RGB)", 2D) = "white" { }
    }
    SubShader
    {
        
        Tags { "Queue" = "Transparent" "LightMode" = "ForwardBase" }
        
        Blend SrcAlpha OneMinusSrcAlpha
        Lighting On
        ZWrite On
        
        Pass
        {
            //pass1
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            //Macro Define in UnityCG.cginc
            //#define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw)
            // For Tiling and Offset used in // TRANSFORM_TEX(v.texcoord.xy, _MainTex); 
            // same as //i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
            float4 _MainTex_ST;
            float4 _Color;
            sampler2D _MainTex;
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                fixed4 color: COLOR;
                float2 uv: TEXCOORD0;
                float3 extend: TEXCOORD1;
            };
            
            v2f vert(appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord.xy, _MainTex); //Tiling and Offset
                
                float4 centerPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)); // Position
                float4 cornerPos = mul(unity_ObjectToWorld, float4(1, 1, 1, 1)); // Scale
                o.uv *= (cornerPos - centerPos).xz;

                return o;
            }
            
            fixed4 frag(v2f i): COLOR
            {
                return tex2D(_MainTex, i.uv) * _Color;
            }
            
            ENDCG
            
        }//pass 1
    }//subshader
}//shader
