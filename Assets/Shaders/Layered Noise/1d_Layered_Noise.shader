Shader "Tutorial/029_Layered_Noise/1d_Layered_Noise"
{
    Properties
    {
        _CellSize("Cell Size", Range(0,2)) = 1
        _Roughness("Roughness", Range(1,8)) = 3
        _Persistance("Persistance", Range(0,1)) = 0.4
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        //gloabl shader variables
        #define OCTAVES 4

        #include "Assets/Shaders/Random.cginc"
        float _CellSize;
        float _Roughness;
        float _Persistance;

        struct Input
        {
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

        float sampleLayeredNoise(float value) {
            float noise = 0;
            float frequency = 1;
            float factor = 1;

            [unroll]
            for (int i = 0; i < OCTAVES; i++) {
                noise = noise + gradientNoise(value * frequency + i * 0.72354) * factor;
                factor *= _Persistance;
                frequency *= _Roughness;
            }

            return noise;
        }

        void surf (Input i, inout SurfaceOutputStandard o)
        {
            float value = i.worldPos.x / _CellSize;
            float noise = sampleLayeredNoise(value);

            float dist = abs(noise - i.worldPos.y);
            float pixelHeight = fwidth(i.worldPos.y);
            float lineIntensity = smoothstep(2 * pixelHeight, pixelHeight, dist);
            o.Albedo = lerp(1, 0, lineIntensity);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
