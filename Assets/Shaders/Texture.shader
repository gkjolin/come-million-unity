﻿Shader "Custom/Texture"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
	}
	SubShader
	{
		Cull Off
		// ZTest Off ZWrite Off
		// Blend SrcAlpha OneMinusSrcAlpha
		// Blend One One

		Pass
		{
			CGPROGRAM
			#include "UnityCG.cginc"
			#include "Common.cginc"
			#pragma vertex vert
			#pragma fragment frag
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _GradientTex;
			float4 _Tint;
			float4 _Offset;

			struct v2f
			{
				TRI_COMMON
				float2 pos : TEXCOORD2; 
			};

			v2f vert(appdata v) {
				v2f o;
				TRI_INITIALIZE(o);
				// o.pos = o.vertex * 0.5 + 0.5;
				float2 s = _Resolution.zw * _TexelSize.zw;
				float fx = _Resolution.y % 2 == 0;
				o.pos = (v.uv2 + (_Resolution.xy - fx) / _Resolution.zw) * s;
				// o.pos = (v.uv2 + (_Resolution.xy) / _Resolution.zw) * s;
				// o.pos = (v.uv2 + (_Resolution.xy + 0.5) / _Resolution.zw) * s;
				o.pos = o.pos * _MainTex_ST.xy + _MainTex_ST.zw;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.pos;
				float4 col = tex2D(_MainTex, uv + _Offset.xy);
				return (col * _Tint).grba;
			}
			ENDCG
		}
	}
}
