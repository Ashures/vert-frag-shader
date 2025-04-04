Shader "Custom/Diffuse"
{
    Properties
    {
      _Albedo ("Albedo", Color) = (1,1,1,1)
      _Smoothness ("Smoothness", Range(0.01, 1)) = 0.5
      _Warm ("Warm", Color) = (1,1,1,1)
      _Cold ("Cold", Color) = (1,1,1,1)
      _Alpha ("Alpha", Range(0.01, 1)) = 0.5
      _Beta ("Beta", Range(0.01, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityPBSLighting.cginc"

            float4 _Albedo;
            float _Smoothness;
            float4 _Warm;
            float4 _Cold;
            float _Alpha;
            float _Beta;

            struct appdata
            {
              float4 vertex : POSITION;
              float3 normal : NORMAL;
            };

            struct v2f
            {
              float4 vertex : SV_POSITION;
              float3 normal : TEXCOORD0;
              float3 worldPos : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
              v2f o;
              o.vertex = UnityObjectToClipPos(v.vertex);
              o.worldPos = mul(unity_ObjectToWorld, v.vertex);
              o.normal = UnityObjectToWorldNormal(v.normal);
              return o;
            }

            float4 frag (v2f i) : SV_Target
            {
              i.normal = normalize(i.normal);
              float3 lightDir = normalize(float3(1,1,0));
              float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
              
              float3 reflectDir = reflect(-lightDir, i.normal);
              float3 specular = DotClamped(viewDir, reflectDir);
              specular = pow(specular, _Smoothness * 500);

              float diffuse = (1.0 + dot(lightDir, i.normal)) / 2.0;

              float3 kWarm = _Warm.rgb + _Alpha * _Albedo.rgb;
              float3 kCool = _Cold.rgb + _Beta * _Albedo.rgb;

              float3 gooch = (diffuse * kWarm) + ((1 - diffuse) * kCool);
              return float4(gooch + specular, 1.0);
            }
            ENDCG
        }
    }
}
