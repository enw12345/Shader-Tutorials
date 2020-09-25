Shader "Tutorial/026_White_Noise_Cells"
{
	Properties{
		_CellSize("Cell Size", Vector) = (1,1,1,0)
	}
		SubShader{
			Tags{ "RenderType" = "Opaque" "Queue" = "Geometry"}

			CGPROGRAM
			#pragma surface surf Standard fullforwardshadows
			#pragma target 3.0
			#include "Assets/Shaders/Random.cginc"

			float3 _CellSize;

			struct Input {
			float3 worldPos;
			};

			void surf(Input i, inout SurfaceOutputStandard o) {
				float3 value = floor(i.worldPos / _CellSize);
				o.Albedo = rand3dTo3d(value);
			}
			ENDCG
		 }
			 FallBack "Standard"
}
