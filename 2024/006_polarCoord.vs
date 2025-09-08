#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

vec2 rotate(vec2 i, float angle)
{
    return vec2( cos(angle) * i.x + sin(angle) * i.y,
           sin(angle) * i.x - cos(angle) * i.y);
}

void main()
{
  vec2 uv = gl_FragCoord.xy / u_resolution;
  uv *= 2.0;
  uv -= 1.0;
  uv = rotate(uv, u_time);
  vec2 p;
  //p -= 1.0;
  //float threshold = step(p.x, .0);
  gl_FragColor = vec4(mix(vec3(1.0), vec3(0.0), smoothstep(-0.7, -0.8, uv.x)), 1.0);
}
