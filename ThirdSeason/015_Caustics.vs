#ifdef GL_ES
    precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;

#define f length(fract(p*=m*=.8+.01*d++)-.5)
#define C min(min(f,f),f)

void main()
{
    float t = u_time * 0.005;
    vec2 st = gl_FragCoord.xy / u_resolution;
    //st *= 10.0;
    
    vec3 color = vec3(0.0);
    
    float offset = 0.0;

    for(int i = 0; i < 3; i++)
    {
        vec2 p = st * 1.5;// + u_time;
        
        p += offset;
        p += 100.0;

        float d = -3., ct = cos(t), sint = sin(t);

        mat2 m = mat2(t, 2, -3, -t);

        vec3 caustics = vec3(C, C, C) ;
        
        float intensity = (pow(length(caustics), 5.0) * 3.4);
        color[i] = intensity;
        offset += float(i+1) * 0.050 * pow(intensity, 3.0);
        
    }

    //color = /// abs(.5 + .3* ct);
    //color = vec3(pow(length(color), 3.0) * 1.5);
    gl_FragColor = vec4(color, 1.0) ;

    
}