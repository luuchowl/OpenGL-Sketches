#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

vec2 r(vec2 c, float d)
{
    return vec2(cos(d) * c.x -sin(d) * c.y, 
                sin(d) * c.x +cos(d) * c.y);
}

void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution; 
    vec2 uv = st;
    st.x += u_time * 0.1;
    st.y *= mix(1.4, 1.0, uv.x);
    //st.y += .5;
    st *= 2.0;
    st.y *= 0.8;
    st -= 1.0;
    float limiar = sin((st.x + sin(st.y )) * 3.141592 * 2.) * 0.2;
    float horizonte = 1.0-step(limiar, st.y );

    vec2 st_2 = st;
    st_2.x += -0.1;
    float limiar_2 = sin((-st_2.x+ sin(st_2.y)) * 3.141592 * 2.) * 0.2;
    float horizonte_2 = 1.0-step(limiar_2 , st.y );
    
    /*
    for(int i = 0; i < 5; i++)
    {
        vec2 st_aux = st;
        st_aux.x += float(i) * 0.4;
        
        vec2 st_parabola = st_aux * 4.;
        st_parabola = r(st_parabola, 3.8);
    //st_parabola.x += sin(st) ;
        float parabola = step(st_parabola.x * st_parabola.x, st_parabola.y );
        p += parabola;
    }
  */  

   
    vec3 cor_ceu = vec3(0.3, 0.7, 0.8);
    float mascara_duna = max(horizonte, horizonte_2);
    vec3 cor_duna = mix(vec3(0.7137, 0.2353, 0.2353), vec3(0.8392, 0.7608, 0.3059), horizonte_2);

    gl_FragColor = vec4( mix(cor_ceu, cor_duna, mascara_duna), 1.0);
    //gl_FragColor = vec4(cor_duna, 1.0);
}