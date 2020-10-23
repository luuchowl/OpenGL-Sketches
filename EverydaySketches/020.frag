uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.1415926535

#define particles 10

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

vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

float box(vec2 _st, vec2 _size, float _smoothEdges){
    _size = vec2(0.5)-_size*0.5;
    vec2 aa = vec2(_smoothEdges*0.5);
    vec2 uv = smoothstep(_size,_size+aa,_st);
    uv *= smoothstep(_size,_size+aa,vec2(1.0)-_st);
    return uv.x*uv.y;
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

float oscilate(float min, float max, float speed, float offset)
{
  float sine = sin(u_time * speed + offset);
  return 2.0 * min + (max-min) * (sine) * 0.5;
}

void main()
{
  vec2 st = gl_FragCoord.xy / u_resolution;
  vec2 _st = st;
  st.x = st.x * u_resolution.x /u_resolution.y;
  st *= 2.0;
  st -= vec2(1.0);
  //st = rotate2D(st,PI*0.25 + u_time);

  st *= 5.0;
  //st.y *= 5.0;
  float n = noise((st * 2.0) + vec2(u_time, 0.0));
  float m = noise((st * 1.0) + vec2(0.0, u_time));
  //st.x += n * 1.0 * sin(u_time * 2.0);
  st.y += m * 1.0 * cos(u_time * 2.0);
  float shape = 1.0;

  //vec3 color = vec3 (shape);
  vec3 color;

  float timer = ceil(u_time * 2.0) ;

  //multiply by 0.5
//st = rotate2D(st,PI*0.25 + u_time);
  for(int i = 0; i < particles; i++ )
  {
      float circle = smoothstep(distance((vec2(0.0) +
                                    /*vec2(vec2(float(i) + (timer), 0.0)),
                                         random(vec2(0.0, float(i) + (timer))))* 4.0, st),
                                         */
                                         vec2(random(vec2(float(i) )), random(vec2(5.0-float(i)))) - 0.3) * 5.0 - 1.0,  rotate2D(st,PI*0.25 + u_time * 0.1 * float(mod(u_time * 5.0 + float(i) * 1.0, float(particles)) / 10.0  ) * 0.001) ),
                           oscilate(0.4,1.1, 1.0, 0.1 * float(mod(u_time + float(i) , float(particles))  )), 0.1 * float(mod(u_time + float(i) , float(particles))  ) );
      shape = min(circle, shape) * 1.8 ;
  }

  color.g = shape;
  color.g = shape;
  //color.xy = fract(st);

  //color.b = mix(color.b, (mod(floor(st.x) + floor(st.y), 2.0)), 0.4);
  //color.g = color.b;
  color.r = shape;
  //color.g = max(color.g, 0.4);
  //color.g = min(color.g, 0.8);
  //color.b = max(color.b, 0.5);
  //color.r = min(color.r, 0.99);
  if((dot(color, vec3(1, 1, 1)) > 1.2) && (dot(color, vec3(1, 1, 1)) < 2.5))
  {
    color.rgb = vec3(0.2, 0.15, 0.2);
  }
  color.b = max(0.3, color.b);
  //color.g = (mod(floor(st.x + 0.04) + floor(st.y), 2.0));
//color.r = mix(color.r, (mod(floor(st.x - 0.9) + floor(st.y), 2.0)), 0.0);
  //color.g = min(color.g, 0.8);
  //color.b = max(0.2, color.b);
  //color.g = max(0.2, color.g) * 0.3;
  color.g *= 1.0-_st.x;
  color.r *= 1.0-_st.y;

  //float s1 = rect(st, vec2(0.0), vec2(0.5));


  gl_FragColor = vec4(color, 1.0);

}
