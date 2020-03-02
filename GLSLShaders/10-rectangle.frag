uniform vec2 u_resolution;

void main(){
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  vec3 color = vec3(0.0);
/*
  vec2 bl = step(vec2(0.1), st);
  float pct = bl.x * bl.y;

  vec2 tr = 1.0-step(vec2(0.9), st);
  pct *= tr.x * tr.y;
*/

  vec2 bl = smoothstep(0.08, 0.12, st);
  float pct = bl.x * bl.y;

  vec2 tr = 1.0-smoothstep(0.88, 0.92, st);
  pct *= tr.x * tr.y;

  color = vec3(pct);

  gl_FragColor = vec4(color,1.);



}
