using UnityEngine;

namespace TextureFlow
{
    static class GaussianBlur
    {
        public static string GenerateShader(int steps, bool compact)
        {
            steps++;

            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.AppendFormat("Pass // {0} pixels wide{1}", steps * 4 - 3, compact ? ", compact" : "");
            sb.Append(@"
{
ZTest Always Cull Off ZWrite Off
CGPROGRAM			
#pragma vertex vert
#pragma fragment frag
#pragma target 2.0
");

            sb.Append("struct v2f \n{\n\tfloat4 vertex : SV_POSITION;\n\tfloat2 uv: TEXCOORD0;\n");
            for (int s = 1; s < steps; s++)
            {
                if (compact)                
                    sb.AppendFormat("\thalf4 uv{0} : TEXCOORD{0};\n", s);                
                else
                {
                    int doubleS = (s << 1) - 1;
                    sb.AppendFormat("\thalf2 uv{0} : TEXCOORD{0}; \n\thalf2 uv{1} : TEXCOORD{1};\n", doubleS, doubleS + 1);
                }
            }
            sb.Append("};\n");
            sb.Append("sampler2D _MainTex;\n");
            sb.Append("half2 _Pixel;\n");
            for (int s = 0; s < steps; s++)            
                sb.AppendFormat("half2 _Sample{0};\n", s);            

            sb.Append(@"v2f vert (float4 vertex : POSITION, float2 uv : TEXCOORD0)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(vertex);
    half2 uv = vertex.xy;
    o.uv = uv;
");

            for (int s = 1; s < steps; s++)
            {
                int doubleS = (s << 1) - 1;
                if (compact)
                    sb.AppendFormat("\to.uv{0} = half4(_Pixel, -_Pixel) * _Sample{0}.xxxx + uv.xyxy;\n", s);
                else
                {
                    sb.AppendFormat("\to.uv{1} =  _Pixel * _Sample{0}.xxxx + uv;\n", s, doubleS);
                    sb.AppendFormat("\to.uv{1} = -_Pixel * _Sample{0}.xxxx + uv;\n", s, doubleS + 1);
                }
            }
            sb.Append("\treturn o;\n}");

            sb.Append(@"
fixed4 frag (v2f i) : SV_Target
{
    fixed4 col = tex2D(_MainTex, i.uv) * _Sample0.y;
");

            for (int s = 1; s < steps; s++)
            {
                int doubleS = (s << 1) - 1;
                if (compact)
                    sb.AppendFormat("\tcol = (tex2D(_MainTex, i.uv{0}.xy) + tex2D(_MainTex, i.uv{0}.zw)) * _Sample{0}.y + col;\n", s);
                else                
                    sb.AppendFormat("\tcol = (tex2D(_MainTex, i.uv{1}) + tex2D(_MainTex, i.uv{2})) * _Sample{0}.y + col;\n", s, doubleS, doubleS + 1);                
            }
            sb.Append("\treturn col;\n}\nENDCG\n}");

            return sb.ToString();
        }

        public static Vector4[] GetSamples(float pixelWidth)
        {
            pixelWidth = pixelWidth * 0.5f - 0.5f;

            int sampleCount = ((int)(pixelWidth * 0.5f)) + 1;
            int pixelCount = sampleCount << 1;
            float fraction = pixelWidth - (pixelCount - 2);

            float[] pixels = new float[pixelCount + 1];
            
            for (int i = 0; i < pixels.Length; i++)      
                pixels[i] = BellCurve(i * 0.55f);

            Normalize(pixels);

            Vector4[] samples = new Vector4[sampleCount];
            for (int i = 1; i < samples.Length; i++)
            {
                float p0 = pixels[(i << 1) - 1],
                      p1 = pixels[(i << 1)];

                samples[i].y = Get1DSamplingScale(p0, p1);
                samples[i].x = ((i << 1) - 1) + Get1DSamplingWeight(p0, p1);
            }
            samples[0].y = pixels[0];
            return samples;
        }

        static void Normalize(float[] vals)
        {
            float sum = 0;
            for (int i = 1; i < vals.Length; i++)
                sum += vals[i];
            sum = sum * 2f + vals[0];
            float mul = 1f / sum;
            for (int i = 0; i < vals.Length; i++)
                vals[i] *= mul;
        }

        private static float BellCurve(float x)
        {
            return Mathf.Exp(-(x * x));
        }

        private static float Get1DSamplingWeight(float a, float b)
        {
            return ((b - a) / (b + a)) * 0.5f + 0.5f;
        }

        private static float Get1DSamplingScale(float a, float b)
        {
            return b + a;
        }
    }
}
