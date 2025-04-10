Shader "Custom/Vignette"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;

            struct VertexData
            {
              float4 vertex : POSITION;
              float2 uv : TEXCOORD0;
            };

            struct v2f
            {
              float2 uv : TEXCOORD0;
              float4 vertex : SV_POSITION;
            };

            v2f vert (VertexData v)
            {
              v2f o;
              o.vertex = UnityObjectToClipPos(v.vertex);
              o.uv = o.uv;
              return o;
            }

            float4 frag (v2f i) : SV_Target
            {
              return float4(1,1,1,1);
            }
            ENDCG
        }
    }
}
