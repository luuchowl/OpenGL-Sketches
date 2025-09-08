
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define NUM_OF_PETALS 10.0

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

    float t =u_time * 2.0;
    //t = (sin(u_time * 3.0)*0.6  + cos(u_time * 2.0) * 0.6)*0.4;

    vec3 color = vec3(0.0);
    vec3 col2 = vec3(0.3294, 0.1961, 0.4471);
    vec3 col1 = vec3(0.8392, 0.2, 0.6275);
    vec3 col3 = vec3(0.5765, 0.051, 0.3843);

    float r = length(st);
    float a = atan(st.y, st.x) / 3.141592 / 2.0 + sin(-t + r) * r * (.03);

    float section = floor((a) * NUM_OF_PETALS);
    float ps = fract((a) * NUM_OF_PETALS);
    float n = noise(vec2(mod(section, NUM_OF_PETALS)) + t);

    float shade = step(ps, 0.5);

    float shape = step(r, 0.5 + abs(0.5 - ps) * 0.51 + sin(-t * 0.1 + 2.0) * 0.05);

    float shape2 = step(r, 0.35 + abs(0.5 - ps) * 0.33 + sin(-t * .2) * 0.01);

    
    float shape3 = step(r, 0.16 + abs(0.5 - ps) * 0.12 + sin(t * 0.1) * 0.1);

    vec3 shadow =vec3(1.0, 1.0, 1.0) * (mix(1.0, 0.9, n) * mix(1.0, 0.9, shade)) ;

    color = shape * mix(mix(col1, col2, 1.0- shape2), col3, shape3) + 1.-shadow*1.02;
    color += vec3(-0.1 * st.y, -0.10 * st.y-0.2, 0.2 * st.y);
    color *= shape + 0.;
    
    color.rb += 0.2 * (st.y / 2.0 + 0.5);
    //color.b += 0.01;
    gl_FragColor = vec4(color ,1.);
}
