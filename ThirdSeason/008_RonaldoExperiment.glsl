//This is a shader

#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

void main()
{
    vec2 st = gl_FragCoord.xy/u_resolution;

    float index = sin(tan(st.x + st.y));
    
    gl_FragColor = vec4(vec2(index, tan(st.y)), 0.0, 1.0);
}