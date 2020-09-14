Shader "Tutorial/010_Triplanar_Mapping"
{
	Properties
	{
		_Color("Tint", Color) = (0,0,0,1)
		_MainTex("Texture", 2D) = "white" {}
		_Sharpness("Blend Sharpneess", Range(1, 64)) = 1
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 position : SV_POSITION;
				float3 worldPos : TEXCOORD0;
				float3 normal : NORMAL;
			};

			//texture and transforms of the texture
			sampler2D _MainTex;
			float4 _MainTex_ST;

			float4 _Color;
			float _Sharpness;

			v2f vert(appdata v)
			{
				v2f o;
				//calculate the position in clip space to render the object
				o.position = UnityObjectToClipPos(v.vertex);
				//calculate world position of the vertex
				float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldPos = worldPos.xyz;
				//calculate world noraml
				float3 worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
				o.normal = normalize(worldNormal);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//calculate UV coordinates for the three projections
				float2 uv_front = TRANSFORM_TEX(i.worldPos.xy, _MainTex);
				float2 uv_side = TRANSFORM_TEX(i.worldPos.zy, _MainTex);
				float2 uv_top = TRANSFORM_TEX(i.worldPos.xz, _MainTex);

				//generate weights from world normals
				float3 weights = i.normal;
				//show texture for both sides of the object
				weights = abs(weights);
				//make transition sharper
				weights = pow(weights, _Sharpness);
				//make it so the sum of all components is 1
				weights = weights / (weights.x + weights.y + weights.z);

				//read texture at uv position of the three projections
				fixed4 col_front = tex2D(_MainTex, uv_front);
				fixed4 col_side = tex2D(_MainTex, uv_side);
				fixed4 col_top = tex2D(_MainTex, uv_top);

				//combine the weights with the projected colors
				col_front *= weights.z;
				col_side *= weights.x;
				col_top *= weights.y;

				//combine the projected colors
				fixed4 col = col_front + col_side + col_top;

				//multiply texture color with tint color
				col *= _Color;
				return col;
		}
	ENDCG
	}
	}

		Fallback "Standard" //fallback adds shadow pass
}
