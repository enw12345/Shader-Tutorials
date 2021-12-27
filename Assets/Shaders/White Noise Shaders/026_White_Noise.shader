Shader "Tutorial/026_White_Noise"
{
	Properties{
		_Color("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Texture", 2D) = "white" {}
		_Smoothness("Smoothness", Range(0,1)) = 0
		_Metallic("Metalness", Range(0,1)) = 0
		[HDR]_Emission("Emission", Color) = (0,0,0,1)
	}
		SubShader{
			Tags{ "RenderType" = "Opaque" "Queue" = "Geometry"}

			CGPROGRAM
			#pragma surface surf Standard fullforwardshadows
			#pragma target 3.0
			#include "Assets/Shaders/Random.cginc"

			struct Input {
			float3 worldPos;
			};

			sampler2D _MainTex;
			fixed4 _Color;
			half _Smoothness;
			half _Metallic;
			half3 _Emission;

			void surf(Input i, inout SurfaceOutputStandard o) {
				float3 value = i.worldPos;
				o.Albedo = rand3dTo3d(value);
				o.Metallic = _Metallic;
				o.Smoothness = _Smoothness;
				o.Emission = _Emission;
			}
			ENDCG
		}
			FallBack "Standard"
}
