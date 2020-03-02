uniform vec2 u_resolution;

void main(){
  vec2 st = gl_FragCoord.xy/u_resolution;
  st.x *= u_resolution.x/u_resolution.y;

  vec3 color = vec3(0.0);
  float d = 0.0;

  //Remap the space to -1 to 1;
  st = st * 2. -1.;

  //Make the distance field
  d = length(abs(st) - .5);
  //d = length(st);
  //d = length( min(abs(st)-.3,0.) );
  //d = length( max(abs(st),0.) );

  gl_FragColor = vec4(vec3(fract(d*50.0)), 1.0);
  gl_FragColor = vec4(vec3(fract(d*10.0)), 1.0);

  //gl_FragColor = vec4(vec3( step(.3,d) * step(d,.4)),1.0);
  //gl_FragColor = vec4(vec3( smoothstep(.3,.4,d)* smoothstep(.6,.5,d)) ,1.0);
}
