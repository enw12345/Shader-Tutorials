Shader "Tutorial/014_Polygon_Clipping"
{
	Properties
	{
		_Color ("Color", Color) = (0,0,0,1)
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

			//the variables for the corners
			uniform float2 _corners[1000];
			uniform uint _cornerCount;

			fixed4 _Color;

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
				o.position = UnityObjectToClipPos(v.vertex);
				float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldPos = worldPos.xyz;
				return o;
			}

			//return 1 if a thing is left of the line, 0 if not
			float isLeftOfLine(float2 pos, float2 linePoint1, float2 linePoint2) {
				//variables we need for our calculations
				float2 lineDirection = linePoint2 - linePoint1;
				float2 lineNormal = float2(-lineDirection.y, lineDirection.x);
				float2 toPos = pos - linePoint1;

				//which side the tested position is on
				float side = dot(toPos, lineNormal);
				side = step(0, side);
				return side;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float outsideTriangle = 0;

				[loop]
				for (uint index; index < _cornerCount; index++) {
					outsideTriangle += isLeftOfLine(i.worldPos.xy, _corners[index], _corners[(index + 1) % _cornerCount]);
				}

				clip(-outsideTriangle);
				return _Color;
			}
		ENDCG
	}
	}
}
