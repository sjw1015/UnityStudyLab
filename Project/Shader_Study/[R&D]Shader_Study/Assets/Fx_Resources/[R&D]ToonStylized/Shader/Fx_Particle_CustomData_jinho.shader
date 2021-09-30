Shader "Particles/CustomData" {
 Properties{
  _Color("Color", Color) = (1,1,1,1)
  _MainTex("Albedo (RGB)", 2D) = "white" {}
  _Glossiness("Smoothness", Range(0,1)) = 0.5
  _Metallic("Metallic", Range(0,1)) = 0.0
 }
  SubShader{
  Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
  Blend SrcAlpha OneMinusSrcAlpha
  ZWrite off
  LOD 200

  CGPROGRAM
  // Physically based Standard lighting model, and enable shadows on all light types
  #pragma surface surf Standard vertex:vert alpha

  // Use shader model 3.0 target, to get nicer looking lighting
  #pragma target 3.0

  //����� ������
  sampler2D _MainTex;
  half _Glossiness;
  half _Metallic;
  fixed4 _Color;

 //#1 -> #2
 struct appdata_particles {
  //�⺻������ ���߰� �־�� �� ������ ����ü
  float4 vertex : POSITION;
  float3 normal : NORMAL;
  float4 color : COLOR;
  float4 texcoord : TEXCOORD0;

  //Ŀ���� ������
  float4 CustomDataTest : TEXCOORD1;
  float4 CustomDataTest2 : TEXCOORD2;
 };

 //#3 -> #4
 struct Input { //Surface�����ͷ� �Ѱ���
  float2 uv_MainTex; //�⺻ UV ǥ���� ���� ��ǥ1 (�ʼ�)
  float2 texcoord; //�⺻ UV ǥ���� ���� ��ǥ2 (�ʼ�)
  float4 CustomDataFinal; //ù��° Ŀ���� ������
  float4 CustomDataFinal2; //�ι�° Ŀ���� ������
  float4 color;
 };

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 //#2 -> #3
 //struct Input���� �Ѱ���.
 void vert(inout appdata_particles v, out Input o) {
  o.uv_MainTex = v.texcoord.xy; //�⺻ UV ǥ���� ���� ��ǥ1 (�ʼ�)
  o.texcoord = v.texcoord.zw; //�⺻ UV ǥ���� ���� ��ǥ2 (�ʼ�)
  o.color = v.color;
  o.CustomDataFinal = v.CustomDataTest;
  o.CustomDataFinal2 = v.CustomDataTest2;
 }

 //#4 Final
 void surf(Input IN, inout SurfaceOutputStandard o) {
  fixed3 BaseColor = tex2D(_MainTex, IN.uv_MainTex) * _Color;

  fixed Alpha = IN.CustomDataFinal.a * IN.CustomDataFinal2.a;
  o.Albedo = BaseColor * (IN.CustomDataFinal.rgb + IN.CustomDataFinal2.rgb);
  o.Metallic = _Metallic;
  o.Smoothness = _Glossiness;
  o.Alpha = Alpha;
 }
 ENDCG
 }
  FallBack "Diffuse"
}
