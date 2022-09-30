#ifdef GL_ES
precision mediump float;
#endif

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
  vec2 st = gl_FragCoord.xy / u_resolution;
  st.x = st.x * u_resolution.x /u_resolution.y;
  st *= 2.0;
  st -= vec2(1.0);
  st *= 2.5;
  float n = noise(st * 5.0 + vec2(u_time, 0.0));
  float m = noise(st * 5.0 + vec2(0.0, u_time));
  st.x += n;
  st.y += m;
  float shape = 0.0;
  float radius = sin(u_time);
  radius = 1.0;
  //vec3 color = vec3 (shape);
  vec3 color;
  //color.r = shape;
  //color.xy = fract(st);
  color.b = (mod(floor(st.x) + floor(st.y), 2.0));
  color.b = max(0.3, color.b);
  color.g = (mod(floor(st.x + 0.04) + floor(st.y), 2.0));
  color.r = (mod(floor(st.x - 0.1) + floor(st.y), 2.0));
  color.g = min(color.g, 0.95);

  //color.r = (color.b);
  //color.b = n;
  //color.g = shape;
  //color.g = shape2;
  //color.b = shape;
  //color.g = shape2;
  //color.b = shape3;

  float s1 = rect(st, vec2(0.0), vec2(0.5));
  gl_FragColor = vec4(color, 1.0);

}
