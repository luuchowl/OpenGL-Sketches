#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;

float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(4561.10567,18642.45612)))* 146134.125613788789);
}


void main(void){
  vec2 st = gl_FragCoord.xy / u_resolution;

  st *= 10.;
  vec2 fst = fract(st);
  vec2 ist = floor(st);
  vec3 color = vec3(random(ist));

  gl_FragColor = vec4(color, 1);
}
