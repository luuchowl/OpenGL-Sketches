#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define NUM_OCTAVES 10

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


float fbm ( in vec2 _st) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    // Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5), sin(0.5),
                    -sin(0.5), cos(0.50));
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise(_st);
        _st = rot * _st * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;


    st = st * 2.0 - vec2(1.0);
    //st.y += 1.0;
    st.y *= 1.0;

    //float a = atan(st.x, st.y) * TWO_PI / 2.0;
    //float r = TWO_PI/float(N);
    //float rad = length(st);

    //st = vec2(a, rad);
    //st += st * (sin(u_time*2.1)*3.0);


    vec3 color = vec3(0.0);

    float f = fbm(st * 2.0);
    st = vec2(fbm(st ));
    st -= u_time * 0.51 ;
    float size = 0.5 ;
    st += f * size;
    f = fbm(st * 2.0);

  st += f * size;
    f = fbm(st * 2.0);
    st += f * size;
    f = fbm(st * 2.0);
    st += f * size;
    f = fbm(st * 2.0);
    st += f * size;
    f = fbm(st * 2.0);
    st += f * size;
    f = fbm(st * 2.0);


    vec2 q = vec2(0.);
    q.x = fbm( st + 0.30*u_time);
    q.y = fbm( st + vec2(1.0));

    vec2 r = vec2(0.);
    r.x = fbm( st + 1.0*q + vec2(1.7,9.2)+ 0.45*u_time );
    r.y = fbm( st + 1.0*q + vec2(8.3,2.8)+ 0.426*u_time);

    //float f = fbm(st+r);
    f = fbm(st+f);


    color = mix(vec3(0.901961,0.819608,0.1066667),
                vec3(0.966667,0.966667,0.198039),
                clamp((f*f)*4.0,0.0,1.0));

    color = mix(color,
                vec3(0.9 * sin(u_time),0.5,0.364706),
                clamp(length(q),0.0,1.0));

    color = mix(color,
                vec3(0.36667, 0.3, 0.9),
                clamp(length(r.x),0.0,1.0));

    gl_FragColor = vec4((f*f*f+.6*f*f+.5*f)*color,1.);
    //gl_FragColor = vec4(vec3(f), 1.0);
}
