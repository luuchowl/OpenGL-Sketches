#ifdef GL_ES
    precision mediump float; 
#endif

uniform vec2 u_resolution;
uniform float u_time;

vec2 r2d(in vec2 p, float d )
{
    return vec2(-cos(d) * p.x + sin(d) * p.y,
            sin(d) * p.x + cos(d) * p.y);
}

void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution;

    st *= 1.2;
    st -= 0.1;

  

    vec3 finalCol = vec3(0.0);
    float t = u_time * 1.5 - 10.0  + sin(u_time *1.6) * 0.5;

    for(int i = 0; i<3; i++)
    {
    vec2 st2 =  st * 2.0 - 1.0 + 0.05 * float(i);

    vec2 st3 = st + sin(st2) * 0.2;
      float sphereSDF = distance(vec2(0.5), st3);
    float sphere = smoothstep(0.51 + sin(u_time) * 0.1, 0.40, sphereSDF);
    

    st2 = r2d(st2, t * sin(st.x + st.y));
    float noise = sin(st2.x * 1.0 + st2.y * 10.0 + st2.x *  st2.y * 30.0 );
    noise += cos(st2.y * 100.0 + st2.x * 20.0);
    noise += sin(st2.y * 5.);
    noise += cos(noise + t * 5.);


    //finalCol += sphere * mix( vec3(0.3, 0.0, 0.3), vec3(0.7, 0.0, 0.0), pow( smoothstep(0.0, 0.4, sphereSDF), 3.0));

    finalCol[i] = finalCol[i] + sphere * mix( 0.3, 1.0, pow( smoothstep(0.0, 0.4, sphereSDF), 3.0));
    //finalCol.rb *= vec2(mix(vec3(0.1), vec3(0.5), noise));

    //finalCol[i] *= mix(vec3(0.1), vec3(0.5), noise);

    finalCol[i] *=  noise * 1.0;

    finalCol[i] +=  noise * 0.01;
    //finalCol.rg *= 1.0;
    }
    //finalCol.r = noise;
    //finalCol *=  mix(vec3(0.9, 0.6, 0.31), vec3(1.8, 0.9, 0.451), length(st));
    finalCol +=  mix(vec3(0.9, 0.6, 0.31), vec3(1.8, 0.9, 0.451), length(st));
    gl_FragColor = vec4(finalCol, 1.0);
}