Shader "Custom/MyFirstShader"
{
    Properties
    {
        _ColorPrimary ("Primary Color", Color) = (1,1,1,1)
        _ColorSecondary ("Secondary Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _ColorPrimary;
        fixed4 _ColorSecondary;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _ColorPrimary;
    
            float deltaTime = 1.0;
            float currPos = (_Time.y % deltaTime) / deltaTime;
            float straightLine = abs(IN.worldPos.y + 0.5);
            float transitionThreshold = 0.02;
            
            if ((int) (_Time.y / deltaTime) % 2 == 0)
            {
            // transisi ke bawah
                if (straightLine > 1.0 - currPos)
                {
                    o.Albedo = fixed3(0.0, 1.0, 0.0); // cube bagian atas = hijau
                }
                else if (abs(straightLine - (1.0 - currPos)) < transitionThreshold)
                {
                    o.Albedo = fixed3(1.0, 1.0, 1.0); // warna putih untuk garis pemisah
                }
                else
                {
                    o.Albedo = fixed3(1.0, 1.0, 0.0); // // cube bagian bawah = merah
                }
            }
    
            else
            {
            // transisi ke atas
                if (straightLine > currPos)
                {
                    o.Albedo = fixed3(1.0, 0.0, 0.0); // cube bagian atas = merah
                }
                else if (abs(straightLine - currPos) < transitionThreshold)
                {
                    o.Albedo = fixed3(1.0, 1.0, 1.0); // warna putih untuk garis pemisah
                }
                else
                {
                    o.Albedo = fixed3(0.0, 0.0, 0.0); // cube bagian bawah = hitam
                }
            }
    
            
            // Albedo comes from a texture tinted by color

        
            // float3 newPosition = IN.worldPos + float3(0.5, 0.5, 0.5);
            // o.Albedo = fixed3(newPosition);

    
            // o.Albedo = fixed4(IN.uv_MainTex.xy, 0.0, 1.0);
            // o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
