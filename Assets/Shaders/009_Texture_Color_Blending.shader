Shader "Tutorial/009_Texture_Color_Blending"
{
	//show values to edit in inspector
	Properties{
	 _MainTex("_Texture", 2D) = "white"{}
	_SecondaryTex("Secondary Texture", 2D) = "black"{}
	_Blend("Blend Value", Range(0,1)) = 0
	}

		SubShader{
		//the material is completely non-transparent and is rendered at the same time as the other opaque geometry
		Tags{ "RenderType" = "Opaque" "Queue" = "Geometry" }

		Pass{
		  CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
#include "UnityCG.cginc"
		  //The value that's being used to blend between the colors
		  float _Blend;

	//The textures to blend between
sampler2D _MainTex;
float4 _MainTex_ST;

sampler2D _SecondaryTex;
float4 _SecondaryTex_ST;

//the mesh data thats read by the vertex shader
struct appdata {
  float4 vertex : POSITION;
  float2 uv : TEXCOORD0;
};

//the data thats passed from the vertex to the fragment shader and interpolated by the rasterizer
struct v2f {
  float4 position : SV_POSITION;
  float2 uv : TEXCOORD0;
};

v2f vert(appdata v) {
 v2f o;
 //convert the vertex positions from object space to clip space so they can be rendered correctly
 o.position = UnityObjectToClipPos(v.vertex);
 o.uv = v.uv;
 return o;
 }

///the fragment shader
fixed4 frag(v2f i) : SV_TARGET{
	//calculate UV coordinates including tiling and offset
	float2 main_uv = TRANSFORM_TEX(i.uv, _MainTex);
	float2 secondary_uv = TRANSFORM_TEX(i.uv, _SecondaryTex);

	//read colors from textures
	fixed4 main_color = tex2D(_MainTex, main_uv);
	fixed4 secondary_color = tex2D(_SecondaryTex, secondary_uv);

	//interpolate between the colors
	fixed4 col = lerp(main_color, secondary_color, _Blend);
	return col;
}

ENDCG
}
	}
		Fallback "VertexLit"
}
