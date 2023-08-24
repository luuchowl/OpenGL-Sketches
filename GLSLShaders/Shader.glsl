#ifdef GL_ES
    precision mediump float;
#endif


uniform vec2 u_resolution; 
uniform float u_time;

//P : coordenada do pixel 0 ~ 1 
//r : raio
float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}


//p : coordenada
//b : bound
float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

vec2 rotate2d(vec2 st, float r)
{
    return vec2(
                -cos(r) * st.x + sin(r) * st.y,
                sin(r) * st.x + cos(r) * st.y);
}


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

void main()
{
    //uv;
    vec2 st = gl_FragCoord.xy/u_resolution;
    st -= 0.5;

    vec3 colorA = vec3(0.8, 0.4, 0.8);
    vec3 colorA2 = vec3(0.0, 0.1, 0.5);
    vec3 colorB = vec3(0.6, 0.6, 0.8);
    //st = rotate2d(st, u_time * 2.0);

    //==============PARTE 01 ======================

    //SDF do luuc
    vec2 circleOrigin = vec2(0.0, 0.0);
    float sphereSDF = distance(st.xy , circleOrigin);

    //SDF do Inigo
    vec2 starST = st;
    //starST.x -= sin(u_time);
    starST *= 0.6;
    starST = rotate2d(starST, u_time);
    //starST = fract(starST * 10.0);


    float shapeSDF = sdStar5(starST, 0.3,  0.4);

    //função step define uma forma
    float shape = step(shapeSDF, 0.0);


    //================= PARTE 02 ====================

    float radialSDF = distance(st, vec2(0.5, 0.5));  
    float horizontalSDF = st.x * 10.0;
    //float ripple = step(0.25, mod(horizontalSDF, 0.5));
    //float ripple = step(0.0, sin(horizontalSDF));
    float ripple = step(0.5, fract(horizontalSDF));
    
    //===============================================
    float boxSDF = sdBox(st, vec2(0.3, 0.3));
    float box = step(boxSDF, 0.0);

    //float unionSDF = mix(shapeSDF, boxSDF, sin(u_time) * 0.5 + 0.5);
    //float unionShape = step(unionSDF, 0.0);

    vec3 gradient = mix(colorA, colorA2, st.y);

    vec4 color = vec4(0.0, 0.0, 0.0, 1.0);

    color.rgb = mix(color.rgb, colorB, box);
    color.rgb = mix(color.rgb, gradient, shape);

    color.rgb = mix(color.rgb, gradient, u_time);
    //Output de cor
    gl_FragColor = color;
    
}