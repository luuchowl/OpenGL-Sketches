
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;


#define PI 3.14159265359

float line(float map, float value, float thickness, float smoothness)
{
  float val1 = smoothstep(value + thickness * 0.5, value + thickness * 0.5 + smoothness, map);
  float val2 = smoothstep(value - thickness * 0.5, value - thickness * 0.5 - smoothness, map);

  return max(val2, val1);
}

vec2 rotate2D(vec2 _st, float _angle){
    //_st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    //_st += 0.5;
    return _st;
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


float sdCircle(vec2 st, vec2 o, float r)
{
  return distance(st, o) - r;
}

float sat(float n)
{
  return clamp(n, 0.0, 1.0);
}

void main()
{
  vec3 col;
  float time =0.0;// (u_time * 5.0  + sin(u_time * 0.5)) * 1.0;

  float duration = 4.0;
  time = mod(time, duration);

  float start = 1.0;
  float end = 3.0;

  for(int i = 0; i < 3; i++)
  {
    vec2 st = gl_FragCoord.xy/u_resolution;
    st.x += 0.01 * float(i) * (sin((time - PI * 0.6) * 0.5) + 1.0);
    //duplicates
    //st = fract(vec2((st.x * 2.0 - 1.0),  sat(st.y * 2.0 - 0.5)));
    //st = vec2(st.x, sat(st.y));

    st *= 2.0;
    st -= 1.0;
    float n = 0.0;//noise(st * 5.0 + vec2(0.0, time));
    st.y+= ((n ) - 0.5) * 0.5 * (sin((time - PI * 0.6) * 0.5) + 1.0) ;
    vec2 st2 = st;
    st.y = sat(abs(st.y) + 0.3);

    float shape = sdCircle(st, vec2(0.0), 0.3);
    float eyeball = sdCircle(st2, vec2(sin(time) * 0.2,0.07 + cos(time * 2.0) * 0.02), -0.2);
    float eyeout = sdCircle(st2, vec2(0.0), 0.22);
    float plot = line(shape, 0.3, 0.019, 0.001);
    float plot2 =line(eyeball, 0.4, 0.019, 0.001);
    plot2 = min(plot2,smoothstep(eyeball, 0.25 + (0.05 * (sin(time * 0.5) + 1.0)), 0.1));
    float plot3 =line(eyeout, 0.3, 0.019, 0.001);
    col[i] = (min(min(plot2, plot), plot3));

  }

vec2 st = gl_FragCoord.xy/u_resolution;
  col.b = max(0.5, col.b);
  col.g = min(0.7, col.g);
  col.r *= st.y + 0.2;

  //col = vec3(1.0 ) - col;
  gl_FragColor = vec4(col , 1.0);


}
