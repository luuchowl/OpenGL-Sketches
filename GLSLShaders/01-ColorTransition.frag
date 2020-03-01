#ifdef GL_ES
precision mediump float;
#endif



uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main(){
  gl_FragColor = vec4(abs(sin(u_time*2.)), abs(sin(u_time*3.)), abs(sin(u_time*2.5)), 1.0);
}
