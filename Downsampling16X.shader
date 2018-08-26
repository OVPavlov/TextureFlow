Shader "Hidden/TextureFlow/Downsampling16X"
{ 
	Properties
	{
		_MainTex  ("_MainTexA", 2D) = "white" {}
		_SrcBlend ("SrcBlend", Int) = 5.0 // SrcAlpha
		_DstBlend ("DstBlend", Int) = 10.0 // OneMinusSrcAlpha
		_SrcBlendAlpha ("SrcBlendAlpha", Int) = 5.0 // SrcAlpha
		_DstBlendAlpha ("DstBlendAlpha", Int) = 10.0 // OneMinusSrcAlpha
		_BlendOpColor ("BlendOpColor", Int) = 0.0 // Add
		_BlendOpAlpha ("BlendOpAlpha", Int) = 0.0 // Add
	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }

		Pass // 1 16x
		{
			Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
			BlendOp [_BlendOpColor], [_BlendOpAlpha]
			Cull Back ZWrite Off ZTest Always

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#include "UnityCG.cginc"
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float2 uv2 : TEXCOORD2;
				float2 uv3 : TEXCOORD3;
			};

			float2 _PixelOffset;

			v2f vert (float4 vertex : POSITION, float2 uv : TEXCOORD0)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(vertex);
				o.uv0 = uv + float2(-_PixelOffset.x, -_PixelOffset.y);
				o.uv1 = uv + float2(-_PixelOffset.x,  _PixelOffset.y);
				o.uv2 = uv + float2( _PixelOffset.x, -_PixelOffset.y);
				o.uv3 = uv + float2( _PixelOffset.x,  _PixelOffset.y);
				return o;
			}			

			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				return (tex2D(_MainTex, i.uv0) + tex2D(_MainTex, i.uv1) + tex2D(_MainTex, i.uv2) + tex2D(_MainTex, i.uv3)) * 0.25f;
			}
			ENDCG  
		}
	}
}
