Shader "Tutorial/018_Postprocessing_Normals"
{
	//show values to edit in inspector
	Properties{
		[HideInInspector] _MainTex("Texture", 2D) = "white" {}
	_upCutoff("Up Cutoff", Range(9,1)) = 0.7
		_topColor("top color", Color) = (1,1,1,1)
	}

		SubShader{
		// markers that specify that we don't need culling
		// or reading/writing to the depth buffer
		Cull Off
		ZWrite Off
		ZTest Always

		Pass{
			CGPROGRAM
			//include useful shader functions
			#include "UnityCG.cginc"

			//define vertex and fragment shader
			#pragma vertex vert
			#pragma fragment frag

			//texture and transforms of the texture
			sampler2D _MainTex;
	sampler2D _CameraDepthNormalsTexture;
	float4x4 _viewToWorld;

	//effect customization
	float _upCutoff;
	float4 _topColor;

	//the object data that's put into the vertex shader
	struct appdata {
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	//the data that's used to generate fragments and can be read by the fragment shader
	struct v2f {
		float4 position : SV_POSITION;
		float2 uv : TEXCOORD0;
	};

	//the vertex shader
	v2f vert(appdata v) {
		v2f o;
		//convert the vertex positions from object space to clip space so they can be rendered
		o.position = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;
		return o;
	}

	//the fragment shader
	fixed4 frag(v2f i) : SV_TARGET{
		//read depthnormal
		float4 depthnormal = tex2D(_CameraDepthNormalsTexture, i.uv);

		//decode depthnormal
		float3 normal;
		float depth;
		DecodeDepthNormal(depthnormal, depth, normal);

		//get depth as distance from camera units
		depth = depth * _ProjectionParams.z;

		normal = normal = mul((float3x3)_viewToWorld, normal);

		//color the top
		float up = dot(float3(0, 1,0), normal);
		up = step(_upCutoff, up);
		float4 source = tex2D(_MainTex, i.uv);
		float4 col = lerp(source, _topColor, up * _topColor.a);
		return col;
		//return float4(normal, 1);

	}

	ENDCG
}
	}
}
