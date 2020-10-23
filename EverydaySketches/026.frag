

uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265359
#define TWO_PI 6.28318530718

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}
vec2 rotate2D(vec2 _st, float _angle){
    //_st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    //_st += 0.5;
    return _st;
}


void main()
{
    vec3 color;
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec2 _st = st;
    for(int i = 0; i < 2; i++)
    {
      vec2 st = gl_FragCoord.xy/u_resolution.xy;
      vec2 _st = st;
      st.x += 0.5* float(i);
      st.y += 0.25* float(i);
      float d = 0.0;
      st.y *= 2.0;
      st *= 7.0;

      float b = random(vec2(ceil(st.x), ceil(st.y )));

      st = fract(st);

      st.y *= 0.5;
      st.y += 0.25;
      //remap
      st = st * 2.0 -1.0;
      //st.y *= 2.0;

//      st = rotate2D(st, sin(-u_time * 4.0+ length(_st * 10.0)));


      int N = 6;
      float a = atan(st.x, st.y );
      float r = TWO_PI/float(N);

      d = cos(floor(0.5 + a/r ) * r - a) * length(st) ;

      float size = 0.3  + 0.1 * sin(-u_time * 4.0 + length(_st * 10.0));
      color += vec3(1.0 - smoothstep(size, size + 0.01, d)) * b;
    }


    //color.rgb = vec3(b);

    color.b = min(color.b, 0.5);
    color.r = min(sin(-u_time * 4.0 + length(_st * 10.0) + PI * 0.28) * 0.5 + 0.5, color.r);
    color.g = max(0.2, color.g);
    color.b = max(color.b, 0.2);

    gl_FragColor = vec4(color, 1.0);

}
