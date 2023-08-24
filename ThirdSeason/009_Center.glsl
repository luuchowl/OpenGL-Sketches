//This is a shader

#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265359
#define TWO_PI 6.28318530718

void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;
    st *= 2.0;
    st -= 1.0;
    
    float d = length(st);
    float ang = atan(st.y, st.x) + u_time; 

    ang = fract(ang / TWO_PI * 8.0);
    float traced = step(ang, 0.5);
    traced = min(step(d, 0.6) - step(d, 0.55), traced);
    
    float circle = step(d, 0.45 + sin(u_time * 3.) * 0.03);

    float shape = max(circle, traced);
    //
    //

    gl_FragColor = vec4(vec3(shape), 1.0);
}