#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution; 
uniform float u_time;

float invLerp (float a, float b, float v)
{
    return (v - a) / (b - a);
}

float shapeSphere(vec2 st, vec2 center, float radius)
{
    float sphere = distance(center, st);
    return sphere = step(sphere, radius);
}

float shapeEasingSphere(float start, float end, float time, vec2 st, float expo)
{
    float spheretime = clamp(invLerp(start, end, time), 0.0, 1.0);
    spheretime = pow(spheretime, expo); 

    vec2 center = vec2(spheretime - 0.5, 0.0) * 1.0 ;
    return shapeSphere(st, center, 0.05);
}


float sininout(float t, float b, float c, float d)
{
    return -c/2.0 * (cos(3.14159265*t/d) - 1.0) + b;
}

float quartic(float t)
{
    t *=  2.0;
    if(t < 1.0)
        return 0.5*pow(t, 4.0);
    t -= 2.0;
    return 0.5 * (pow(t, 8.0)- 2.0);
    
}


float shapeSinSphere(float start, float end, float time, vec2 st, float expo)
{
    float clampTime = clamp(invLerp(start, end, time), 0.0, 1.0);
    float spheretime = clamp(invLerp(start, end, time), 0.0, 1.0);
    //spheretime = pow(spheretime, expo); 
    spheretime = sininout(spheretime, 0.0, 1.0, 1.0); 
    //spheretime = mix(clampTime, spheretime, 1.5);

    vec2 center = vec2(spheretime - 0.5, 0.0) * 1.0 ;
    return shapeSphere(st, center, 0.05);
}

float shapeInOutSphere(float start, float end, float time, vec2 st, float expo)
{
    float clampTime = clamp(invLerp(start, end, time), 0.0, 1.0);
    float spheretime = clamp(invLerp(start, end, time), 0.0, 1.0);
    //spheretime = pow(spheretime, expo); 
    spheretime = quartic(spheretime); 
    //spheretime = mix(clampTime, spheretime, 1.5);

    vec2 center = vec2(spheretime - 0.5, 0.0) * 1.0 ;
    return shapeSphere(st, center, 0.05);
}



void main()
{
    float time = u_time;
    vec2 st = gl_FragCoord.xy / u_resolution;
    st = st * 2.0 - 1.0;
    st.y -= 0.7;

    float duration = 4.0;
    
    time = mod(time, duration);

    float start = 1.0;
    float end = 3.0;
    
    float sphere = shapeEasingSphere(start, end, time, st, 0.20);
    float sphere2 = shapeEasingSphere(start, end, time, st + vec2(0.0, 0.20), 0.5);
    float sphere3 = shapeEasingSphere(start, end, time, st + vec2(0.0, 0.40), 1.0);
    float sphere4 = shapeEasingSphere(start, end, time, st + vec2(0.0, 0.60), 2.0);
    float sphere5 = shapeEasingSphere(start, end, time, st + vec2(0.0, 0.80), 5.0);
    float sphere6 = shapeEasingSphere(start, end, time, st + vec2(0.0, 1.0), 10.0);
    float sphere7 = shapeSinSphere(start, end, time, st + vec2(0.0, 1.2), 0.4);
    float sphere8 = shapeInOutSphere(start, end, time, st + vec2(0.0, 1.4), 0.4);
    float sphere9 = shapeSinSphere(start, end, time, st + vec2(0.0, 1.2), 0.4);
    float sphere10 = shapeInOutSphere(start, end, time, st + vec2(0.0, 1.4), 0.4);
    float sphere11 = shapeSinSphere(start, end, time, st + vec2(0.0, 1.2), 0.4);
    float sphere12 = shapeInOutSphere(start, end, time, st + vec2(0.0, 1.4), 0.4);
    

    float shape = sphere + sphere2 + sphere3 + sphere4 + sphere5 + sphere6 + sphere7 + sphere8 + sphere9 + sphere10 + sphere11 + sphere12;
    gl_FragColor = vec4(vec3(shape), 1.0);
}