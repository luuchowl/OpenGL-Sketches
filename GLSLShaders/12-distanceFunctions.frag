uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}


void main(){
  vec2 st = gl_FragCoord.xy/u_resolution;
  st.x *= u_resolution.x/u_resolution.y;

  vec3 color = vec3(0.0);
  float d = 0.0;

  //Remap the space to -1 to 1;
  st = st * 10. -1.;
  vec2 i = floor(st);
  vec2 f = fract(st);

  st = fract(st) - vec2(0.2, 0.2) -  vec2(0.6, 0.6) * random (i) ;

  //Make the distance field
  //d = length(abs(st) - .5);
  d = length(st);
  d = length( min(abs(st)-(.22 + abs(sin(u_time * 0.3 + random(i) * PI)) * random(i) * 0.05),0.) );
  //d = length( max(abs(st),0.) );

  gl_FragColor = vec4(vec3(fract(d*50.0)), 1.0);
  gl_FragColor = vec4(vec3(fract(d*10.0)), 1.0);

  gl_FragColor = vec4(vec3( step(.3,d) * step(d,.4)),1.0);
  gl_FragColor = vec4(vec3( smoothstep(.3,.4,d)* smoothstep(.6,.5,d)) ,1.0);
}
