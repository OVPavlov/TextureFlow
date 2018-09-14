Shader "Hidden/TextureFlow/GaussianBlur"
{
	SubShader
	{




Pass // 5 pixels wide
{
ZTest Always Cull Off ZWrite Off
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 2.0
struct v2f
{
	float4 vertex : SV_POSITION;
	float2 uv: TEXCOORD0;
	half2 uv1 : TEXCOORD1;
	half2 uv2 : TEXCOORD2;
};
sampler2D _MainTex;
half2 _Pixel;
half2 _Sample0;
half2 _Sample1;
v2f vert(float4 vertex : POSITION, float2 uv : TEXCOORD0)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(vertex);
	o.uv = uv;
	o.uv1 = _Pixel * _Sample1.xxxx + uv;
	o.uv2 = -_Pixel * _Sample1.xxxx + uv;
	return o;
}
fixed4 frag(v2f i) : SV_Target
{
	fixed4 col = tex2D(_MainTex, i.uv) * _Sample0.y;
	col = (tex2D(_MainTex, i.uv1) + tex2D(_MainTex, i.uv2)) * _Sample1.y + col;
	return col;
}
ENDCG
}

Pass // 9 pixels wide
{
ZTest Always Cull Off ZWrite Off
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 2.0
struct v2f
{
	float4 vertex : SV_POSITION;
	float2 uv: TEXCOORD0;
	half2 uv1 : TEXCOORD1;
	half2 uv2 : TEXCOORD2;
	half2 uv3 : TEXCOORD3;
	half2 uv4 : TEXCOORD4;
};
sampler2D _MainTex;
half2 _Pixel;
half2 _Sample0;
half2 _Sample1;
half2 _Sample2;
v2f vert(float4 vertex : POSITION, float2 uv : TEXCOORD0)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(vertex);
	o.uv = uv;
	o.uv1 = _Pixel * _Sample1.xxxx + uv;
	o.uv2 = -_Pixel * _Sample1.xxxx + uv;
	o.uv3 = _Pixel * _Sample2.xxxx + uv;
	o.uv4 = -_Pixel * _Sample2.xxxx + uv;
	return o;
}
fixed4 frag(v2f i) : SV_Target
{
	fixed4 col = tex2D(_MainTex, i.uv) * _Sample0.y;
	col = (tex2D(_MainTex, i.uv1) + tex2D(_MainTex, i.uv2)) * _Sample1.y + col;
	col = (tex2D(_MainTex, i.uv3) + tex2D(_MainTex, i.uv4)) * _Sample2.y + col;
	return col;
}
ENDCG
}

Pass // 13 pixels wide
{
ZTest Always Cull Off ZWrite Off
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 2.0
struct v2f
{
	float4 vertex : SV_POSITION;
	float2 uv: TEXCOORD0;
	half2 uv1 : TEXCOORD1;
	half2 uv2 : TEXCOORD2;
	half2 uv3 : TEXCOORD3;
	half2 uv4 : TEXCOORD4;
	half2 uv5 : TEXCOORD5;
	half2 uv6 : TEXCOORD6;
};
sampler2D _MainTex;
half2 _Pixel;
half2 _Sample0;
half2 _Sample1;
half2 _Sample2;
half2 _Sample3;
v2f vert(float4 vertex : POSITION, float2 uv : TEXCOORD0)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(vertex);
	o.uv = uv;
	o.uv1 = _Pixel * _Sample1.xxxx + uv;
	o.uv2 = -_Pixel * _Sample1.xxxx + uv;
	o.uv3 = _Pixel * _Sample2.xxxx + uv;
	o.uv4 = -_Pixel * _Sample2.xxxx + uv;
	o.uv5 = _Pixel * _Sample3.xxxx + uv;
	o.uv6 = -_Pixel * _Sample3.xxxx + uv;
	return o;
}
fixed4 frag(v2f i) : SV_Target
{
	fixed4 col = tex2D(_MainTex, i.uv) * _Sample0.y;
	col = (tex2D(_MainTex, i.uv1) + tex2D(_MainTex, i.uv2)) * _Sample1.y + col;
	col = (tex2D(_MainTex, i.uv3) + tex2D(_MainTex, i.uv4)) * _Sample2.y + col;
	col = (tex2D(_MainTex, i.uv5) + tex2D(_MainTex, i.uv6)) * _Sample3.y + col;
	return col;
}
ENDCG
}

Pass // 17 pixels wide, compact
{
ZTest Always Cull Off ZWrite Off
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 2.0
struct v2f
{
	float4 vertex : SV_POSITION;
	float2 uv: TEXCOORD0;
	half4 uv1 : TEXCOORD1;
	half4 uv2 : TEXCOORD2;
	half4 uv3 : TEXCOORD3;
	half4 uv4 : TEXCOORD4;
};
sampler2D _MainTex;
half2 _Pixel;
half2 _Sample0;
half2 _Sample1;
half2 _Sample2;
half2 _Sample3;
half2 _Sample4;
v2f vert(float4 vertex : POSITION, float2 uv : TEXCOORD0)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(vertex);
	o.uv = uv;
	o.uv1 = half4(_Pixel, -_Pixel) * _Sample1.xxxx + uv.xyxy;
	o.uv2 = half4(_Pixel, -_Pixel) * _Sample2.xxxx + uv.xyxy;
	o.uv3 = half4(_Pixel, -_Pixel) * _Sample3.xxxx + uv.xyxy;
	o.uv4 = half4(_Pixel, -_Pixel) * _Sample4.xxxx + uv.xyxy;
	return o;
}
fixed4 frag(v2f i) : SV_Target
{
	fixed4 col = tex2D(_MainTex, i.uv) * _Sample0.y;
	col = (tex2D(_MainTex, i.uv1.xy) + tex2D(_MainTex, i.uv1.zw)) * _Sample1.y + col;
	col = (tex2D(_MainTex, i.uv2.xy) + tex2D(_MainTex, i.uv2.zw)) * _Sample2.y + col;
	col = (tex2D(_MainTex, i.uv3.xy) + tex2D(_MainTex, i.uv3.zw)) * _Sample3.y + col;
	col = (tex2D(_MainTex, i.uv4.xy) + tex2D(_MainTex, i.uv4.zw)) * _Sample4.y + col;
	return col;
}
ENDCG
}

