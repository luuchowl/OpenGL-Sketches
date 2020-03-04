uniform vec2 u_resolution;

void main(){
  vec2 uv = gl_FragCoord.xy/u_resolution;
  
  uv *= 6.;
  uv = fract(uv);
  gl_FragColor = vec4(uv, 0, 1);
}
