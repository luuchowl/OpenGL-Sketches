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

float sdSegment( in vec2 p, in vec2 a, in vec2 b )
{
    vec2 pa = p-a, ba = b-a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h );
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    gl_FragColor = vec4(st, 0.0, 1.0);
}