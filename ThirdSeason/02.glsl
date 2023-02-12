#ifdef GL_ES
    precision mediump float;
#endif



uniform vec2 u_resolution;
uniform float u_time; 

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

float noisef (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

void main(){
    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    vec2 uv = gl_FragCoord.xy / u_resolution;
    for(int i = 0; i < 3; i ++)
    {
        vec2 st = (gl_FragCoord.xy + (float(i ) * sin(u_time* 2.0 + gl_FragCoord.x * 0.02)* 10.52)) / u_resolution;
        st = st * 2.0 - vec2(1.0, 1.0);
        st.y += -u_time * 0.2 + sin(u_time * random(vec2(floor(st.x * 20.)))) * .50;
        vec2 fc = fract(st * 5.0) * 2.0 - vec2(1.0, 1.0);
        vec2 ic = floor(st * 5.0);
        vec2 ic2 = floor((st + 0.2) * 5.0);
        
        float noise = random(ic);
        float noise2 = random(ic2);
        noise = noisef((ic + u_time * 0.2) * 0.3);
        


        float polarRadius = fract(atan(fc.y, fc.x) / 3.14159265 * (sin(u_time + noise * 10.0) + 0.) * noise * 6.0)  ; 
        float d = distance(vec2(0.0, 0.0), fc); 
        //polarRadius += sin(u_time);
        vec2 polarCoordinate = vec2(polarRadius, d);    
        

        float sphere = distance(vec2(0.5, 0.5), polarCoordinate);
        sphere = step(sphere, 0.3);

        float sphere2 = distance(vec2(0.5, sin(u_time)), polarCoordinate);
        sphere = step(sphere, (sin(u_time) + 1.0) * 0.);
        sphere = 1.0 - sphere;

        
        gl_FragColor[i] += sphere;
    }
    //gl_FragColor = vec4(vec3(sphere), 1.0);
        gl_FragColor.b = max(gl_FragColor.b, 0.9 * sin(uv.y + u_time * 0.0) );

        gl_FragColor.r = max(gl_FragColor.r, 0.6 * sin(uv.x + u_time * 2.0)); 
        gl_FragColor.g = max(gl_FragColor.g, 0.6);


    }
