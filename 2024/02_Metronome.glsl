#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265


float quartic(float t)
{
    t *=  2.0;
    if(t < 1.0)
        return 0.5 * pow(t, 4.0);
    t -= 2.0;
     return -0.5 * (pow(t, 8.0)- 2.0);   
}

void main()
{
    vec3 color;
    float t = abs(fract(u_time * 0.3) * 2.0 - 1.0) ;
    t = quartic(t);
    vec2 st = gl_FragCoord.xy / u_resolution;
    st.x = st.x * 2. - 1.;
    

    float d = length(st);
    float r = atan(st.y, st.x) / PI;
    
    float size = 0.35;

    float metronome = step(r, t * 0.5 + 0.25 );
    
    color = vec3(metronome);

    gl_FragColor = vec4(color, 1.0);
}

