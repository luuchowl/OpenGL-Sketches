#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;
    st.x *= u_resolution.x / u_resolution.y;
    st *= 5.0;
    float T = (floor(st.x)) + floor(st.y) + 1.0; 
    st = fract(st);
    
    vec3 color; 
    float disp = 0.0; 
    for(int i = 0; i<3; i++)
    {
        

        float d = length((st + disp + sin(u_time * T * 1.0) * 0.3) - 0.5) * 4.0;
        float e = length((st - sin(u_time * (5.0-T)) * 0.3) - 0.5) * 2.1;
        float field = min(d, e);
        float p = step(field, abs(sin(u_time * T * 1.0)) * 0.3 + 0.1) ;
        color[i] = p;
        disp += 0.05;
    }
    

    gl_FragColor = vec4(color, 1.0);
}