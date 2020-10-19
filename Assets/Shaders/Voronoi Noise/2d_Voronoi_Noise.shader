Shader "Tutorial/030_voronoi_noise/2d_Voronoi_Noise"
{
	Properties{
		 _CellSize("Cell Size", Range(0, 2)) = 2
	}
		SubShader{
			Tags{ "RenderType" = "Opaque" "Queue" = "Geometry"}

			CGPROGRAM

			#pragma surface surf Standard fullforwardshadows
			#pragma target 3.0

			#include "Assets/Shaders/Random.cginc"

			float _CellSize;

			struct Input {
				float3 worldPos;
			};

			float voronoiNoise(float2 value) {
				//floor the cells
				float2 baseCell = floor(value);

				float minDistToCell = 10;
				[unroll]
				for (int x = -1; x <= 1; x++) {
					[unroll]
					for (int y = -1; y <= 1; y++) {
						float2 cell = baseCell + float2(x, y);
						float2 cellPosition = cell + rand2dTo2d(cell);
						float2 toCell = cellPosition - value;
						float distToCell = length(toCell);
						if (distToCell < minDistToCell) {
							minDistToCell = distToCell;
						}
					}
				}
				return minDistToCell;
			}

			void surf(Input i, inout SurfaceOutputStandard o) {
				//divide the space into cells
				float2 value = i.worldPos.xz / _CellSize;
				//float2 value = _Time / _CellSize;
				float noise = voronoiNoise(value);

				o.Albedo = noise;
			}
			ENDCG
	}
		FallBack "Standard"
}
