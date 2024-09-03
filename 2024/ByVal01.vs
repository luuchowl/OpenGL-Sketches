#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution; //vec2(1000.0, 1000);
uniform float u_time;

void main()
{

    vec2 st = gl_FragCoord.xy / u_resolution; 
    st = st * (u_time)*4.;
    st = cos(st);
    float circle = step(cos(u_time), distance(st, vec2(0.5,0.5)));
    vec4 cor = vec4(sin(u_time), st.y, circle, 1.0);
    gl_FragColor = vec4(st, 0.0, 1.0); //RGBA
}