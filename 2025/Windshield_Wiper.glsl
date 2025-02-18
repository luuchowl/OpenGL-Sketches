//001 Windshield Wiper
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;


void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy*2. -1.0;
    st.x *= u_resolution.x/u_resolution.y;

    float sphere_mask = step(length(st), 0.5);

    float r = length(st);
    float a = atan(st.x, st.y);

    float t1 = sin(u_time) * 2.0;
    float t2 = cos(u_time) * 2.0;

    float wwm_mask = step(a, t1);
    float ww_mask = step(abs(a), 1.0);

    float mask = wwm_mask * ww_mask;


    gl_FragColor = vec4(min(vec3(wwm_mask),sphere_mask), 1.0);
}