uniform vec2 u_resolution;

void main(){
  vec2 st = gl_FragCoord.xy/u_resolution;

  float d = distance(vec2(0.5, 0.5), st);


  vec3 color = vec3(smoothstep(0.42, 0.41, d));

  gl_FragColor = vec4(color, 1.0);

}
