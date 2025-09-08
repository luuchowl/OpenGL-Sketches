
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;


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



void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy*2. -1.0;
    st.x *= u_resolution.x/u_resolution.y;

    vec3 color = vec3(0.0);
    vec3 col2 = vec3(0.3294, 0.1961, 0.4471);
    vec3 col1 = vec3(0.8392, 0.2, 0.6275);
    vec3 col3 = vec3(0.5765, 0.051, 0.3843);

    float r = length(st);
    float a = atan(st.y, st.x) / 3.1415 / 2.0 + sin(u_time + r) * r * .03;

    float section = floor((a) * 16.0);
    float ps = fract((a) * 16.0);
    float n = noise(vec2(section) + u_time);

    float shade = step(ps, 0.5);

    float shape = step(r, 0.5 + abs(0.5 - ps) * 0.51 + sin(-u_time * 0.1 + 2.0) * 0.05);

    float shape2 = step(r, 0.3 + abs(0.5 - ps) * 0.33 + sin(-u_time * 0.2) * 0.2);

    
    float shape3 = step(r, 0.10 + abs(0.5 - ps) * 0.12 + sin(u_time * 0.1) * 0.1);

    color = shape * mix(1.0, 0.9, n) * mix(1.0, 0.9, shade) * mix(mix(col1, col2, 1.0- shape2), col3, shape3);

    gl_FragColor = vec4(color ,1.);
}
