#ifdef GL_ES
    precision mediump float;
#endif

vec2 u_resolution;
float u_time;

void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;
    float d = distance(st, vec2(0.5, 0.5));
    gl_FragColor = vec4(0.4, 0.9, 0.8, 1.0);
}