vec4 addColor(vec4 cB, vec4 cA) {
  return vec4((cA.rgb * vec3(cA.a)) + (cB.rgb * vec3(1.0 - cA.a)), min(cA.a, cB.a));
}

#pragma glslify: export(addColor)
