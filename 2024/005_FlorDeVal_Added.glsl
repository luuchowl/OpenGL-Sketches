
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define NUM_OF_PETALS 16.0

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
    vec2 st = gl_FragCoord.xy/u_resolution.xy*2. -1.0 ;
    st *= 0.6 + sin(u_time) * 0.2;
    st.x *= u_resolution.x/u_resolution.y;

    float t =u_time * 2.0;
    //t = (sin(u_time * 3.0)*0.6  + cos(u_time * 2.0) * 0.6)*0.4;

    vec3 color = vec3(0.0);
    vec3 col2 = vec3(0.6627, 0.3255, 0.098);
    vec3 col1 = vec3(0.1451, 0.1373, 0.2627);
    vec3 col3 = vec3(0.3333, 0.2471, 0.1255);
    vec3 col4 = vec3(0.4549, 0.498, 0.1725);
    
    vec3 col5 = vec3(0.4235, 0.2824, 0.1373);

    float r = length(st);
    float a = atan(st.y, st.x) / 3.141592 / 2.0 + sin(-t + r) * (.15);

    float section = floor((a) * NUM_OF_PETALS);
    float ps = fract((a) * NUM_OF_PETALS);
    float n = noise(vec2(mod(section, NUM_OF_PETALS)) + t * 0.4);

    float shade = step(ps, 0.5);

    float shape = step(r, 0.5 + abs(0.5 - ps) * 0.051 + sin(-t * 0.1 + 2.0) * 0.02);

    float shape2 = step(r, 0.38 + abs(0.5 - ps) * 0.04 + sin(-t * .2) * 0.01);

    
    float shape3 = step(r, 0.2 + abs(0.5 - ps) * 0.03 + sin(t * 0.1) * 0.05);

    float shape4 = step(r, 0.1 + abs(0.5 - ps) * 0.02 + sin(t * 0.1) * 0.05);
    float shape5 = step(r, 0.03 + abs(0.5 - ps) * 0.018 + sin(t * 0.1) * 0.05);

    vec3 shadow =vec3(1.0, 1.0, 0.9) * (mix(1.0, 0.9, n) * mix(1.0, 0.96, shade)) ;

    color = shape * mix(mix(mix(mix(col1, col2, 1.0- shape2), col3, shape3), col4, shape4), col5, shape5) + 1.-shadow*1.02;
    
    color *= shape + 0.;
    color += vec3(-0.1 * st.y, -0.10 * st.y-0.2, 0.2 * st.y) * 0.3;
    
    color += mix(vec3(0.2667, 0.102, 0.1961), vec3(0.4431, 0.1843, 0.1843), st.y) * (1.0 - shape);
    color *= mix(vec3(0.8941, 0.3255, 0.7412), vec3(0.0, 0.8157, 1.0), st.y) ;
    //color.gb += (0.5 * ((st.y + 0.4) / 2.0 + 0.5) * (1.0-shape)) * vec2(0.88, 1.0) + 0.1;
    //color.r += st.x * (1.0 - shape) * 0.3;
    //color.b += 0.01;
    color += color;
    gl_FragColor = vec4(color ,1.);
}
