#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

//created a pseudo-random function
float random(float x)
{
    //return fract((x + 0.2) * 5114949.0122 /3.51239148 * x  );
    return fract(x + .5) * .9 + fract((x + 0.2) * 5114949.0122 /3.51239148 * fract(x)  ) * 0.9;
}

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        4371258.5453123);
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
    st *= 2.0;
    st -= 1.0;
    st.x *= u_resolution.x / u_resolution.y;

    vec2 pst;
    pst.x = length(st);
    pst.y = atan(st.y, st.x) / 3.14159265;

    float sphere = step(0.5, pst.x);

    float stripe_offset = random(floor(pst.y * 10.0) + 0.2);
    float st_stripes = fract(pst.y * 10.0);
    float stripes = step(0.2,st_stripes);
    stripes *= step(0.1 + stripe_offset * -0.02, pst.x);
    stripes *= step(pst.x, 0.9 + stripe_offset * -0.1 );


    float n = noise(gl_FragCoord.xy / u_resolution * 52.0);
    gl_FragColor = vec4(vec3(n), 1.0);

}