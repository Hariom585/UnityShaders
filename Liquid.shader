Shader "Unlit/Liquid"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color01 ("Color 1", Color) = (1,0,0,1)
        _Color02 ("Color 2", Color) = (0,1,0,1)
        _FillAmount ("Fill Amount", Range(0,1)) = 0.5

    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        
        ZWrite Off
        Lighting Off
        Fog { Mode Off }

        Blend SrcAlpha OneMinusSrcAlpha 
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color01;
            float4 _Color02;
            float _FillAmount;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 result = lerp(_Color01, _Color02, step(_FillAmount, i.uv.y)); // green from 0.33 to 0.67
                return result;
            }
            ENDCG
        }
    }
}
