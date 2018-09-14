

#define REPEAT(num) REPEAT_ ## num
#define REPEAT_1(stuff) stuff(1, 1, 2) 
#define REPEAT_2(stuff) stuff(1, 1, 2) stuff(2, 3, 4) 
#define REPEAT_3(stuff) stuff(1, 1, 2) stuff(2, 3, 4) stuff(3, 5, 6)
#define REPEAT_4(stuff) stuff(1, 1, 2) stuff(2, 3, 4) stuff(3, 5, 6) stuff(4, 7, 8)
#define REPEAT_5(stuff) stuff(1, 1, 2) stuff(2, 3, 4) stuff(3, 5, 6) stuff(4, 7, 8) stuff(5, 9, 10)
#define REPEAT_6(stuff) stuff(1, 1, 2) stuff(2, 3, 4) stuff(3, 5, 6) stuff(4, 7, 8) stuff(5, 9, 10) stuff(6, 11, 12)
#define REPEAT_7(stuff) stuff(1, 1, 2) stuff(2, 3, 4) stuff(3, 5, 6) stuff(4, 7, 8) stuff(5, 9, 10) stuff(6, 11, 12) stuff(7, 13, 14)
#define REPEAT_8(stuff) stuff(1, 1, 2) stuff(2, 3, 4) stuff(3, 5, 6) stuff(4, 7, 8) stuff(5, 9, 10) stuff(6, 11, 12) stuff(7, 13, 14) stuff(8, 15, 16)
#define REPEAT_9(stuff) stuff(1, 1, 2) stuff(2, 3, 4) stuff(3, 5, 6) stuff(4, 7, 8) stuff(5, 9, 10) stuff(6, 11, 12) stuff(7, 13, 14) stuff(8, 15, 16) stuff(9, 17, 18)

#define CAT(a, b) a ## b


#define PARAM(n, d0, d1) half2 _Sample##n##;
#if COMPACT				
	#define VAR_UV(n, d0, d1) half4 uv##n : TEXCOORD##n;	
	#define SET_UV(n, d0, d1) o.uv##n = half4(_Pixel, -_Pixel) * _Sample##n##.xxxx + uv.xyxy;
	#define SAMPLE(n, d0, d1) col = (tex2D(_MainTex, i.uv##n##.xy) + tex2D(_MainTex, i.uv##n##.zw)) * _Sample##n##.y + col;
#else
	#define VAR_UV(n, d0, d1) half2 uv##d0 : TEXCOORD##d0; half2 uv##d1 : TEXCOORD##d1;		
	#define SET_UV(n, d0, d1) o.uv##d0 = _Pixel * _Sample##n##.xx + uv.xy; o.uv##d1 = -_Pixel * _Sample##n##.xx + uv.xy;
	#define SAMPLE(n, d0, d1) col = (tex2D(_MainTex, i.uv##d0##) + tex2D(_MainTex, i.uv##d1##)) * _Sample##n##.y + col;
#endif




struct v2f
{				
	float4 vertex : SV_POSITION;
	half2 uv0 : TEXCOORD0;
	REPEAT(SAMPLE_COUNT)(VAR_UV)
};

half2 _Pixel;
half2 _Sample0;
REPEAT(SAMPLE_COUNT)(PARAM)

sampler2D _MainTex;
float4 _MainTex_ST;

v2f vert (float4 vertex : POSITION)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(vertex);
	half2 uv = o.vertex.xy;
	o.uv0 = uv;
	REPEAT(SAMPLE_COUNT)(SET_UV)
	return o;
}

fixed4 frag (v2f i) : SV_Target
{
	fixed4 col = tex2D(_MainTex, i.uv0) * _Sample0.y;
	REPEAT(SAMPLE_COUNT)(SAMPLE)
	return col;
}