Pass // 21 pixels wide, compact
{
ZTest Always Cull Off ZWrite Off
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 2.0
struct v2f
{
	float4 vertex : SV_POSITION;
	float2 uv: TEXCOORD0;
	half4 uv1 : TEXCOORD1;
	half4 uv2 : TEXCOORD2;
	half4 uv3 : TEXCOORD3;
	half4 uv4 : TEXCOORD4;
	half4 uv5 : TEXCOORD5;
};
sampler2D _MainTex;
half2 _Pixel;
half2 _Sample0;
half2 _Sample1;
half2 _Sample2;
half2 _Sample3;
half2 _Sample4;
half2 _Sample5;
v2f vert(float4 vertex : POSITION, float2 uv : TEXCOORD0)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(vertex);
	o.uv = uv;
	o.uv1 = half4(_Pixel, -_Pixel) * _Sample1.xxxx + uv.xyxy;
	o.uv2 = half4(_Pixel, -_Pixel) * _Sample2.xxxx + uv.xyxy;
	o.uv3 = half4(_Pixel, -_Pixel) * _Sample3.xxxx + uv.xyxy;
	o.uv4 = half4(_Pixel, -_Pixel) * _Sample4.xxxx + uv.xyxy;
	o.uv5 = half4(_Pixel, -_Pixel) * _Sample5.xxxx + uv.xyxy;
	return o;
}
fixed4 frag(v2f i) : SV_Target
{
	fixed4 col = tex2D(_MainTex, i.uv) * _Sample0.y;
	col = (tex2D(_MainTex, i.uv1.xy) + tex2D(_MainTex, i.uv1.zw)) * _Sample1.y + col;
	col = (tex2D(_MainTex, i.uv2.xy) + tex2D(_MainTex, i.uv2.zw)) * _Sample2.y + col;
	col = (tex2D(_MainTex, i.uv3.xy) + tex2D(_MainTex, i.uv3.zw)) * _Sample3.y + col;
	col = (tex2D(_MainTex, i.uv4.xy) + tex2D(_MainTex, i.uv4.zw)) * _Sample4.y + col;
	col = (tex2D(_MainTex, i.uv5.xy) + tex2D(_MainTex, i.uv5.zw)) * _Sample5.y + col;
	return col;
}
ENDCG
}

Pass // 25 pixels wide, compact
{
ZTest Always Cull Off ZWrite Off
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 2.0
struct v2f
{
	float4 vertex : SV_POSITION;
	float2 uv: TEXCOORD0;
	half4 uv1 : TEXCOORD1;
	half4 uv2 : TEXCOORD2;
	half4 uv3 : TEXCOORD3;
	half4 uv4 : TEXCOORD4;
	half4 uv5 : TEXCOORD5;
	half4 uv6 : TEXCOORD6;
};
sampler2D _MainTex;
half2 _Pixel;
half2 _Sample0;
half2 _Sample1;
half2 _Sample2;
half2 _Sample3;
half2 _Sample4;
half2 _Sample5;
half2 _Sample6;
v2f vert(float4 vertex : POSITION, float2 uv : TEXCOORD0)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(vertex);
	o.uv = uv;
	o.uv1 = half4(_Pixel, -_Pixel) * _Sample1.xxxx + uv.xyxy;
	o.uv2 = half4(_Pixel, -_Pixel) * _Sample2.xxxx + uv.xyxy;
	o.uv3 = half4(_Pixel, -_Pixel) * _Sample3.xxxx + uv.xyxy;
	o.uv4 = half4(_Pixel, -_Pixel) * _Sample4.xxxx + uv.xyxy;
	o.uv5 = half4(_Pixel, -_Pixel) * _Sample5.xxxx + uv.xyxy;
	o.uv6 = half4(_Pixel, -_Pixel) * _Sample6.xxxx + uv.xyxy;
	return o;
}
fixed4 frag(v2f i) : SV_Target
{
	fixed4 col = tex2D(_MainTex, i.uv) * _Sample0.y;
	col = (tex2D(_MainTex, i.uv1.xy) + tex2D(_MainTex, i.uv1.zw)) * _Sample1.y + col;
	col = (tex2D(_MainTex, i.uv2.xy) + tex2D(_MainTex, i.uv2.zw)) * _Sample2.y + col;
	col = (tex2D(_MainTex, i.uv3.xy) + tex2D(_MainTex, i.uv3.zw)) * _Sample3.y + col;
	col = (tex2D(_MainTex, i.uv4.xy) + tex2D(_MainTex, i.uv4.zw)) * _Sample4.y + col;
	col = (tex2D(_MainTex, i.uv5.xy) + tex2D(_MainTex, i.uv5.zw)) * _Sample5.y + col;
	col = (tex2D(_MainTex, i.uv6.xy) + tex2D(_MainTex, i.uv6.zw)) * _Sample6.y + col;
	return col;
}
ENDCG
}
	}
}
