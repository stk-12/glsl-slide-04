varying vec2 vUv;
uniform float uTime;
uniform sampler2D uTexCurrent;
uniform sampler2D uTexNext;
uniform sampler2D uTexDisp;
uniform vec2 uResolution;
uniform vec2 uTexResolution;
uniform float uProgress;


float parabola( float x, float k ) {
  return pow( 4. * x * ( 1. - x ), k );
}

void main() {
  vec2 uv = vUv;


  // vec2 ratio = vec2(
  //       min((resolution.x / resolution.y) / (imageResolution.x / imageResolution.y), 1.0),
  //       min((resolution.y / resolution.x) / (imageResolution.y / imageResolution.x), 1.0)
  //     );

  //   vec2 uv = vec2(
  //       vUv.x * ratio.x + (1.0 - ratio.x) * 0.5,
  //       vUv.y * ratio.y + (1.0 - ratio.y) * 0.5
  //     );

  // vec2 ratio = vec2(
  //   min((uGeoResolution.x / uGeoResolution.y) / (uTexResolution.x / uTexResolution.y), 1.0),
  //   min((uGeoResolution.y / uGeoResolution.x) / (uTexResolution.y / uTexResolution.x), 1.0)
  // );
  vec2 ratio = vec2(
    min((uResolution.x / uResolution.y) / (uTexResolution.x / uTexResolution.y), 1.0),
    min((uResolution.y / uResolution.x) / (uTexResolution.y / uTexResolution.x), 1.0)
  );

  uv = vec2(
    vUv.x * ratio.x + (1.0 - ratio.x) * 0.5,
    vUv.y * ratio.y + (1.0 - ratio.y) * 0.5
  );

  vec3 texDisp = texture2D(uTexDisp, uv).rgb;
  float disp = texDisp.r;
  disp = disp * parabola(uProgress, 0.8);

  // 右から左
  // vec2 dispUv = vec2(uv.x + disp, uv.y);
  // vec2 dispUv2 = vec2(uv.x - disp, uv.y);
  // 右から左（変形を小さく）
  // vec2 dispUv = vec2(uv.x + disp * 0.5, uv.y);
  // vec2 dispUv2 =  vec2(uv.x - disp * 0.5, uv.y);

  // 上から下
  // vec2 dispUv = vec2(uv.x, uv.y + disp);
  // vec2 dispUv2 = vec2(uv.x, uv.y - disp);

  // 右上から左下
  vec2 dispUv = vec2(uv + disp);
  vec2 dispUv2 = vec2(uv - disp);
  // 右上から左下（変形を小さく）
  // vec2 dispUv = uv + vec2(disp) * 0.3;
  // vec2 dispUv2 = uv - vec2(disp) * 0.3;

  // 左下から右上
  // vec2 dispUv = vec2(uv - disp);
  // vec2 dispUv2 = vec2(uv + disp);


  vec3 tex1 = texture2D(uTexCurrent, dispUv).rgb;
  vec3 tex2 = texture2D(uTexNext, dispUv2).rgb;
  vec3 color = mix(tex1, tex2, uProgress);

  gl_FragColor = vec4(color, 1.0);
}