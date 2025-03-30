Shader "Unlit/TestShader"
{
    Properties
    {
        _ColorA ("ColorA", Color) = (0, 0, 0, 1)
        _ColorB ("ColorB", Color) = (0, 0, 0, 1)
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

            float4 _ColorA;
            float4 _ColorB;
            float _GameTime;

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float height : TEXCOORD0;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                float height = sin((length(v.uv - float2(0.5, 0.5)) * 2 * 3.14159) * 5 + _Time.y) / 2 + 1;
                o.vertex = UnityObjectToClipPos(float4(v.vertex.x, height, v.vertex.zw));
                o.height = height;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                return lerp(_ColorA, _ColorB, i.height);
            }
            ENDCG
        }
    }
}
