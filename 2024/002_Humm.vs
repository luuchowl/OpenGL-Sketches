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

float invLerp (float a, float b, float v)
{
    return (v - a) / (b - a);
}

float saturate(float n)
{
    return clamp(n, 0.0, 1.0);
}

//t = normalized time
float quartic(float t)
{
    t *= 2.0;
    if(t < 1.0)
        return 0.5*pow(t, 4.0);
    t -= 2.0;
    return -0.5 * (pow(t, 8.0)- 2.0);
}

float sdCircle(vec2 st, vec2 o, float r)
{
    return distance(st, o) - r;
}

vec2 rotate(vec2 st, float r)
{
    return vec2(
        -cos(r) * st.x + sin(r) * st.y,
        sin(r) * st.x + cos(r) * st.y
    );
}

void main()
{
    vec3 col; 
    float time = u_time;

    float duration = 4.0;
    
    time = mod(time, duration);

    float start = 1.0;
    float end = 3.0;

    float c_time = clamp(invLerp(start, end, time), 0.0, 1.0);

    vec2 st = gl_FragCoord.xy/u_resolution;
    
    st *= 2.0;
    st -= 1.0;
    
    
    st = rotate(st, PI * 1.0 * ceil(u_time * 0.25) );
    vec2 st_eye = st;
    st_eye.y = saturate(abs(st.y) + 0.3);
    

    vec2 st_eyeball = st;
    float time_eye = quartic(c_time);
    st_eyeball.x += time_eye * 0.48 - 0.24; 

    float shape = sdCircle(st_eye, vec2(0.0), 0.3);
    float shape_eyeball = sdCircle(st_eyeball, vec2(0.0), -0.2);
    float plot = line(shape, 0.3, 0.019, 0.001);
    float plot2 = line(shape_eyeball, 0.4, 0.019, 0.001);

    col = vec3(min(plot, plot2));
    

    gl_FragColor = vec4(col, 1.0);


}