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
    int i = 0;
    for(int i = 0; i < 3; i++)
    {
        vec2 st = (gl_FragCoord.xy ) / u_resolution;
        float a = u_time;
        st.x += cos(st.x + u_time * 1.0) * 1.0;
        st = rotate2D(st, u_time);
        st += d;
        float square = step(st.x, 0.7 - sin(u_time) * 0.2);
        square *= step(0.3 + sin(u_time) * 0.2, st.x);
        square *= step(st.y, 0.7 + sin(u_time) * 0.2);
        square *= step(0.3 - sin(u_time * 1.0) * 0.2, st.y);
        d += 0.08;
        //square *= step( st.x, 0.9);
        gl_FragColor[i] = square;
    }
    gl_FragColor.a = 1.0;
}