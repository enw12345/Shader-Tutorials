﻿Shader "Tutorial/028_Perlin_Noise/1d_Perlin_Noise"
{
	Properties{
		 _CellSize("Cell Size", Range(0, 1)) = 1
	}
		SubShader{
			Tags{ "RenderType" = "Opaque" "Queue" = "Geometry"}

			CGPROGRAM

			#pragma surface surf Standard fullforwardshadows
			#pragma target 3.0

			#include"Assets/Shaders/Random.cginc"

			float _CellSize;

			struct Input {
				float3 worldPos;
			};

			float easeIn(float interpolator) {
				return interpolator * interpolator * interpolator * interpolator * interpolator;
			}

			float easeOut(float interpolator) {
				return 1 - easeIn(1 - interpolator);
			}

			float easeInOut(float interpolator) {
				float easeInValue = easeIn(interpolator);
				float easeOutValue = easeOut(interpolator);
				return lerp(easeInValue, easeOutValue, interpolator);
			}

			float gradientNoise(float value) {
				float fraction = frac(value);
				float interpolator = easeInOut(fraction);

				float previousCellInclination = rand1dTo1d(floor(value)) * 2 - 1;
				float previousCellLinePoint = previousCellInclination * fraction;

				float nextCellInclination = rand1dTo1d(ceil(value)) * 2 - 1;
				float nextCellLinePoint = nextCellInclination * (fraction - 1);

				return lerp(previousCellLinePoint, nextCellLinePoint, interpolator);
			}

			void surf(Input i, inout SurfaceOutputStandard o) {
				float value = i.worldPos.x / _CellSize;
				float noise = gradientNoise(value);

				float dist = abs(noise - i.worldPos.y);
				float pixelHeight = fwidth(i.worldPos.y);
				float lineIntensity = smoothstep(2 * pixelHeight, pixelHeight, dist);
				o.Albedo = lerp(1, 0, lineIntensity);
			}
			ENDCG
	}
		FallBack "Standard"
}
