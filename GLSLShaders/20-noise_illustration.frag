#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159

#define NUM_OCTAVES 5

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


void main(){
  vec2 st = gl_FragCoord.xy/u_resolution;
  st.x *= u_resolution.x/u_resolution.y;

  vec3 color = vec3(0.0);
  float d = 0.0;

  //Remap the space to -1 to 1;
  st = st * 5. -1.;
  vec2 st_starts = st * 8. -1.;
  vec2 i = floor(st_starts);
  vec2 fr = fract(st_starts);

  st_starts = fract(st_starts) - vec2(0.0, 0.0) -  vec2(1, 2) * random (i) ;

  //Make the distance field
  //d = length(abs(st) - .5);
  d = length(st_starts);
  d = length( min(abs(st_starts)-(.22 + abs(sin(u_time  + random(i + 2.) * PI)) * random(i) * 0.10),0.) );
  //d = length( max(abs(st),0.) );

  gl_FragColor = vec4(vec3(fract(d*50.0)), 1.0);
  gl_FragColor = vec4(vec3(fract(d*10.0)), 1.0);

  gl_FragColor = vec4(vec3( step(.3,d) * step(d,.4)),1.0);
  gl_FragColor = vec4(vec3( smoothstep(.3,.4,d)* smoothstep(.6,.5,d)) ,1.0);

  vec2 q = vec2(0.);
    q.x = fbm( st + 0.00*u_time);
    q.y = fbm( st + vec2(1.0));

    vec2 r = vec2(0.);
    r.x = fbm( st + 1.0*q + vec2(1.7,9.2)+ 0.15*u_time );
    r.y = fbm( st + 1.0*q + vec2(8.3,2.8)+ 0.126*u_time);

    float f = fbm(st+r);

    color = mix(vec3(0.101961,0.619608,0.366667),
                vec3(0.0,0.666667,0.498039),
                clamp((f*f)*4.0,0.0,1.0));

    color = mix(color,
                vec3(0,0,0.164706),
                clamp(length(q) ,0.0,1.0));

    color = mix(color,
                vec3(0.5,0.2,0.2),
                clamp(length(r.x),0.0,1.0));

             gl_FragColor += vec4((f*f*f+.6*f*f+.5*f)*color,1.) * vec4((f*f*f+.6*f*f+.5*f)*color,1.) * 5.;
}
