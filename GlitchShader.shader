Shader "Unlit/Shader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_AScale ("aScale", Range(0,10)) = 1
		_BScale ("bScale", Range(0,10)) = 1
		_MaxAmplitude ("maxAmplitude", Range(0,10)) = 1
		_AmplitudeChangeSpeed ("amplitudeChangeSpeed", Range(0,100)) = 1
		_IsGlitching ("isGlitching", Range(0,1)) = 0 // if 1 turn on glitching 

		_RMaxOffset ("rMaxOffset", Range(0,0.5)) = 0
		_GMaxOffset ("gMaxOffset", Range(0,0.5)) = 0
		_BMaxOffset ("bMaxOffset", Range(0,0.5)) = 0
		_RGBChangeSpeed ("rgbChangeSpeed", Range(0,100)) = 1
	}
    SubShader
    {
        Pass
        {
			Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;	
			float _AScale;
            float _BScale;
			float _MaxAmplitude;
			float _AmplitudeChangeSpeed;
			int _IsGlitching;

			float _RMaxOffset;
			float _GMaxOffset;
			float _BMaxOffset;

			float rOffset;
			float gOffset;
			float bOffset;
			float _RGBChangeSpeed;

			struct vertIn{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct vertOut{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			float choseAmplitude(){
				return(abs(sin(_Time.y * _AmplitudeChangeSpeed) * _MaxAmplitude));
			}

			// rounds x up to the nearest whole number is +ve and down if -ve
			int customRounding(float x){
				if(x >= 0){
					return 1 * choseAmplitude();
				}
				else{
					return -1 * choseAmplitude();
				}
			}

			// applies a combination of sin waves altered by time, to give the appearance of randomness
			// the waves added were decided based on what looked best
			float applySines(float x){
				float a = unity_DeltaTime.y * _AScale;
				float b = unity_DeltaTime.y * _BScale;
				x = sin(x + a) + sin(3*x + b) + sin(5*x + b);
				return x;
			}

			void setColourOffsets(){
				rOffset = abs(sin(_Time.y * _RGBChangeSpeed) * _RMaxOffset);
				gOffset = abs(sin(_Time.y * _RGBChangeSpeed) * _GMaxOffset);
				bOffset = abs(sin(_Time.y * _RGBChangeSpeed) * _BMaxOffset);
			}

			// Implementation of the vertex shader
			vertOut vert(vertIn v){
				vertOut o;
    
                v.vertex = mul(UNITY_MATRIX_MV, v.vertex);
				if(_IsGlitching){
					v.vertex.x += customRounding(applySines(v.vertex.y));
				}
    
                o.vertex = mul(UNITY_MATRIX_P, v.vertex);

				o.uv = v.uv;
				return o;
			}
			
			// Implementation of the fragment shader
			fixed4 frag(vertOut v) : SV_Target{
				if(_IsGlitching){
					setColourOffsets();
					fixed rValue = tex2D(_MainTex, float2(v.uv.x + rOffset, v.uv.y + rOffset)).r;
					fixed gValue = tex2D(_MainTex, float2(v.uv.x + gOffset, v.uv.y + gOffset)).g;
					fixed bValue = tex2D(_MainTex, float2(v.uv.x + bOffset, v.uv.y + bOffset)).b;

					fixed4 color = fixed4(rValue, gValue, bValue, 0.5);
					return color;
				}
				else{
					fixed4 color = tex2D(_MainTex, v.uv);
					return color;
				}
			}
			ENDCG
        }
    }
}
