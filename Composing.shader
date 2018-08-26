Shader "Hidden/TextureFlow/Composing"
{ 
	Properties
	{
		_MainTex ("_MainTexA", 2D) = "white" {}
		_MainTexB ("_MainTexB", 2D) = "white" {}
		_Color 	("ColorA", Color) = (0,0,0,0)
		_ColorB ("ColorB", Color) = (0,0,0,0)
		_ColorC ("ColorC", Color) = (0,0,0,0)
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

		CGINCLUDE
			#include "UnityCG.cginc"
			
			struct appdata_t 
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			struct v2f 
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			sampler2D _MainTexB;
			half4 _Color;
			half4 _ColorB;
			half4 _ColorC;

		ENDCG


		Pass // 0 write
		{
			Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
			BlendOp [_BlendOpColor], [_BlendOpAlpha]
			Cull Back ZWrite Off ZTest Always

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0

			fixed4 frag (v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}
			ENDCG  
		}

		Pass // 1 madd
		{
			Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
			BlendOp [_BlendOpColor], [_BlendOpAlpha]
			Cull Back ZWrite Off ZTest Always

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0

			fixed4 frag (v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv) * _Color + _ColorB;
			}
			ENDCG  
		} 

		Pass // 2 madd madd
		{
			Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
			BlendOp [_BlendOpColor], [_BlendOpAlpha]
			Cull Back ZWrite Off ZTest Always

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0

			fixed4 frag (v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv) * _Color + tex2D(_MainTexB, i.uv) * _ColorB + _ColorC;
			}
			ENDCG  
		} 
	}
}
