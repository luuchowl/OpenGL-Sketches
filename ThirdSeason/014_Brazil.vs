#ifdef GL_ES 
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

//cellular noise from : https://www.shadertoy.com/view/XsVSDm
#define f length(fract(p*=m*=.8+.01*d++)-.5)
#define C min(min(f,f),f)

void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;
    st.x *= u_resolution.x/u_resolution.y;

    float wt = u_time * 3.0;
    float wf = 9.0; //Frequency
    float ws = 0.025 ; //Size
    float wh = 0.46;

    float globeMask = distance(st, vec2(0.5));
    
    
    globeMask = step(globeMask,0.3);


    float globeColor = distance(st, vec2(0.5));
    globeColor = pow(globeColor * 3.0, 15.0);


    float wave01 = st.y + sin(st.x * wf + wt) * ws;
    float wave01M = step(wave01, wh);
    wave01 = wave01 *= globeMask;


    float wave02 = st.y + sin((st.x + 0.15 ) * wf - wt) * ws;
    float wave02M = step(wave02, wh);
    wave02 = wave02 * globeMask;

    st*= 1.0;

    float t = u_time * 0.003;
    vec3 color = vec3(0.0);
    
    float offset = 0.0;

    for(int i = 0; i < 3; i++)
    {
        vec2 p = st * 0.2;// + u_time;
        p += 100.0;
        p += pow(distance(st, vec2(0.5)) * 1.2, 1.2) * (st - vec2(0.5)) * 10.0;
        p += offset;
        float d = -3.;
        mat2 m = mat2(t, 2, -3, -t);
        vec3 caustics = vec3(C, C, C) ;  
        float intensity = (pow(length(caustics), 4.0) * 2.8);
        color[i] = intensity;
        offset += float(i+1) * 0.010 * pow(intensity, 3.0);
    }

    vec3 colorFloor = vec3(0.0);
    float tbg = u_time * 0.0005;
    offset = 0.0;
    for(int i = 0; i < 3; i++)
    {
        vec2 p = st * 0.1;// + u_time;
        p += 100.0;
        //p.x = p.x + (0.5 - st.x) * 2.0 + st.y;
        
        //p += pow(distance(st, vec2(0.5)) * 1.2, 1.2) * (st - vec2(0.5)) * 10.0;
        p += offset;
        p.x = p.x + 1.0 - (0.5 - st.x) * 3.0 * ( st.y * 3.2 + 0.5 ) * pow(1.0-distance(0.5, st.x), 0.90);
        p.y *= 20.1;
        float d = -3.;
        mat2 m = mat2(tbg, 2, -3, tbg * -1.);
        vec3 caustics = vec3(C, C, C) ;  
        float intensity = (pow(length(caustics), 5.0) * 4.8);
        colorFloor[i] = intensity;
        offset += float(i+1) * 0.001 * pow(intensity, 2.0);
    }


    //color = /// abs(.5 + .3* ct);
    //color = vec3(pow(length(color), 3.0) * 1.5);
    float reds = color.r - pow(length(color.b), 2.0);
    color *=  mix(vec3(0.0, 0.8, 0.9), color, length(color));
    color *=  vec3(0.2, 0.8, 0.9);
    color.r += clamp(pow(reds, 3.0), 0.0, 1.0);
    color += vec3(0.00, 0.3, 0.4);
    color *= mix(1.0, pow(wave01 + 0.55, 30.0) * 1.3 + 0.4, wave01M);

    float redf = colorFloor.r - pow(length(colorFloor.b), 2.0);
    colorFloor *=  mix(vec3(0.0, 0.8, 0.9), colorFloor, length(colorFloor));
    //colorFloor *=  vec3(0.2, 0.8, 0.9);
    //colorFloor.r += clamp(pow(redf, 3.0), 0.0, 1.0);
    colorFloor += vec3(0.00, 0.3, 0.4) * 0.3;
    
    vec3 outColor = vec3(0.0);

    outColor = mix(outColor, vec3(0.0, 0.05, 0.1), globeMask);
    outColor = mix(outColor, color * 0.1, max(globeMask, wave01M));
    
    outColor = mix(outColor, vec3(0.3, 0.8, 95.0) * (pow(wave02 + 0.55, 20.0)+0.5), wave02M );

    outColor = mix(outColor, color, wave01M);
    
    //outColor = color;
    //outColor = mix(outColor, color, wave01);

    colorFloor = mix(vec3(0.), colorFloor, max(smoothstep( 0.51, 0.0, st.y), globeMask) );
    outColor = mix(colorFloor, outColor, globeMask);

    //outColor = mix(outColor, color, wave01);

    outColor += globeMask *  globeColor;
    

        //outColor = color;
    gl_FragColor = vec4(outColor, 1.0);


}
