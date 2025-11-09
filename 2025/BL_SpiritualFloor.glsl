#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define LOOPS 30.0
#define LOOPSX 10.0

// 2D Random
float random (in vec2 st) 
{
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float square(vec2 st, float size)
{
    return min(step(st.y, 0.4), step(st.x,size)) ; 
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st += noise(st + 14.94) * 0.5 - 0.3;
    st *= 2.0;
    st -= 1.0;
    
    
    float d = distance(st, vec2(0., 0.)) ;
    
    float loopd = fract(d * LOOPS);
    float loopdi = floor(d * LOOPS);

    float a = atan(st.y, st.x) / 3.14159265359 + u_time * loopdi / 1000.;

    float loopa = fract(a * loopdi * 0.4 + random(vec2(loopdi, loopdi)));
    float loopda = floor(a * loopdi * 0.4 + random(vec2(loopdi, loopdi))); //applied in size
    float mask = square(vec2(loopa, loopd), pow(random(vec2(loopdi, loopda)), 4.0));
    //float mask = square(vec2(loopa, loopd), 0.96);

    gl_FragColor = vec4(d, mask, loopd, 1.0);
    //gl_FragColor = vec4(loopd,loopa, 0.0, 1.0);
    gl_FragColor = vec4(mix(vec3(0.0902, 0.0588, 0.1451), vec3(0.3647, 0.3059, 0.2039), mask), 1.0);
    //gl_FragColor = vec4(noise(st), 0.0, 0.0, 1.0);
}