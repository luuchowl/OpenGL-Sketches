#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float diamond(vec2 st)
{
    return step(abs(st.x) + abs(st.y), 0.7);
}

float sphere(vec2 st)
{
    return step(length(st * 0.8), 0.3);
}

float arc(vec2 st)
{
    st *= 0.8;
    st.y *= mix(2.0, 1.5, abs(pow(abs(st.x), 1.)) );
    st.y += 0.1;
    float val1 = step(length(st), 0.3);
    st.y += 0.14 + sin(u_time  * 2.0) * 0.05;

    float val2 = step(length(st), 0.3);


    return min(val1 , 1.0-val2);
}

//thanks iq
float sdStar5(in vec2 p, in float r, in float rf)
{
    const vec2 k1 = vec2(0.809016994375, -0.587785252292);
    const vec2 k2 = vec2(-k1.x,k1.y);
    p.x = abs(p.x);
    p -= 2.0*max(dot(k1,p),0.0)*k1;
    p -= 2.0*max(dot(k2,p),0.0)*k2;
    p.x = abs(p.x);
    p.y -= r;
    vec2 ba = rf*vec2(-k1.y,k1.x) - vec2(0,1);
    float h = clamp( dot(p,ba)/dot(ba,ba), 0.0, r );
    return length(p-ba*h) * sign(p.y*ba.x-p.x*ba.y);
}

vec2 rotate2d(vec2 st, float d)
{
    return vec2(-cos(d) *st.x + sin(d) * st.y, 
            sin(d) * st.x + cos(d) * st.y);
}

void main()
{
    float time = u_time + sin(u_time * 2.0) * 0.5 + cos(u_time * 2.5) * 0.1;


    vec2 st = gl_FragCoord.xy/u_resolution;
    st = st * 2.0 - 1.0;
    
    
    st = rotate2d(st, sin(time * 0.2 + 22.0) * length(st) * 1.0);
    //st += st * floor(sin(u_time) + 1.1 );
    st.y += sin(-0.5 + time + -abs(pow(st.x * 1.5, 3.0))) * 0.27;
    st.y -= sin(time + -abs(pow(st.x * 1.0, 3.0))) * 0.1;

    vec2 st2 = (st * 1.3);

    vec3 color = mix(vec3(0.06, 0.3, 0.2) , vec3(0.06, 0.0, 0.12), clamp((abs(st2.x) + abs(st2.y)) * 0.33, 0.0, 1.0)) ;

    
    vec3 colorB = mix(vec3(7.0, 0.7, 0.1), vec3(0.7, 0.7, .1), pow(length(st), 2.0));
    vec3 colorC = mix(vec3(0.1, 0.1, 0.5), vec3(0.1, 02, 3), pow(length(st), 2.3));
    vec3 colorD = vec3(1.7, 1.7, 1.7);

    color = mix(color, colorB, diamond(st));
    color = mix(color, colorC, sphere(st));
    color = mix(color, colorD, arc(st));
    
    color = mix(color, colorD, step(sdStar5(st - 0.2, 0.05, 0.3),0.0));
    color = mix(color, colorD, step(sdStar5(st - vec2(-0.2, 0.2) , 0.05, 0.3),0.0));

    color.b = min(color.b, 0.5);
    color.r = min(color.r, 0.8);
    color += 0.2;

    gl_FragColor = vec4(color, 1.0);
}