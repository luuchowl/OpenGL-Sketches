#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define NUM_OCTAVES 10
#define PI 3.14159265

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
    float c = random(i + vec2(0.0, .5514));
    float d = random(i + vec2(10.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}



float fbm ( in vec2 _st) 
{
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    // Rotate to reduce axial bias
    float angle = 0.2;
    mat2 rot = mat2(cos(angle), sin(angle),
                    -sin(angle), cos(angle));
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise(_st);
        _st = rot * _st * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

vec2 rotate(vec2 uv, float angle)
{
    return vec2(cos(angle) * uv.x+ sin(angle) * uv.y,
                -sin(angle) * uv.x+ cos(angle) * uv.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy*3.;
    st.x *= u_resolution.x/u_resolution.y;

    float time = u_time * -1.1;
    st *= 4.0;
    
    st = rotate(st, PI/4.0);
    vec3 color = vec3(0.0);

    float f = fbm(st * 2.0);
    st = vec2(fbm(st ));
    st -= time * 0.2 ;
    float size = 0.5 ;
    
    for(int i = 0; i<10; i++)
    {
        st += f * size;
        f = fbm(st * 2.0);
    }    

    vec2 q = vec2(0.);
    q.x = fbm( st + 0.30*time);
    q.y = fbm( st + vec2(1.0));

    vec2 r = vec2(0.);
    r.x = fbm( st + 1.0*q + vec2(1.7,9.2)+ 0.45*time );
    r.y = fbm( st + 1.0*q + vec2(8.3,2.8)+ 0.426*time);

    //float f = fbm(st+r);
    f = fbm(st+f);

    color = mix(vec3(0.601961,0.619608,0.666667),
                vec3(0.349, 0.1765, 0.0588),
                clamp((f*f)*4.0,0.0,1.0));

    color = mix(color,
                vec3(0.2588, 0.2784, 0.1137),
                clamp(length(q),0.0,1.0));

    color = mix(color,
                vec3(0.2667, 0.2902, 0.1412),
                clamp(length(r.x),0.0,1.0));

    gl_FragColor = vec4((f*f*f+.6*f*f+.5*f)*color,1.);
}
