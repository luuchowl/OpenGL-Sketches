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

#define NUM_OCTAVES 4

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


void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;

    float t = u_time * 3.0;
    float wf = 10.0; //Frequency
    float ws = 0.03 ; //Size
    float wh = 0.46;

    float globeMask = distance(st, vec2(0.5));
    
    
    globeMask = step(globeMask,0.3);


    float globeColor = distance(st, vec2(0.5));
    globeColor = pow(globeColor * 3.0, 15.0);


    float wave01 = step(st.y + sin(st.x * wf + t) * ws, wh);
    wave01 = wave01 *= globeMask;

    float wave02 = step(st.y + sin((st.x + 0.15 ) * wf - t) * ws, wh);
    wave02 = wave02 * globeMask;

    st*= 10.0;

    vec3 color = vec3(0.0);

    vec2 q = vec2(0.);
    q.x = fbm( st + 0.00*u_time);
    q.y = fbm( st + vec2(1.0));

    vec2 r = vec2(0.);
    r.x = fbm( st + 51000.0*q + vec2(1.7,9.2)+ 10000.15*u_time );
    r.y = fbm( st + 1.0*q + vec2(8.3,2.8)+ 0.126*u_time);

    float f = fbm(st+r);

    color = mix(vec3(0.101961,0.2,0.4),
                vec3(0.3,0.2,0.498039),
                clamp((f*f)*4.0,0.0,1.0));

    color = mix(color,
                vec3(0,0,0.164706),
                clamp(length(q),0.0,1.0));

    color = mix(color,
                vec3(0.10667,1,1),
                clamp(length(r.x),0.0,1.0));

    vec3 outColor = vec3(0.0);

    
    outColor = mix(outColor, vec3(0.54, 0.7, 0.9), wave02);

    //outColor = mix(outColor, vec3(0.2, 0.2, 0.7), wave01);
    outColor = mix(outColor, color, wave01);
    outColor += globeMask *  globeColor;
    

    //outColor = color;
    gl_FragColor = vec4(outColor, 1.0);


}
