#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;


void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;
    //st.x = st.x * 10.0;
    st.x = fract(st.x);

    vec2 rst; 
    rst.x = distance(st, vec2(0.5));
    rst.x = rst.x * 10.0;
    rst.x = fract(rst.x + u_time );

    gl_FragColor = vec4(rst.x, 0.0, 0.0, 1.0);
}