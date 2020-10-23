
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265359

float line(float map, float value, float thickness, float smoothness)
{
  map = sin(map * PI * 2.0 + u_time)  * 0.5 + 0.5 ;
  float val1 = smoothstep(value + thickness * 0.5, value + thickness * 0.5 + smoothness, map);
  float val2 = smoothstep(value - thickness * 0.5, value - thickness * 0.5 - smoothness, map);
  //return smoothstep(-1.0, value + thickness * 0.5 + 0.5, map);
  //return cos(map * PI * 2.0)  * 0.5 + 0.5 ;

  return max(val2, val1);
}

vec2 rotate2D(vec2 _st, float _angle){
    //_st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    //_st += 0.5;
    return _st;
}

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


float spheredf(vec2 st, vec2 origin, float radius)
{
  return (distance(st, origin) - radius);
}

float opSmoothUnion( float d1, float d2, float k ) {
    float h = clamp( 0.5 + 0.5*(d2-d1)/k, 0.0, 1.0 );
    return mix( d2, d1, h ) - k*h*(1.0-h); }

void main()
{
    vec2 st = gl_FragCoord.xy/u_resolution.xy;

    vec2 _st = st;
    float n = noise(st * 10.0 + vec2(u_time, 0.0)) - 0.5;

    st *= 10.0;
    //st.y += u_time;
    vec2 st_real = floor(st);
    st = fract(st);
    st *= 2.0;
    st -= 1.0;


    float rotation = floor(random(st_real) * 4.0 ) / 2.0;
    //st = rotate2D(st, rotation * PI);
    st = rotate2D(st, (floor(st_real.x + st_real.y ) * PI * 0.5  ));






    float sphereA = mix(spheredf(st, vec2(-1.0, -1.0), 1.0),spheredf(st, vec2(-1.0, 1.0), 1.0), 0.0);
    float sphereB = mix(spheredf(st, vec2(1.0, 1.0), 1.0), spheredf(st, vec2(1.0, -1.0), 1.0), 0.0);

    float sphereC = spheredf(st, vec2(-1.0, 1.0), 1.0);
    float sphereD = spheredf(st, vec2(1.0, -1.0), 1.0);
    float sphereE = spheredf(st, vec2(1.0, 0.0), 0.05);
    float sphereF = spheredf(st, vec2(0.0, 1.0), 0.05);

    float lineA = line(sphereA, 0.0, 0.1 + 2.0 * (sin(st_real.y + u_time + st_real.x * 15.0) +n  ) , 0.05);
    float lineB = line(sphereB, 0.0, 0.1 + 3.0 * sin(st_real.x  + u_time + st_real.y * 34.0)  , 0.05);
    float lineC = line(sphereC, 0.0, 0.5, 0.05);
    float lineD = line(sphereD, 0.0, 0.1, 0.05);
    float lineE = line(sphereE, 0.0, 0.4, 0.05);
    float lineF = line(sphereF, 0.0, 0.4, 0.05);
    /*
    float lineC = line(sphereC, 0.0, -0.5, 0.0);
    float lineD = line(sphereD, 0.0, -0.5, 0.0);
    */
    float shape = min(min(lineA, lineC), lineE);
    float shape2 = min(lineA, lineB);
    float shape3 = min(min(lineA, lineF), lineE);
    vec4 col = vec4(vec3(shape), 1.0);
    if(random(st_real) < 1.0)
    {
        col = vec4(vec3(shape2), 1.0);
    }
    if(random(st_real) > 0.7)
    {
    //    col = vec4(vec3(shape3), 1.0);
    }
    //float shape = opSmoothUnion(float d1, float)
    //shape = rotation / 4.0;


    //col.r = max(col.r, 0.0);


    //col.b = max(col.b, 0.7);
        //color.g = max(color.g, 0.5);
    col.g = max(0.1, col.g);
        //color.r = max(color.r, 0.3);
        //color.g = (1.0-smoothstep(.5,.51,d));
    col.g = min(0.9,col.g);
    col.r = max(0.3, col.r);
    //col.r = min(0.7, col.r);
    //col.b = min(0.9, col.b);
  //  col.b = min(0.8, col.b);
  //  col.g = mix(col.g, _st.y + 0.2, 0.5);
  //  col.g = max(0.3, col.g);
    //col.g = min(0.6, col.g);
    //col.b *= 0.9;
    gl_FragColor =  col;

}
