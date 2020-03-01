#ifdef GL_ES
precision mediump float;
#endif


uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//Plot a line on Y using a value betwwen 0.0 - 1.0
float plot(vec2 st, float pct){
  return smoothstep(pct-0.02, pct, st.y) - smoothstep(pct, pct+0.02, st.y);
}

void main(){
  vec2 st = gl_FragCoord.xy/u_resolution;

  //float y = pow(st.x, 1.);
  //float y = step(0.5, st.x);
  //float y = smoothstep(0.4, 0.6, st.x);
  float y = mod(st.x,0.5);

  vec3 color = vec3(y);

  //Plot a line;
  float pct = plot(st,y);
  color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);

  gl_FragColor = vec4(color, 1.);
}
