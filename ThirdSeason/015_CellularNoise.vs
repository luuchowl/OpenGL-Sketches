#ifdef GL_ES
    precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;

float hash(float n)
{
    return fract(sin(n) * 43768.5453123);
}

float noise(vec2 st)
{
     vec2 i = floor(st);
    vec2 f = fract(st);

    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + i.y * 57.0 + 1.0);
    float c = hash(i.x + i.y * 57.0 + 57.0);
    float d = hash(i.x + i.y * 57.0 + 58.0);

    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;

}

//#define F o = min(o, length(fract(p *= mat2(7, -5, 5, 7)*.1) - .5)/.6)
#define f length(fract(p *= mat2(7, -5, 5, 7)*.1) - .5)

void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;
    st *= 1000.0;
    vec2 p = st/70.0 + u_time;

    mat2 m = mat2(7, -5, 5, 7) * 0.1;

    vec3 color = vec3(0.0);
    color = color - color + min(min(f, f), f)/.6;

    gl_FragColor = vec4(color, 1.0) ;

    
}