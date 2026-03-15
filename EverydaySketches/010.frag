
#ifdef GL_ES
precision highp float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform float u_time;

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
    vec2 _st = st ;
    vec3 color = vec3(0.0);
    //st *= 10.0;
    st = fract(st);
    st = st *2.-1.0;
    st *= 0.7;

    float t = u_time;
    float phase = (sin(t + PI*0.25) >= 0.0) ? 1.0 : -1.0;
    st = rotate2D(st, cos(t) * PI * 1.0 ) ;

    st.x *= phase;


    //float m = noise((st * 10.0) + vec2(0.0, u_time));
    //float n = noise(floor(st * 5.0 + m * 0.0) + vec2(sin(u_time * 1.5) * 2.6, 0.0));
    //st.x += (n - 0.5) * cos(u_time * 5.0);
    //st.y += (n - 0.5) * sin(u_time * 2.0);

    //st.x += n * 1.0;


    color = vec3(0.4);
    float shape = smoothstep(.5,.501,distance(st, vec2(0,0)));
    float left = smoothstep(.25,.2501,distance(st, vec2(0.25,0)));
    float right = smoothstep(.25,.2501,distance(st, vec2(-0.25,0)));
    //float midLeft = smoothstep(fract(u_time)  + scilate(0.125, .25, 1.0, 0.0),oscilate(0.125, .25, 1.0, 0.0) + 0.001,distance(st, vec2(0.25,0)));
    float midLeft = smoothstep((-cos(mod(t + PI * 0.25, PI) ) + 1.0) * 0.5 * 0.25, (-cos(mod(u_time + PI * 0.25, PI) ) + 1.0) * 0.5  * 0.2501 ,distance(st, vec2(0.25,0)));
    float midRight = smoothstep((-cos(mod(t + PI * 0.25, PI) ) + 1.0) * 0.5 * 0.25, (-cos(mod(u_time + PI * 0.25, PI) ) + 1.0) * 0.5  * 0.2501 ,distance(st, vec2(-0.25,0)));
    //float midRight = smoothstep(oscilate(0.125, .25, 1.0, 0.0),oscilate(0.125, .25, 1.0, 0.0) + 0.001,distance(st, vec2(-0.25,0)));
    //float midRight = smoothstep(.125,.12501,distance(st, vec2(-0.25,0)));
    shape = shape;

    if(shape > 0.5)
    {
        //color = vec3(0.7137, 0.8745, 0.6078);
        color = vec3(0.3, 0.25, 0.3);
        color *= 0.8;
        color.g = min(color.g, _st.y);
    }
    else{
      color.r = (ceil(st.y));
      color.r = max(1.0-left, color.r);
      color.r = min(right, color.r);
      color.r = min(color.r, midLeft);
      color.r = max(color.r, 1.0-midRight);


      color.b = max(color.b, 0.9);
      //color.g = max(color.g, 0.5);
      color.g = max(0.4, color.r);
      //color.r = max(color.r, 0.3);
      //color.g = (1.0-smoothstep(.5,.51,d));
      color.g = min(0.8,color.g);
      color.r = max(_st.y, color.r);
      //color.g = min(color.g, 0.50);
      //color.b *= 0.7;
      //color.r = max(0.7, color.r);
    }




    //color.r = min(color.r,(1.0-smoothstep(.9,.91,d)));
    //color = vec3 ( 1.0-smoothstep(f, f+0.02, r));
    //color = vec3(f) ;

    gl_FragColor = vec4 (color, 1.0);
    //gl_FragColor = vec4(st, 0.0, 1.0);
}
