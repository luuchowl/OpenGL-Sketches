#ifdef GL_ES
precision mediump float;
#endif


uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main(){
  float dist = distance(u_mouse , gl_FragCoord.xy / u_resolution);
  gl_FragColor = vec4 (dist , 1. , 1. , 1.);
}
