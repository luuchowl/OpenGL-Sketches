uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846


 vec3 colorA = vec3(0.89, 0.94, 0.6);
 vec3 colorB = vec3(0.9, 0.3, 0.9 );

vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}


void main(void){
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  vec3 color = vec3(0.0);

  st = fract(st * 9.);
  vec2 uv = st;
  st = rotate2D(st, PI*0.25);
  float square = 1.;
  vec2 bl = smoothstep(vec2(0.15) ,vec2(0.20), st.xy);
  vec2 tr = vec2(1.0) - smoothstep(vec2(0.85), vec2(0.85), st.xy);
  square *= tr.x * tr.y * bl.x * bl.y;

  float sphere = 1.0;

  vec2 spherePos = vec2(sin(u_time) + 1., cos(u_time) + 1.) * 0.5;
    vec2 spherePos2 = vec2(sin(u_time - PI) + 1., cos(u_time - PI) + 1.) * 0.5;

  float d = distance(uv, spherePos);
  sphere = smoothstep(0.3, 0.8, d);

  d = distance(uv, spherePos2);
  sphere *= smoothstep(0.3, 0.8, d);

  //gl_FragColor = vec4((1.-sphere) * 1.  - 0.7, 0.26, 0.5 * square, 1);
  gl_FragColor = max(vec4(mix(colorA * square, colorB, sphere) , 1), vec4(0.7, 0.4, 0.3, 1))  ;
  //gl_FragColor = vec4(vec3(square), 1.);
  //gl_FragColor = vec4(st, 0, 1);
}
