

uniform vec2 u_resolution;
uniform float u_time;

#define MAX_STEPS 100



void main()
{
  vec2 uv = gl_FragCoord.xy / u_resolution;
  uv *= 2.0;
  uv -= 1.0;
  float a = 5.;

  float zoom = pow(10.0, -1.0 +  sin(u_time * 1.0) * 0.6);

  vec2 c = uv * zoom * 0.2;
  c += (-.55955, .35399);
  vec2 z = vec2(0.0);

  float iter = 0.0;

  const float max_iter = 250.0;

  for(float i = 0.; i<max_iter; i++)
  {
    z = vec2 (z.x * z.x - z.y * z.y,2.* z.x * z.y) + c;
    if(length(z) > 2.0) break;
    iter++;
  }

  float f = iter/max_iter;


  vec3 color = vec3(f);
  color.r = max(color.r, 0.2);
  //color.b = min(color.b, 0.5);
  color.r *= 0.5;
  color.b = sin(u_time + color.r * 2.0);

  gl_FragColor = vec4(color, 0.0);
}
