#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define MAX_STEPS 100

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}
// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}


void main()
{
  vec2 uv = gl_FragCoord.xy / u_resolution;
  uv *= 2.0;
  uv -= 1.0;
  uv.x += 0.3;
  float a = 5.;

  float n = noise(uv * 2.0 + u_time);
  //uv += n * 0.8;
  //float zoom = pow(10.0, 0.0 +  1.0 * 0.1);
  float zoom = 7.0;
  float r = length(uv);
  float ar = atan(uv.y, uv.x);
  vec2 c = mix(uv, vec2(r, ar * 3.1415926535), 0.0) * zoom * 0.1;
  c += (-.05955, .00399);
  vec2 z = vec2(0.0);

  float iter = 0.0;

  const float max_iter = 250.0;

  for(float i = 0.; i<max_iter; i++)
  {
    c.x += -0.008 * sin( u_time);
    //c += 0.02;
    z = mix(vec2 (z.x * z.x  - z.y * z.y  , 2.0* z.y * z.x  ) + c * 1.0, vec2 (z.x * z.x - z.y * z.y ,2.* z.x * z.y ) + c * 1.0, 0.0);
    z = z + c;
    //z *= z.y + z.x - z.x * z.x;/
    z-= 0.3;
    if(length(z ) > 2.0) break;
    iter++;
  }

  float f = iter/max_iter;


  vec3 color = vec3(z.x, z.y, c);
  //color.r = max(color.r, 0.2);
  //color.b = min(color.b, 0.5);
  color.b = (cos(u_time + color.r * 10.0) + 1.0) * 0.2 ;
  color.g *= 0.2;
  //color.b = (sin(u_time + color.r * 5.0) + 1.0) * 0.5;
  color.g = (sin(u_time + color.r * 5.0) + 1.0) * 0.5 - 0.5;
  //color.b *= 0.4;

  gl_FragColor = vec4(color, 1.0);
}
