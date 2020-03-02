//http://www.flong.com/texts/code/shapers_exp/

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//Plot a line on Y using a value betwwen 0.0 - 1.0
float plot(vec2 st, float pct){
  return smoothstep(pct-0.02, pct, st.y) - smoothstep(pct, pct+0.02, st.y);
}

float easeout(float x, float a){
  return pow(x, 1./a);
}

float easein(float x, float a){
  return pow(x, a);
}

float doubleExponentialSeat (float x, float a){

  float epsilon = 0.00001;
  float min_param_a = 0.0 + epsilon;
  float max_param_a = 1.0 - epsilon;
  a = min(max_param_a, max(min_param_a, a));

  float y = 0.;
  if (x<=0.5){
    y = (pow(2.0*x, 1.-a))/2.0;
  } else {
    y = 1.0 - (pow(2.0*(1.0-x), 1.-a))/2.0;
  }
  return y;
}

float doubleExponentialSigmoid (float x, float a){

  float epsilon = 0.00001;
  float min_param_a = 0.0 + epsilon;
  float max_param_a = 1.0 - epsilon;
  a = min(max_param_a, max(min_param_a, a));
  a = 1.0-a; // for sensible results

  float y = 0.;
  if (x<=0.5){
    y = (pow(2.0*x, 1.0/a))/2.0;
  } else {
    y = 1.0 - (pow(2.0*(1.0-x), 1.0/a))/2.0;
  }
  return y;
}

void main(){
  vec2 st = gl_FragCoord.xy/u_resolution;

  float y = doubleExponentialSigmoid(st.x, 0.7);
  vec3 color = vec3(y);

  //Plot a line;
  float pct = plot(st,y);
  color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);

  gl_FragColor = vec4(color, 1);
}
