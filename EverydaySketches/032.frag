uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.1415926535

#define particles 100

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
  float m = noise(floor(st * 1.0) + vec2(0.0, u_time ));
  //st.x += n * 1.0 * sin(u_time * 2.0);
  //st.y += m * 0.8;
  float shape = 0.0;

  //vec3 color = vec3 (shape);
  vec3 color = vec3(1.0);

  float timer = (u_time * 1.0) ;

  //multiply by 0.5
//st = rotate2D(st,PI*0.25 + u_time);
  float cycle = mod(ceil(timer), float(particles));
  for(int i = 0; i < particles; i++ )
  {
      vec2 location = vec2(float(i));

      float size = 0.4;


      float j = mod( float(i) , float(particles + 1));

      //multipliquei aqui por 3
      float k = mod( float(i) + (timer * float(particles)) , float(particles));

      float l = float(i) / float(particles);
      float m = floor(mod( float(i)+  float(l) + (timer) , float(particles)));
      //m = (l);
      float seed = random(vec2(j, float(m) - j));


      float lifetime =  k / float(particles );

      //size = 0.1 + seed * 0.4;
      size = 0.0 + seed * 0.5;
      size = size;

      location = vec2(random(vec2(seed, seed+50.0)), random(vec2(seed, seed-50.0))) * 2.0 - 1.0 ;
      location *= 1.0;
      location = location * lifetime * 2.0;
      vec2 _st2 = st;
      float n = noise((st * 2.0) + vec2(u_time, 0.0)) * 2.0 - 1.0;
      //n *= n;
      //st.y += n * 0.012;
      //st.x += n * 0.012;

      float sdf = distance((vec2(0.0) +
                                    /*vec2(vec2(float(i) + (timer), 0.0)),
                                         random(vec2(0.0, float(i) + (timer))))* 4.0, st),
                                         */

                                         //Particle localization
                                         //vec2(0.0)
                                         location


                                         ), st) - size ;

      sdf += 1.5 - lifetime ;
      sdf = sin(sdf * 0.05);
      //sdf = cos(sdf);
      float circle = smoothstep(sdf, size -0.009, size);
      circle = clamp(circle, 0.0, 1.0);
      //shape = min(circle, shape) * 1.8 ;
      shape += (1.0-circle) * (0.6 - lifetime);
      shape = clamp(shape, 0.2, 1.0);
      //shape += clamp((1.0-circle ) * (0.0 - lifetime ), 0.0, 1.0);

  }
  shape = clamp(shape, 0.0, 1.0);
  color.rgb = vec3(shape);
  color.rgb *= 1.0;// + sin(u_time * 0.5) * 500.0;
  color.rgb = vec3(1.0) - color;
  //color
//  color.g = (mod(floor(st.x + 0.04) + floor(st.y), 2.0));
//color.r = mix(color.r, (mod(floor(st.x - 0.9) + floor(st.y), 2.0)), 0.0);
color.gb *= 1.0-_st.y;

//color.g = min(color.g, 0.8);
//color.b = max(0.5, color.b);
////color.b = min(color.b, 0.5);
//color.g = max(0.2, color.g);
//color.g = min(0.5, color.g);
//color.r = max(color.r, 0.3);
//color.r = min(color.r, 0.9);
//color.g *= 1.0-_st.x;
color.rg -= vec2(0.3);

  //float s1 = rect(st, vec2(0.0), vec2(0.5));


  gl_FragColor = vec4(color, 1.0);

}
