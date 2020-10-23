
#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform float u_time;

float oscilate(float min, float max, float speed, float offset)
{
  float sine = sin(u_time * speed + offset);
  return min + (max-min) * (sine) ;
}

vec2 rotate2D(vec2 _st, float _angle){
    //_st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    //_st += 0.5;
    return _st;
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;
    vec2 _st = st;
    vec3 color = vec3(0.0);
    st *= 10.0;
    st.x += (u_time) * (mod(ceil(_st.y * 10.0), 2.0) - 0.5) * 2.0 ;
    st = fract(st);
    st = st *2.-1.0;
    st = rotate2D(st,  sin(ceil(_st.y * 10.0) * TWO_PI * 1.0 ) );
    int N = 3;

    //st *= oscilate(1.0, 1.5, 3.0,oscilate(1.5, 1.9, 1.0, 0.0));
    st *= oscilate(1.0, 1.5, 3.0, 0.0);
    st *= oscilate(0.9, 1.5, 5.0, ceil(_st.y * 10.0));



    //float r = length(st) * 3.0;

    float a = atan(st.x, st.y);
    float r = TWO_PI / float(N);

    float d = cos(floor(.5+a/r)*r-a)*length(st);

    float f = cos(a*4.);
    f = a * 0.2 * a;
    f =  fract(a*3.141592 * 0.2);
    f = sin(a * 5.0);
    //f = floor(sin(a * 10.0));

    //f+=  fract(-a*3.141592 * 0.2);

    //f = (a * 5.0);


    color = vec3(1.0-smoothstep(.4,.41,d));
//color.g = (1.0-smoothstep(.5,.51,d));
    //color.g = min(0.3,color.g);
    color.b = min(_st.y, color.b);

    color.g = min(color.g, 0.40);
    //color.b *= 0.7;
    color.r = max(0.7, color.r);


    color.r = min(color.r,(1.0-smoothstep(.9,.91,d)));
    //color = vec3 ( 1.0-smoothstep(f, f+0.02, r));
    //color = vec3(f) ;

    gl_FragColor = vec4 (color, 1.0);
    //gl_FragColor = vec4(st, 0.0, 1.0);
}
