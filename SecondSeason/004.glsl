#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;


vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

void main()
{
    float d = 0.0;
    
    vec2 st = (gl_FragCoord.xy) / u_resolution;
    st *= 30.0;
    vec3 color = vec3(0.1, 0.1, 0.1);

    color.r = fract(st.x);
    color.g = fract(st.y);

    
    float a = u_time;
        //st.x += cos(st.x + u_time * 1.5) * 1.0;
        
        //
        //

    st += d;
    st *= 3.0;
    float T = fract((floor(st.x) + floor(st.y))/30.0 * 2.0 ) * 30.0  ;
    st = rotate2D(st, 0.004 * T * u_time);
    st.x = cos(st.x + 1.5) * 1.0;
    st.y = sin(st.y + 1.5) * 1.0;
    float square = smoothstep(fract(st.x), 0.9  * 0.4, 0.9);
    square *= smoothstep(0.0, fract(st.x), 0.2);
    square *= smoothstep(fract(st.y), 0.9 , 0.9);
    square *= smoothstep(0.0 , fract(st.y), 0.2);
    d += 0.01;

    gl_FragColor.a = 1.0;
    gl_FragColor.rgb = vec3(square) ;
}