#ifdef GL_ES
    precision mediump float;
#endif

#define PI 3.14159265

uniform vec2 u_resolution;
uniform float u_time;

vec2 rotate2d(vec2 coord, float angle)
{
    return vec2(cos(angle) * coord.x - sin(angle) * coord.y, 
                sin(angle) * coord.x + cos(angle) * coord.y);
}

float quartic(float t)
{
    t *= 2.0;
    if(t < 1.0)
        return 0.5 * pow(t, 8.0);
    t -= 2.0;
        return -0.5 * (pow(t, 8.0) - 2.0);
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    
    float t = u_time * 0.20;

    st -= 0.5;
    st *= 1.0;
    //st = fract(st);
    float d = length(st) * 0.05;

    vec2 st_bg = rotate2d(st * 0.8 + 1.1, t);
    
    float box = 0.;

    for(int i = 0; i < 15; i++)
    {
        st = rotate2d(st, quartic((abs(fract((t + d) * .5)-0.5) * 2.0)) * 3.14 / 20.0 );
        st *= 1.05 + u_time * 0.01;
        box += min(min(step(-0.5, st.x), step(st.x, 0.5)),
        min(step(-0.5, st.y), step(st.y, 0.5))) * 0.15;
    }
    


    gl_FragColor = vec4(st_bg.x,box * .6,sin(t * 2.) * 0.3 + 0.6,1.0);
}