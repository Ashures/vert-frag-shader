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
            float3 _VignetteColor;
            float _VignetteIntensity, _VignetteSmoothness, _VignetteRoundness;
            float2 _VignetteSize;

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
              o.uv = v.uv;
              return o;
            }

            float4 frag (v2f i) : SV_Target
            {
              float4 col = tex2D(_MainTex, i.uv);

              float2 pos = i.uv - 0.5;
              pos *= _VignetteSize;
              pos += 0.5;

              float2 d = abs(pos - float2(0.5, 0.5)) * _VignetteIntensity;
              d = pow(saturate(d), _VignetteRoundness);

              float t = pow(saturate(1.0 - dot(d, d)), _VignetteSmoothness);

              return float4(lerp(_VignetteColor, col.rgb, t), 1.0);
            }
            ENDCG
        }
    }
}
