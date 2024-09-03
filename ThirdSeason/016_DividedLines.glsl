#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

//created a pseudo-random function
float random(float x)
{
    //return fract((x + 0.2) * 5114949.0122 /3.51239148 * x  );
    return fract(x + .5) * .9 + fract((x + 0.2) * 5114949.0122 /3.51239148 * fract(x)  ) * 0.9;
}

float quartic(float t)
{
    t *= 2.0;
    if(t < 1.0)
        return 0.5 *pow(t, 8.0);
    t -= 2.0;
    return -0.5 * (pow(t, 8.0) -2.0);
}

void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;
    float pulse = -pow(clamp(cos(u_time * 3.581 + st.y * 1.15), -0.0, 1.), 10.0) * 0.15;
    pulse -= pow(clamp(sin((u_time - 2.0 + st.y * 1.0) * 2.581), 0., 1.), 10.0) * 0.10;
    pulse -= pow(clamp(sin((u_time - 2.0 + st.y * 3.15) * 1.181), 0., 1.), 1.0) * 0.01;
    pulse += sin(u_time) * 0.32;
    pulse += cos(u_time *0.4) * 0.15;
    pulse *= 3.0; 
    st.x += (0.5 - st.x) * pow(distance(st.y , 0.5), 2.1 + pulse * 0.45 )  * (-27.0 + pulse  * 10.5 * pow((1.-distance(st.y , 0.5)), 3.));
    float n = 100.0;
    float x = floor(st.x * n) / n;
    float t = u_time * 0.2+ sin(u_time* 2.4 + random(x) * 3.141592) * 0.075;

    float linet = fract(t - random(x));
    float offset = fract(1.- st.y - quartic(linet) );
    float light = pow(offset, 0.8 + random(x) * 3.0);



    //vec3 color = mix(vec3(0.6, 0.5, 0.8), vec3(.02, 0.9, 0.9), sin(t * 4.0 + random(x * 30.) * 6.70)) *light;
    vec3 color = mix(vec3(0.9, 0.0, 0.4), vec3(.9, 0.54, 0.26), sin(t * 4.0 + random(x * 30.) * 6.70)) *light;
    color += vec3(0.145, 0.0, 0.03);
    gl_FragColor = vec4(color, 1.0);
}