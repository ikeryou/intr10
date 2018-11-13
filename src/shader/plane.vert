
attribute vec4 a_color;
attribute vec3 a_tg;
attribute vec3 a_noise;

uniform float time;
uniform float rate;
uniform float wave;
uniform bool wire;

varying vec4 vColor;
varying vec2 vUv;


vec3 rgbtohsv(vec3 c) {
  vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
  vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
  vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

  float d = q.x - min(q.w, q.y);
  float e = 1.0e-10;
  return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}


vec3 hsvtorgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}



void main(){

  // vColor = vec4(1.0, 0.0, 0.0, 1.0);

  vec3 c = a_color.rgb;
  vec3 hsv = rgbtohsv(c);
  hsv.x += a_noise.x * 0.1 + time * 0.01;

  if(wire) {
    vColor = vec4(1.0, 0.0, 0.0, 1.0);
  } else {
    vColor = vec4(hsvtorgb(hsv), a_color.a);
  }

  vUv = uv;

  vec3 p = position;


  // float rad = a_noise.x + time * 0.1;
  float range = wave * 0.0001;
  p.x += sin(a_noise.x * 10.0 + time * 0.1) * range;
  p.y += cos(a_noise.y * 10.0 + time * 0.1) * range;

  gl_Position = projectionMatrix * modelViewMatrix * vec4(p, 1.0);

}
