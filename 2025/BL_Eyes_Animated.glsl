#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define LOOPS 35.0
#define LOOPSX 0.4
#define LOOPSB 3.3

float invLerp (float a, float b, float v)
{
    return (v - a) / (b - a);
}

vec2 rotate(vec2 st, float angle)
{
    return vec2(cos(angle) * st.x + sin(angle) * st.y, 
           sin(angle) * st.x - cos(angle) *st.y);
}

// 2D Random
float random (in vec2 st) 
{
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

float quartic(float t)
{
    t *=  2.0;
    if(t < 1.0)
        return 0.5*pow(t, 4.0);
    t -= 2.0;
     return -0.5 * (pow(t, 8.0)- 2.0);
    
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

float square(vec2 st, float size)
{
    return min(step(st.y, 0.6), step(st.x,size)) ; 
}

float circle(vec2 st, float size)
{
    return step(distance(st, vec2(0.5, 0.5)), size);
}

float sdSegment( in vec2 p, in vec2 a, in vec2 b )
{
    vec2 pa = p-a, ba = b-a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h );
}
float dot2( vec2 v ) { return dot(v,v); }

float sdBezier( in vec2 pos, in vec2 A, in vec2 B, in vec2 C )
{    
    vec2 a = B - A;
    vec2 b = A - 2.0*B + C;
    vec2 c = a * 2.0;
    vec2 d = A - pos;
    float kk = 1.0/dot(b,b);
    float kx = kk * dot(a,b);
    float ky = kk * (2.0*dot(a,a)+dot(d,b)) / 3.0;
    float kz = kk * dot(d,a);      
    float res = 0.0;
    float p = ky - kx*kx;
    float p3 = p*p*p;
    float q = kx*(2.0*kx*kx-3.0*ky) + kz;
    float h = q*q + 4.0*p3;
    if( h >= 0.0) 
    { 
        h = sqrt(h);
        vec2 x = (vec2(h,-h)-q)/2.0;
        vec2 uv = sign(x)*pow(abs(x), vec2(1.0/3.0));
        float t = clamp( uv.x+uv.y-kx, 0.0, 1.0 );
        res = dot2(d + (c + b*t)*t);
    }
    else
    {
        float z = sqrt(-p);
        float v = acos( q/(p*z*2.0) ) / 3.0;
        float m = cos(v);
        float n = sin(v)*1.732050808;
        vec3  t = clamp(vec3(m+m,-n-m,n-m)*z-kx,0.0,1.0);
        res = min( dot2(d+(c+b*t.x)*t.x),
                   dot2(d+(c+b*t.y)*t.y) );
        // the third root cannot be the closest
        // res = min(res,dot2(d+(c+b*t.z)*t.z));
    }
    return sqrt( res );
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    float d = distance(st.x, 0.5);

    float time = u_time;
    float duration = 4.0;
    
    time = mod(time * 2.0, duration);
    
    float start = 1.8;
    float end = 2.2;

    float nTime = clamp(invLerp(start, end, time), 0.0, 1.0);
    nTime = quartic(nTime * 1.0);

    // ---- Properties
    vec3 bgColor = vec3(0.7255, 0.6784, 0.5255);
    float stage = nTime; 

    // Eye
    float eyeSize = 0.2;
    float eyeThickness = 0.05;
    vec3 eyeBgColor = vec3(0.5451, 0.5686, 0.6039);
    vec3 eyelashColor = vec3(0.2, 0.3922, 0.4745);
    vec3 outlineColor = vec3(0.451, 0.4745, 0.4824);
    float outlineSize = 0.02;
    float eyeBend = 0.1;

    //vec2 pupil_st = vec2(mix(0.1, -0.04, stage), -0.1);//-0.06 + sin(u_time) * -0.05);
    float pupil_time = u_time *1.0;
    float pupil_time_t = fract(pupil_time);
    vec2 coord = mix( 
        vec2(random(vec2(floor(pupil_time))), random(vec2(floor(pupil_time + 10.0)))) * 2.0 - 1.0, 
        vec2(random(vec2(floor(pupil_time + 1.0))), random(vec2(floor(pupil_time + 11.0))))* 2.0 - 1.0, 
        quartic(pupil_time_t)
                );
    //vec2 pupil_st = vec2((random(vec2(floor(u_time)))* 2.0 - 1.0) * 0.2, (random(vec2(floor(u_time)))* 2.0 - 1.0) * 0.05);
    vec2 pupil_st = coord * vec2(0.2, 0.05) + vec2(0., -0.05);
    float pupilSize = mix(.1, 0.03, stage);
    vec3 pupilColor = vec3(0.4);

    // Eyebrows 
    vec3 browColor = vec3(0.2627, 0.2627, 0.2627);
    float eyebrowThickness = 0.03;
    float browSize = mix(0.3, 0.1, stage);
    float browBend = mix(0.1, -0.1, stage);
    float browAngle = mix(0.0, 0.2, stage);
    vec2 eyebrowOffset = vec2(mix(0.0, 0.08, stage), 0.3);
   
    // ---- Logic 

    // Shape
    float circleShape = distance(vec2(0.5), st) -0.13;
    float line = sdBezier(st, vec2(0.5 - eyeSize, 0.5), vec2(0.5, 0.5+eyeBend), vec2(0.5 + eyeSize, 0.5));
    
    //line = mix(line, circleShape, sin(u_time) * 0.5 + 0.5);
    line = mix(line, circleShape, stage);
    
    float outline = step(line, eyeThickness + outlineSize);
    line = step(line, eyeThickness);    

    vec2 brow_st = rotate(st- (vec2(0.5)+eyebrowOffset), browAngle)+(vec2(0.5)+eyebrowOffset);
    //brow_st = st;
    float eyebrow = sdBezier(brow_st - eyebrowOffset, vec2(0.5 - browSize, 0.5), vec2(0.5, 0.5 - browBend), vec2(0.5 + browSize, 0.5));
    eyebrow = step(eyebrow, eyebrowThickness);
    // Color
    float pupil = circle(st + pupil_st , pupilSize);
    
    vec3 finalColor = mix(bgColor, outlineColor, outline);
    vec3 eyeFinalColor = mix(eyeBgColor, pupilColor, pupil);
    vec3 finalColor1 = mix(finalColor,eyeFinalColor , line);
    vec3 finalColor2 = mix(finalColor1, browColor, eyebrow);
    gl_FragColor = vec4(finalColor2, 1.0);
    //gl_FragColor = vec4(eyebrow);
}