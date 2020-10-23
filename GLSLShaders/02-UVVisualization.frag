#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec4 cor1 = vec4(0.8, 0.4, 0.3, 1.0);
vec4 cor2 = vec4(0.4, 0.2, 0.6, 1.0);

void main(){
  vec2 st = gl_FragCoord.xy / u_resolution ;


  //vec4 corFinal = mix(cor1, cor2, st.y);
  //gl_FragColor = corFinal;

  vec3 corFinal = vec3(smoothstep(0.3, 0.36, st.x));

  //vec3 corFinal = vec3(step(
  //      (sin(u_time) + 1.0) * 0.5,
  //    st.x));

  gl_FragColor = vec4(corFinal,1.);

  //gl_FragColor = vec4(st,0.0,1.);
}
