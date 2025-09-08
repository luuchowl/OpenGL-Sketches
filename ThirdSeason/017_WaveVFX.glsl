#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,7118.233)))*
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
    st = st * 2.0 - 1.0;
    
    float d = length(st);
    float r = atan(st.y, st.x);

    float m_wave = 1.0 - smoothstep(d, sin(u_time) * 0.5 + 0.5, 0.7);
    float wave = pow(m_wave, 2.0);


    float n = noise(vec2(r  * 10.0 + d * 1., d * 6. + u_time));
    n = 1.0-smoothstep(n, .35, 0.4);
    wave += pow(m_wave, 5.) * n;
    gl_FragColor = vec4(vec3(wave), 1.0);


}