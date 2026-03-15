#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define LOOPS 35.0
#define LOOPSX 0.4
#define LOOPSB 3.3

vec2 rotate(vec2 st, float angle)
{
    return vec2(cos(angle) * st.x + sin(angle) * st.y, 
           sin(angle) * st.x - cos(angle) *st.y);
}

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
    return min(step(st.y, 0.6), step(st.x,size)) ; 
}

float circle(vec2 st, float size)
{
    return step(distance(st, vec2(0.5, 0.5)), 0.4-min(pow(size, 0.5), 0.4));
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st += noise(st + 14.94) * 0.5 - 0.3;
    //st += noise(st + u_time * 0.3) * 0.5 - 0.3;
    st *= 2.0;
    st -= 10.0;
    
    float d = distance(st, vec2(0., 0.)) ;
    
    float loopd = fract(d * LOOPS);
    float loopdi = floor(d * LOOPS);
    //vec2 rst = rotate(st, random(vec2(loopdi * 100.0) * 6.14) + u_time * loopdi * 0.005);
    vec2 rst = rotate(st, random(vec2(loopdi * 100.0) * 6.14) + u_time *3.0 / loopdi );
    float a = atan(rst.y, rst.x) / 3.14159265359; 
    

    float loopa = fract(a * loopdi *LOOPSX + random(vec2(loopdi, loopdi)));
    float loopda = floor(a * loopdi * LOOPSX + random(vec2(loopdi, loopdi))); //applied in size
    float mask = square(vec2(loopa, loopd), pow(random(vec2(loopdi, loopda)), 0.9));
    //float mask = square(vec2(loopa, loopd), 0.96);

    float loopb = fract(a * loopdi *LOOPSB + random(vec2(loopdi, loopdi)));
    float loopdb = floor(a * loopdi * LOOPSB + random(vec2(loopdi, loopdi)));
    float circlemask = circle(vec2(loopb, loopd), random(vec2(loopdi, loopdb)));

    gl_FragColor = vec4(d, mask, loopd, 1.0);
    //gl_FragColor = vec4(loopd,loopa, 0.0, 1.0);
    float brickID = random(vec2(loopdi, loopda));
    vec3 brickColor = mix(mix(vec3(0.1529, 0.1176, 0.0941), vec3(0.3922, 0.3294, 0.2667), brickID), vec3(0.1373, 0.1529, 0.1725), d);
   
    vec3 negativeColor = mix(vec3(0.0902, 0.0588, 0.1451), brickColor, mask) ;
    vec3 circlesColor = mix(negativeColor, mix(vec3(0.6118, 0.4196, 0.0863) * 1.9, vec3(0.1961, 0.0902, 0.2745), pow(d, 0.8)), circlemask);
    gl_FragColor = vec4(circlesColor , 1.0);
    //gl_FragColor = vec4(noise(st), 0.0, 0.0, 1.0);
}