Shader "Tutorial/011_Checkarboard_Stripes"
{
	Properties
	{
		_Scale("Pattern Size", Range(0,10)) = 1
		_EvenColor("Color 1", Color) = (0,0,0,1)
		_OddColor("Color 2", Color) = (1,1,1,1)
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float _Scale;
			float4 _EvenColor;
			float4 _OddColor;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 position : SV_POSITION;
				float3 worldPos : TEXCOORD0;

			};

			v2f vert(appdata v)
			{
				v2f o;
				//calculate the position in clip space
				o.position = UnityObjectToClipPos(v.vertex);
				//calculate the posiiton of the vertex in the world
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//scale the position to adjust for shader input and floor the values so we have whole numbers
				float3 adjustedWorldPos = floor(i.worldPos / _Scale);
				//add different dimensions
				float chessboard = adjustedWorldPos.x + adjustedWorldPos.y + adjustedWorldPos.z;
				//divide it by 2 and get the fractional part, resulting in a value of 0 for even and 0.5 for odd numbers.
				chessboard = frac(chessboard * 0.5);
				//multiply it by 2 to make odd values white instead of gray
				chessboard *= 2;

				//interpolate between color for even fields(0) and color for odd fields(1)
				float4 color = lerp(_EvenColor, _OddColor, chessboard);
				return color;
				}
				ENDCG
			}
	}
}
