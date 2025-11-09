
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265359

void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;
    st.y *= 10.0;
    st.y += abs(st.x - 0.5);
    st.y -= u_time;
    float mask = step(fract(st.y), 0.5);
    //float mask = step(abs(st.x), fract(st.y*5.0));
    gl_FragColor = vec4(mask, mask, 0.0, 1.0);
}