#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

void main()
{
    vec2 uv = gl_FragCoord.xy / u_resolution;
    

    uv *= 15.0;
    //uv.y += 0.4 * sin(uv.x * sin(u_time) + u_time);
    uv.y += 0.2 * sin((uv.x) + u_time * 0.1);
    uv.x += 2.5 * sin((uv.y + 0.4) + u_time * 0.2);
    uv.y += 0.2 * sin((uv.x) + u_time * -1.5);

    

    float shape = smoothstep( 0.2, 0.3, fract(uv.y)); 
    float shape2 = smoothstep( 0.9, 0.8, fract(uv.y)); 
    //float shape = max(smoothstep( 0.5, 0.6, fract(uv.y)), smoothstep( 0.5, 0.2, fract(uv.y))); 
    shape *= shape2;
    shape = 1.0 - shape;
    gl_FragColor = vec4(shape, shape, shape, 1.0);
}