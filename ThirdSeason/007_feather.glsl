//This is a shader

#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;

#define PI 3.14159265359
#define TWO_PI 6.28318530718


float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}


void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;
    st -= vec2(0.5);
    
    st.y -= 0.1;

    float feathers = 0.0;
    float a = st.y; 
    a -= 0.7;
    feathers = sin((a * a + abs(st.x)) * 500.0);
    
    vec2 fc = st
    fc.y *= 0.27;
    float d = distance(fc, vec2(0.0, 0.0));
    d = step(d, 0.1);

    vec2 tc = st;
    tc.y *= 0.23;
    tc.y += 0.015;
    tc.x *= 20.25;
    float td = distance(tc, vec2(0.0, 0.0));
    td = step(td, 0.1);

    float f = 0.0; 
    float offset = 0.0;
    for(float i = 0.0; i < 5.0; i++)
    {
        vec2 sc = st;
        sc.y -= offset;  
        sc.y *= 0.27;
        float sd = distance(sc, vec2(0.0, 0.0));
        sd = step(sd, 0.1);

        //f = max(1.0-sd, f);
        offset += 0.02;
    }

    gl_FragColor = vec4(f, td ,d, 1.0);
}