#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

vec2 r(vec2 c, float d)
{
    return vec2(-cos(d) * c.x + sin(d) * c.y,
            sin(d) * c.x + cos(d) * c.y);
}

void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;

    
    st *= 2.0; 
    st -= 1.0;
    float d = distance(st, vec2(0.5));
    float a = sin(atan(st.y, st.x));
    st = vec2(d, a);

    st.y *= 1.0 ;
    st.x += cos(st.y * 0.1 + u_time * 0.4) * 1.0 + sin(st.x * 0.2 + u_time * 0.5) - 0.8 ;

    st.y += sin(st.x * 10.0 - u_time * 0.134) * 0.2 ;
    //float a = fract(st.y);
    st.y = fract(st.y) ;
    st = r(st, cos(u_time * 0.9) * 1.0 );//+ fract(st.y));
    st.x += fract(st.y * 1.5);

    vec3 color = mix(vec3(0.3, 0., 0.0), vec3(0.1, 0.2, 0.4), 1.0-st.x);

    gl_FragColor = vec4(color, 1.0);
}