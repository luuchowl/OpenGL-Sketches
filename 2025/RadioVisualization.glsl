//001 Windshield Wiper
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

// 2D Random
float random (in vec2 st) {
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

float box(vec2 position, vec2 halfSize, float cornerRadius) {
   position = abs(position) - halfSize + cornerRadius;
   return length(max(position, 0.0)) + min(max(position.x, position.y), 0.0) - cornerRadius;
}

void main() {
    float amount = 10.0;
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec2 ust = st;
    st*= amount;
    st.x *= 5.0;
    st.y *= 10.0;
    
    vec2 coord = floor(st);
    st = fract(st);
    st *= 2.0;
    st -= 1.0;
    
    float shape = box(st, vec2(0.9, 0.8),0.4);
    shape = step(shape, 0.0);
    //st= clamp(st*1.2 - 1.1, 0.0, 1.0);
    //st.x = clamp(st.x, 0., 2.0);
    //st.x = clamp(st.x, 0.0, 1.0);
    //st*= 3.0;
    
    //st = fract(st);
    
    //float shape = distance(vec2(0.5, 0.5), st);

    //shape = step(shape, 0.3);
    float wobble = abs(10.0 * sin(u_time * 6.28)) * noise(vec2(coord.x * 0.6 + u_time))  + (sin(coord.x * 0.04 + u_time * 4.0 ) * 4. + cos(coord.x * 0.03 + u_time * 4.0 ) * 2. + 3.0 );
    float shape_color = step(coord.y * .2, wobble);
    


    vec3 color = mix(mix(vec3(0.3922, 0.5137, 0.1843), vec3(0.0118, 0.902, 0.949), ust.y), vec3(0.749, 0.0, 0.0), step(coord.y, 0.0));

    

    gl_FragColor = vec4(shape_color * shape * color, 1.0);
}