#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;


float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(4561.10567,18642.45612)))* 146134.125613788789);
}

void main(){
  vec2 st = gl_FragCoord.xy / u_resolution.xy;

  float rnd = random(st);

  gl_FragColor = vec4(vec3(rnd), 1.0);
}
