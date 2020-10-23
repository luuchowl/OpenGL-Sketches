uniform vec2 u_resolution;
uniform float u_time;

vec3 corA = vec3(1.0, 0.3, 0.4);
vec3 corB = vec3(0.0, 0.7, 0.2);

float rect(vec2 p, vec2 origin, vec2 size)
{
    return p.x;
}


float circle (in vec2 _st, in float _radius)
{
  vec2 dist = _st-vec2 (0.5);
  return 1. - smoothstep(_radius - (_radius *0.01),
                         _radius + (_radius *0.01),
                         dot(dist, dist) * 4.0);
}

float circle2(vec2 p, vec2 origin, float radius)
{
  return 1.0- smoothstep(radius, radius + 0.005, distance(p, origin));
}


void main()
{
  vec2 st = gl_FragCoord.xy / u_resolution;
  st.x = st.x * u_resolution.x /u_resolution.y;
  st *= 2.0;
  st -= vec2(1.0);
  float shape = 0.0;
  float radius = sin(u_time);
  radius = 1.0;
  for(int i = 0; i < 120; i++)
  {
      shape += circle2(st, vec2(
        cos(3.141592 * 2.0 / 120.0  * float(i) + u_time * 0.5) * radius,
        sin( 3.141592 * 2.0 / 120.0 * float(i) + u_time * (501.5)) * radius
      ) * 0.5, 0.01 + sin(float(i) + u_time * 5.0) * 0.001);
  }

  float shape2 = 0.0;
  for(int i = 0; i < 120; i++)
  {
    shape2 += circle2(st, vec2(
      cos(3.141592 * 2.0 / 120.0  * float(i) + u_time * 0.5) * radius,
      sin( 3.141592 * 2.0 / 120.0 * float(i) + u_time * (501.5)) * radius + 0.02
    ) * 0.5, 0.01 + sin(float(i) + u_time * 5.0) * 0.001);
  }

  float shape3 = 0.0;
  for(int i = 0; i < 120; i++)
  {
    shape3 += circle2(st, vec2(
      cos(3.141592 * 2.0 / 120.0  * float(i) + u_time * 0.5) * radius,
      sin( 3.141592 * 2.0 / 120.0 * float(i) + u_time * (501.5)) * radius + 0.01
    ) * 0.5, 0.01 + sin(float(i) + u_time * 5.0) * 0.001);
  }
  //vec3 color = vec3 (shape);
  vec3 color;
  color.r = shape;
  color.g = shape2;
  //color.g = shape2;
  color.b = shape3;
  //color.g = shape2;
  //color.b = shape3;

  float s1 = rect(st, vec2(0.0), vec2(0.5));
  gl_FragColor = vec4(color, 1.0);

}
