Shader "Tutorial/009_Color_Blending/Plain"
{
    //show values to edit in inspector
    Properties{
      _Color("Color", Color) = (0, 0, 0, 1) //the base color
      _SecondaryColor("Secondary Color", Color) = (1,1,1,1) //the color to blend to
      _Blend("Blend Value", Range(0,1)) = 0//0 is the first color, 1 is the second
    }

        SubShader{
        //the material is completely non-transparent and is rendered at the same time as the other opaque geometry
        Tags{ "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass{
          CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
          //The value that's being used to blend between the colors
          float _Blend;
          
          //The colors to blend between
          fixed4 _Color;
          fixed4 _SecondaryColor;

          //the mesh data thats read by the vertex shader
          struct appdata {
            float4 vertex : POSITION;
          };

          //the data thats passed from the vertex to the fragment shader and interpolated by the rasterizer
          struct v2f {
            float4 position : SV_POSITION;
          };

          v2f vert(appdata v){
           v2f o;
          //convert the vertex positions from object space to clip space so they can be rendered correctly
          o.position = UnityObjectToClipPos(v.vertex);
          return o;
          }

          ///the fragment shader
          fixed4 frag(v2f i) : SV_TARGET{
              fixed4 col = _Color * (1 - _Blend) + _SecondaryColor * _Blend;
          return col;
          }

          ENDCG
        }
    }
        Fallback "VertexLit"
}
