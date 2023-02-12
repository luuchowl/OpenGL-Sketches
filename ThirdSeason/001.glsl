//This is a shader

#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

vec2 rotate(vec2 vector, float angle)
{
    return vec2(0.0, 0.0);
}

void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;

    st = st * 2.0 - vec2(1.0, 1.0);

    float polarDist = distance(st, vec2(0.0, 0.0))*10000000000000000. ;
    
    float angle = atan(st.y, st.x) / 3.14159256 * 2.5 + 2.5* sin(u_time) * sin(u_time)  ;

    vec2 polarCoord = vec2(sin(polarDist) , fract(angle));  

    float sphere = distance(polarCoord, vec2(sin(u_time), 0.5));    
    sphere = step(sphere, 0.2);

    float sphere2 = distance(polarCoord + vec2(0.050),vec2(sin(u_time + 0.), sin(u_time * 2.) * -.5 + .5));
    sphere2 = step(sphere2,0.2);

    float sphere3 = distance(st, vec2(0.0));
    gl_FragColor = vec4(vec3(sphere), 1.0);
    gl_FragColor.r += sphere2 * 0.99;
}