uniform float alpha;
uniform float white;
uniform vec3 rgb;

varying vec4 vColor;
varying vec2 vUv;

void main(void) {

  vec4 dest = vColor;
  dest.rgb *= rgb;
  dest.a *= alpha;

  gl_FragColor = dest;

}
