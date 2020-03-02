uniform vec2 u_resolution;


float map(vec3 p){
  return distance(p, vec3(0.0)) - 1.0;
}

float trace(vec3 origin, vec3 direction){
  float dist = 0.0;
  for (int i = 0; i < 64; i++){
    vec3 p = origin + direction * dist;
    float d = map(p);
    if(d<= 0.0){
      break;
    }
    dist += d;
  }
  return dist;
}

void main(){
  vec2 coord = 2.0 * gl_FragCoord.xy/u_resolution - vec2(1.0);
  vec3 color = vec3(1);

  vec3 direction = normalize(vec3(coord, 1.0));
  vec3 origin = vec3(0.0, 0.0, -3);
  float dist = trace(origin, direction);

  color = vec3(1.0 - dist/10.);

  gl_FragColor = vec4(color, 1.0);
}
