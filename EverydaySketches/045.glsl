
#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform float u_time;

float oscilate(float min, float max, float speed, float offset)
{
  float sine = sin(u_time * speed + offset);
  return min + (max-min) * (sine) ;
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


float line(float map, float value, float thickness, float smoothness)
{
  float val1 = smoothstep(value + thickness * 0.5, value + thickness * 0.5 + smoothness, map);
  float val2 = smoothstep(value - thickness * 0.5, value - thickness * 0.5 - smoothness, map);

  return max(val2, val1);
}

float saturate(float a)
{
  return min(max(a, 0.0), 1.0);
}

void main()
{

    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;
    vec2 _st = st;
    float mult = 2.0;
    st*= 2.0 ;
    st -= vec2(1.0);

    float n = noise(st * 5.0 + vec2(u_time * mult, 0.0)) - 0.5;
    //float a = atan(st.y, st.x);
    //float dist = distance(st, vec2(0,0));

    float a = st.x;
    float dist = st.y;

    float l = sin(a * 13.0 + u_time * mult + n * 2.0);
    float plot = oscilate(0.5, 0.55, 1.0, 0.0);
    plot = 0.55;

    vec3 color = vec3(line(dist + l * 0.02 * saturate(sin((a * 1.0) + u_time * mult)), 0.5, 0.00001, 0.01));
    color = vec3(1.0);


    for(float i = 0.0; i<1.0; i+=0.15){
      plot = 0.2 - i;
      color.r *= line(dist + l * 0.05 * saturate(sin((a * 3.0) + u_time * mult)), plot, saturate(sin((a * 1.0 + 0.4) + u_time * mult + i * 5.0)) * 0.02, 0.001);
      color.g *= line(dist + l * 0.02 * saturate(sin((a * 2.0 + 0.4) + u_time * mult)),plot, saturate(sin((a * 1.0 + 0.4) + u_time * mult + i* 5.0)) * 0.02, 0.009);
      color.b *= line(dist + l * 0.03 * saturate(sin((a * 1.0 + 0.7) + u_time * mult)), plot, saturate(sin((a * 1.0 + 0.4) + u_time * mult + i* 15.0)) * 0.01, 0.004);
    }


    //for(int i = 0; i<5; i++){
    //color.r *= line(dist -0.2 + l * 0.03 * saturate(sin((a * 1.0) + u_time * mult)), 1.0, saturate(sin((a * 1.0 + 0.4) + u_time * mult)) * 0.02, 0.51);
    //color.g = max(color.g ,line(dist -0.4+ l * 0.01 * saturate(sin((a * 1.0 + 0.4) + u_time * mult)), 0.5, saturate(sin((a * 1.0 + 0.4) + u_time * mult)) * 0.02, 0.71));
    //color.r += line(dist - 0.4 + l * 0.02 * saturate(sin((a * 1.0 + 0.5) + u_time * mult)), 0.5, saturate(sin((a * 1.0 + 0.4) + u_time * mult)) * 0.01, (sin(u_time * mult * 0.5) * 2.0 + 1.1) * 1.0);


    color.b = min(color.b, 0.8);
    //color.r = max(color.r, 0.1);
    //}
    //color.r = a;
    gl_FragColor = vec4 (color, 1.0);
    //gl_FragColor = vec4(st, 0.0, 1.0);
}
