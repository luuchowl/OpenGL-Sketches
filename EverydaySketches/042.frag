#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float sdSphere(vec3 p, float radius)
{
  return  distance(p, vec3(0.0, 0.0 ,0.0)) - radius;
}
float sdSphere(vec3 p, float radius, vec3 origin)
{
  return  distance(p, origin) - radius;
}

float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}


float opIntersection( float d1, float d2 ) { return max(d1,d2); }
float opSubtraction( float d1, float d2 ) { return max(-d1,d2); }
#define EPSILON 0.00001

float opSmoothUnion( float d1, float d2, float k ) {
    float h = clamp( 0.5 + 0.5*(d2-d1)/k, 0.0, 1.0 );
    return mix( d2, d1, h ) - k*h*(1.0-h); }

float sdfShape(vec3 p){
  float camera = sdSphere(p, 1.0, vec3(0.0, 0.0, -3.));
  float a =  (sdSphere(fract(((p + vec3(sin(u_time *4.1) *0.3, sin(u_time *2.7) *0.3, 0.0)  ) * 3.)) * 2.0 - vec3(1.0), 0.8)) ;
  a = sdSphere(abs(p), 0.5, vec3(clamp(sin(u_time), 0.0, 1.0), clamp(cos(u_time), 0.0, 1.0), 1.0));


  float op = opSubtraction(camera, a);
  float b = sdSphere(p + vec3(sin(u_time * 5.5), sin(u_time * 2.5), 0.0), (sin(u_time) * 0.5 + 0.5) * 0.5 + 0.8);
  float c = opSmoothUnion(a, b, 0.5);
  return op;
}





//http://jamie-wong.com/2016/07/15/ray-marching-signed-distance-functions/
//Jamie Wong - Ray Marching
vec3 estimateNormal(vec3 p) {
    return normalize(vec3(
        sdfShape(vec3(p.x + EPSILON, p.y, p.z)) - sdfShape(vec3(p.x - EPSILON, p.y, p.z)),
        sdfShape(vec3(p.x, p.y + EPSILON, p.z)) - sdfShape(vec3(p.x, p.y - EPSILON, p.z)),
        sdfShape(vec3(p.x, p.y, p.z  + EPSILON)) - sdfShape(vec3(p.x, p.y, p.z - EPSILON))
    ));
}

float raymarch(vec3 origin, vec3 direction){
  float dist =0.0;
  for(int i = 0; i<164; i++)
  {
    vec3 p=origin + direction *dist;
    float d = sdfShape(p);
    if(d<=0.0)
    {
      break;
    }
    dist += d;
  }

  return dist;
}


void main()
{
  vec2 coord = 2.0 * gl_FragCoord.xy / u_resolution - vec2(1.0);

  vec3 direction = normalize(vec3(coord, 1.0));
  vec3 origin = vec3(0.0, 0.0, -3.0);
  float dist = raymarch(origin, direction);

  vec3 p = origin + dist*direction;
  vec3 normal = estimateNormal(p);

  //Luz
  vec3 lightDir = normalize(vec3(sin(u_time * 2.0), cos(u_time * 3.0), sin(u_time * 1.0)));
  //Luz Orbitante com trigonometria
  lightDir = normalize(vec3(sin(u_time), cos(u_time), sin(u_time * 2.0)));

  //Calcula ponto produto e retornará quão iluminada é uma face
  float shading = dot(lightDir, normal);

  //Se a distância for maior que 5, retorne um cinza para diferenciar a forma do fundo.
  if(dist > 5.0){
    vec3 corA = vec3(91.0/255.0 , 50.0/255.0, 101.0/255.0);
    vec3 corB = vec3(30.0/255.0, 33.0/255.0, 99.0/255.0);
    gl_FragColor = vec4(mix(corA, corB, gl_FragCoord.y / u_resolution.x), 1.0);
  }
  else{
    vec3 corA = vec3(44.0/255.0 , 87.0/255.0, 132.0/255.0);
    vec3 corB = vec3(86.0/255.0, 22.0/255.0, 199.0/255.0);
    gl_FragColor = vec4(mix(corA, corB, shading), 1.0);
  }

  //gl_FragColor = vec4(vec3(shading), 1.0);



}
