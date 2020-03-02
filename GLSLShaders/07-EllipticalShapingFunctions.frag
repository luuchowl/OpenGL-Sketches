//http://www.flong.com/texts/code/shapers_circ/


uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//Plot a line on Y using a value betwwen 0.0 - 1.0
float plot(vec2 st, float pct){
  return smoothstep(pct-0.02, pct, st.y) - smoothstep(pct, pct+0.02, st.y);
}

float sq(float a){
  return a*a;
}

//------------------------------
float circularEaseOut (float x){
  float y = sqrt(1.0 - sq(1.0 - x));
  return y;
}
float circularEaseIn (float x){
  float y = 1.0 - sqrt(1.0 - x*x);
  return y;
}

//-------------------------------------------
float doubleCircleSigmoid (float x, float a){
  float min_param_a = 0.0;
  float max_param_a = 1.0;
  a = max(min_param_a, min(max_param_a, a));

  float y = 0.0;
  if (x<=a){
    y = a - sqrt(a*a - x*x);
  } else {
    y = a + sqrt(sq(1.0-a) - sq(x-1.0));
  }
  return y;
}

//---------------------------------------------------
float doubleEllipticSeat (float x, float a, float b){
  float epsilon = 0.00001;
  float min_param_a = 0.0 + epsilon;
  float max_param_a = 1.0 - epsilon;
  float min_param_b = 0.0;
  float max_param_b = 1.0;
  a = max(min_param_a, min(max_param_a, a));
  b = max(min_param_b, min(max_param_b, b));

  float y = 0.;
  if (x<=a){
    y = (b/a) * sqrt(sq(a) - sq(x-a));
  } else {
    y = 1.- ((1.-b)/(1.-a))*sqrt(sq(1.-a) - sq(x-a));
  }
  return y;
}


void main(){
  vec2 st = gl_FragCoord.xy/u_resolution;

  float y = doubleCircleSigmoid(st.x, 0.5);
  vec3 color = vec3(y);

  //Plot a line;
  float pct = plot(st,y);
  color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);

  gl_FragColor = vec4(color, 1);
}
