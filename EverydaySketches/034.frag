
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURF_DIST 0.01

float opSmoothUnion( float d1, float d2, float k ) {
    float h = clamp( 0.5 + 0.5*(d2-d1)/k, 0.0, 1.0 );
    return mix( d2, d1, h ) - k*h*(1.0-h); }

float GetDist(vec3 p)
{
  vec4 s = vec4(0, sin(u_time* 1.0) * 1.5, 6, 1);
  float sphereDist = length(p-s.xyz) - s.w;
  float planeDist = p.y;
  float d = opSmoothUnion(sphereDist, planeDist, 0.6);
  return d;
}

float RayMarch ( vec3 ro, vec3 rd)
{
  float dO = 0.0;
  for( int i = 0; i < MAX_STEPS; i++)
  {
      vec3 p = ro + rd * dO;
      float dS = GetDist(p);
      dO += dS;
      if(dO > MAX_DIST || dS < SURF_DIST) break;
  }
  return dO;
}

vec3 GetNormal ( vec3 p)
{
  float d = GetDist(p);
  vec2 e = vec2(0.01, 0);

  vec3 n = d - vec3(
    GetDist(p-e.xyy),
    GetDist(p-e.yxy),
    GetDist(p-e.yyx)
    );

  return normalize(n);
}

float GetLight(vec3 p)
{
  vec3 lightPos = vec3 ( 0, 5.0, 6.0);
  lightPos.xz += vec2(sin(u_time), cos(u_time)) * 10.0;
  lightPos.y += sin(u_time) * 10.0;
  vec3 l = normalize(lightPos - p);
  vec3 n = GetNormal(p);

  float dif = clamp(dot(n, l), 0.0, 1.0);
  float spec = pow(clamp(dot(n, l), 0.0, 1.0), 300.0);
  dif *= 0.8;
  dif += spec;

  float r = 1.0;
  float d = RayMarch(p + n * SURF_DIST * 2.0, l);
  if(d < length(lightPos - p)) dif *= min(d, r);
  return dif;

}

void main()
{
  vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;

  vec3 col = vec3(0.0);

  vec3 ro = vec3( 0, 1, 0); // Ray Origin
  vec3 rd = normalize(vec3(uv.x, uv.y, 1.0)); // Ray direction

  float d = RayMarch(ro, rd);
  vec3 p = ro+rd * d;

  float dif = GetLight(p);




  col = vec3(dif);

  vec3 colA = mix(vec3( 0.4, .7, 0.9), vec3( 0.4, .8, 0.3), dif);
  colA += vec3(0.5, 0.3, 0.0) * pow(dif, 1.0);

  vec3 colB = mix(vec3( 0.0, .0, 0.2), vec3( 0.8, .3, 0.3), dif);
  colB += vec3(0.5, 0.3, 0.0) * pow(dif, 25.0);

  col = mix(colA, colB, (cos(u_time + 3.1415926535 * 0.5) * 0.5 + 0.5));

  gl_FragColor = vec4(col, 1.0);
}
