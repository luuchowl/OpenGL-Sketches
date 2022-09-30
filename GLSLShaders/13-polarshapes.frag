#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

void main(){
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  vec3 color = vec3(0.0);

  vec2 pos = vec2(0.5) - st;

  float r = length(pos) * 2.0;
  //float a = atan(pos.y, pos.x);
  float a = atan(pos.y, pos.x) + u_time - r;

  //float f = abs(cos(a*3.)) * 0.5 + .2;
  // f = abs(cos(a*3.));
  //float f = abs(cos(a*12.)* sin (a*3.)) *( .4  * (sin(u_time * 2.) + 1.)) + .1;
  float f = abs(cos(a*12.*cos(u_time * 0.00001))* sin (a*3.)) *( .4  ) + .1;
  //float f = smoothstep(-.5,1., cos(a*10.)) * 0.2 + 0.5;

  color = vec3(1.-smoothstep(f, f+0.02, r)) ;
  //color = vec3(1.-smoothstep(f, f+0.02, r)) * (1. - vec3(1.-smoothstep(0.05, 0.05+0.02, r)));
  gl_FragColor = vec4(color, 1);
}
