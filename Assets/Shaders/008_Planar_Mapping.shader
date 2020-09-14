Shader "Tutorial/008_Triplanar_Mapping"
{
	Properties
	{
		_Color("Tint", Color) = (0,0,0,1)
		_MainTex("Texture", 2D) = "white" {}
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
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 position : SV_POSITION;
			};

			//texture and transforms of the texture
			sampler2D _MainTex;
			float4 _MainTex_ST;

			float4 _Color;

			v2f vert(appdata v)
			{
				v2f o;
				//calculate the position in clip space to render the object
				o.position = UnityObjectToClipPos(v.vertex);
				//calculate world position of the vertex
				float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
				//change UVs based on tiling and offset
				o.uv = TRANSFORM_TEX(worldPos.xz, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//read texture at uv position
				fixed4 col = tex2D(_MainTex, i.uv);
				//multiply texture color with tint color
				col *= _Color;
				return col;
			}
		ENDCG
		}
	}

		Fallback "Standard" //fallback adds shadow pass
}
