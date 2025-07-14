//001 Windshield Wiper
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy*2. -1.0;
    st.x *= u_resolution.x/u_resolution.y;
    st.x -= 0.3;
    float t = u_time * 2.0;
    float sphere_mask = step(length(st), 0.8);
    float sphere_mask_in = 1.0-step(length(st), 0.2);

    float r = length(st);
    float a = atan(st.x, st.y);
    float offset = 0.5;

    float t1 = clamp((sin(t) *1.0 ), -1.0, 1.0) - offset;
    float t2 = clamp((cos(t) * 1.0 ), -1.0, 1.0) - offset;

    float wwm_mask = smoothstep(t1, t2, a);
    float wwm_mask_he = smoothstep(t2, t2-(t2-t1)*0.001, a);

    float mask =  wwm_mask* wwm_mask_he * sphere_mask * sphere_mask_in;


    gl_FragColor = vec4(vec3(mask), 1.0);
}