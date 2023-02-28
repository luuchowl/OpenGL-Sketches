#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution; 
uniform float u_time;

float invLerp (float a, float b, float v)
{
    return (v - a) / (b - a);
}

float shapeSphere(vec2 st, vec2 center, float radius, float time, float ctime)
{
    float sphere = distance(center, st);
    //return sphere = smoothstep(radius + 0.0000001, radius, sphere);
    return sphere = smoothstep(radius + ((time- ctime) * 155000.7 * clamp(dot(st-center, vec2(-1.0, 0.0)) +0.0001, 0.01, 1.0)) + 0.0000001, radius, sphere);
}

float quartic(float t)
{
    t *=  2.0;
    if(t < 1.0)
        return 0.5*pow(t, 4.0);
    t -= 2.0;
    return -0.5 * (pow(t, 8.0)- 2.0);
    
}

float shapeInOutSphere(float start, float end, float time, vec2 st, float expo)
{
    float clampTime = clamp(invLerp(start, end, time), 0.0, 1.0);
    float spheretime = clamp(invLerp(start, end, time), 0.0, 1.0);
    //spheretime = pow(spheretime, expo); 
    spheretime = quartic(spheretime); 
    //spheretime = mix(clampTime, spheretime, 1.5);

    vec2 center = vec2(spheretime - 0.5, 0.0) * 1.0 ;
    return shapeSphere(st, center, 0.05, spheretime, quartic(clampTime-0.000001));
}



void main()
{
    float time = u_time;
    vec2 st = gl_FragCoord.xy / u_resolution;
    st = st * 2.0 - 1.0;
    st.y -= 0.0;

    float duration = 4.0;
    
    time = mod(time, duration);

    float start = 1.0;
    float end = 3.0;
    
    float sphere12 = shapeInOutSphere(start, end, time, st + vec2(0.0, 0.0), 0.4);
    

    float shape = sphere12;
    gl_FragColor = vec4(vec3(shape), 1.0);
}