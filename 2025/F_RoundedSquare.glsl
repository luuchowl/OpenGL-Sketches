#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;

float sdRoundedBox( in vec2 p, in vec2 b, in vec4 r )
{
    r.xy = (p.x>0.0)?r.xy : r.zw;
    r.x  = (p.y>0.0)?r.x  : r.y;
    vec2 q = abs(p)-b+r.x;
    return min(max(q.x,q.y),0.0) + length(max(q,0.0)) - r.x;
}


void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;
    st *= 2.0;
    st -= 1.0;
    st *= 5.0;
    float mask = sdRoundedBox(st, vec2(1.0, 1.0), vec4(-0.5));
    gl_FragColor = vec4(st, step(mask, 1.0), 1.0);
}