
#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform float u_time;


const int MAX_MARCHING_STEPS = 100;
const float MIN_DIST = 0.0;
const float MAX_DIST = 100.0;
const float EPSILON = 0.0001;

//Signed distance function for a sphere centered at origin with radius 1.0
float sphereSDF(vec3 samplePoint)
{
  return length(samplePoint) - 1.0;
}

//Signed distance of a cube centered at the origin with width = height = length = 2.0
float cubeSDF(vec3 p){
  //If d.x < 0, then -1< p.x < 1, and same logic applies to p.y, p.z
  //So if all components of d are negative, then p is inside the unit cubeSDF
  vec3 d = abs(p) - vec3(1.0, 7.0, 1.0) ;

  //Assuming p is inside the cube, how far is it from the surface?
  // Result will be negative or zero

  float insideDistance = min(max(d.x, max(d.y, d.z)), 0.0);

  //Assuming p is outside the cube, how far is it from the surface?
  //Result will be positive or zero;
  float outsideDistance = length(max(d, 0.0));

  return insideDistance + outsideDistance;

}

float sdBoundingBox( vec3 p, vec3 b, float e )
{
       p = abs(p  )-b;
  vec3 q = abs(p+e)-e;
  return min(min(
      length(max(vec3(p.x,q.y,q.z),0.0))+min(max(p.x,max(q.y,q.z)),0.0),
      length(max(vec3(q.x,p.y,q.z),0.0))+min(max(q.x,max(p.y,q.z)),0.0)),
      length(max(vec3(q.x,q.y,p.z),0.0))+min(max(q.x,max(q.y,p.z)),0.0));
}

float sdPlane( vec3 p, vec3 n, float h )
{
  // n must be normalized
  return dot(p,n) + h;
}

float intersectSDF(float distA, float distB)
{
  return max(distA, distB);
}

float unionSDF(float distA, float distB)
{
  return min(distA, distB);
}

float differenceSDF(float distA, float distB)
{
  return max(distA, -distB);
}

float opRep( in vec3 p, in vec3 c)
{
    vec3 q = mod(p+0.5*c,c)-0.5*c;
    return cubeSDF( q );
}

mat4 rotateY(float theta)
{
  float c = cos(theta);
  float s = sin(theta);
  return mat4(
    vec4(c, 0, s, 0),
    vec4(0, 1, 0, 0),
    vec4(-s, 0, c, 0),
    vec4(0, 0, 0, 1)
    );
}

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}



/**
 Signed distance function describing the scene;

 Absolute value of return value indicates the distance to the surface
 Sign indicates whether the point is inside or outside the surface
 Negative indicating inside.

*/

float opTwist(vec3 p )
{
    //float k = sin(u_time) * 0.3 + p.x * 0.3 ; // or some other amount
    float k = 0.2;
    float c = cos(k*p.y);
    float s = sin(k*p.y);
    mat2  m = mat2(c,-s,s,c);
    vec3  q = vec3(m*p.xz,p.y);
    return sdBoundingBox(q, vec3(1.0), 0.1);
}

float sceneSDF(vec3 samplePoint)
{
  vec3 cubePoint = ((rotateY(-u_time)) * vec4(samplePoint, 1.0)).xyz;
   cubePoint = samplePoint;
  float n = noise(vec2(samplePoint.x * 1.0 + sin(u_time) * 1.0, samplePoint.y + cos(u_time) * 3.0 ) * 2.0);
  float cube = cubeSDF(cubePoint + vec3(n - 0.5, n * 1.0 - 0.5, 0.0));
  float sphere = sphereSDF(samplePoint + vec3(n * -0.5) );
  float sphere2 = sphereSDF(samplePoint / 1.2) * 1.2;
  //float shape = -1.0;

  //float shape = cubeSDF(cubePoint);
  float bb = sdBoundingBox(samplePoint, vec3(1.0), 0.1);
  //return opTwist(samplePoint);
  float shape = 1000.0;
  for(int i = -1; i < 2; i++)
  {
    for(int j = 0; j < 1; j++)
    {
      cubePoint =  samplePoint-vec3(float(i) * 2.5, 0.0, float(j) * 2.5 );
      cubePoint = ((rotateY(-u_time * 1.0 +  0.35 * length(vec2(float(i),float(j))))) * vec4(cubePoint, 1.0)).xyz;
      shape = unionSDF(shape,opTwist(cubePoint) );
      //shape = unionSDF(shape, cubeSDF(cubePoint + vec3(float(i) * 1.5 * 3.0,  5.0 * sin(u_time * 2.0+  1.0 * length(vec2(float(i),float(j)))), float(j) * 1.5 * 3.0)));
    }
  }

  return shape;
  //return cubeSDF(cubePoint);
  //return opRep(samplePoint + vec3(0.0, cos(u_time * 2.0 + floor(samplePoint.x * 0.5 + 0.25))  * 0.5
  //+ sin(u_time * 2.0 + floor(samplePoint.z * 0.5 + 0.25))  * 0.5, 0.0), vec3( 2.0, 0.0, 2.0));
  //return opRep(samplePoint + vec3(sin(u_time)), vec3( 2.0, 0.0, 2.0));
  //float plane = sdPlane(samplePoint + vec3(0.0, sin(u_time + samplePoint.x), 0.0) + cos(u_time + samplePoint.z), vec3(0.0, 1.0, 0.0), 20.4);
  //return unionSDF(plane, sphere);
  //return differenceSDF(intersectSDF(cube, sphere2), sphere);
  //return differenceSDF(cube, sphere);
  //return plane;
  return sphere;


}


/*
  Return the shortest distance from the eyepoint to the scene surface along
  the marching direction. If no part of the surface is found between start and end,
  return end.

  eye: eye point, acting as the origin of the ray
  marchingDirection: the normalized direction to march in
  start: the starting distance away from the eye
  end: the max distance away from the eye to march before giving up
*/
float shortestDistanceToSurface(vec3 eye, vec3 marchingDirection, float start, float end)
{
    float depth = start;
    for (int i = 0; i < MAX_MARCHING_STEPS; i++)
    {
        float dist = sceneSDF(eye + depth * marchingDirection);
        if(dist<EPSILON)
        {
          return depth;
        }
        depth += dist;
        if(depth >= end)
        {
          return end;
        }
    }
    return end;
}

/*
  Return the normalized direction to march in from the eye point for a single pixel;

  fieldOfView : vertical field of view in degrees
  size: resolution of the output image
  fragCoor : the x, y coordinate of the pixel in the output image
*/

vec3 rayDirection(float fieldOfView, vec2 size, vec2 fragCoord)
{
    vec2 xy = fragCoord - size / 2.0;
    float z = size.y / tan(radians(fieldOfView) / 2.0);
    return normalize(vec3(xy, -z));
}

/*
  Using the gradient of the SDF, estimate the normal on the surface at point p;
*/
vec3 estimateNormal(vec3 p)
{
    return normalize(vec3(
          sceneSDF(vec3(p.x + EPSILON, p.y, p.z)) - sceneSDF(vec3(p.x - EPSILON, p.y, p.z)),
          sceneSDF(vec3(p.x, p.y + EPSILON, p.z)) - sceneSDF(vec3(p.x, p.y - EPSILON, p.z)),
          sceneSDF(vec3(p.x, p.y, p.z + EPSILON)) - sceneSDF(vec3(p.x, p.y, p.z - EPSILON))
      ));
}

/*
Lighting contribution of a single point light source via Phong illumination.

The vec3 returned is the RGB color of the light's contribution.

k_a : Ambient gl_FragColor
k_d : Diffuse gl_FragColor
k_s: Specular gl_FragColor
alpha: Shininess coefficient
p : position of point being light
eye : the position of the camera
lightPos : the position of the lightPos
lightIntensity : color/intesity of the lightPos
*/

vec3 phongContribForLight(vec3 k_d, vec3 k_s, float alpha, vec3 p, vec3 eye,
                          vec3 lightPos, vec3 lightIntensity)
{
    vec3 N = estimateNormal(p);
    vec3 L = normalize(lightPos - p);
    vec3 V = normalize(eye - p);
    vec3 R = normalize(reflect(-L, N));

    float dotLN = dot(L, N);
    float dotRV = dot(R,V);

    if(dotLN < 0.0)
    {
      return vec3(0.0);
    }

    if(dotRV < 0.0)
    {
      return lightIntensity * (k_d * dotLN);
    }

    return lightIntensity * (k_d * dotLN + k_s * pow(dotRV, alpha));
}

/*
  Lighting via Phong illumination

  The vec3 returned is the RGB color of that point after lighting is applied
  k_a: Ambient color
  k_d: Diffuse color
  k_s: Specular color
  alpha: Shininess coefficient
  p : position of point being lit
  eye : the position of the camera
*/

vec3 phongIllumination(vec3 k_a, vec3 k_d, vec3 k_s, float alpha, vec3 p, vec3 eye)
{
  const vec3 ambientLight = 0.5 * vec3(1.0, 1.0, 1.0);
  vec3 color = ambientLight * k_a;

  vec3 light1Pos = vec3(4.0 , 2.0, 4.0);
  vec3 light1Intensity = vec3(0.4, 0.4, 0.4);

  color += phongContribForLight(k_d, k_s, alpha, p, eye, light1Pos, light1Intensity);

  //vec3 light2Pos = vec3(2.0 * sin(0.37 * u_time), 2.0 * cos(0.37 * u_time), 2.0);
  vec3 light2Pos = vec3(2.0, 2.0, 2.0);
  vec3 light2Intensity = vec3(0.4, 0.4, 0.4) * sin(u_time ) + 1.0 ;

    color += phongContribForLight(k_d, k_s, alpha, p, eye, light2Pos, light2Intensity);

    return color;

}

/*
Return a transformation matrix that will transform a ray from view space
to wold coordinates, given the eye point, the camera target, and an up vector.

This assumes that the center of the camera is aligned with the negative z axis in
view space when calculating the ray marching direction
*/
mat4 viewMatrix(vec3 eye, vec3 center, vec3 up)
{
    vec3 f = normalize(center - eye);
    vec3 s = normalize(cross(f, up));
    vec3 u = cross(s, f);

    return mat4(
        vec4(s, 0.0),
        vec4(u, 0.0),
        vec4(-f, 0.0),
        vec4(0.0, 0.0, 0.0, 1)
      );
}

vec4 filter(vec4 color)
{

  color.r = min(0.8, color.r);
  color.b = max(0.4, color.b);
  //cpçpr.g = max(0.3, color.g);
  color.g *= 0.7;
  //color.g = max(color.g, 0.2);
  color.r = max(0.1, color.r);
  color.g = min(color.r, color.g);

  color.g = pow(color.b, 15.0);
  color.g = max(0.2, color.g);
  color.b *= 0.7;
  //color.g *=2.0;
  //return vec4(1.0) - color;

  return vec4(0.0, 0.7, 0.65, 1.0);
  return color;
}


void main()
{

    vec3 viewDir = rayDirection(70.0, u_resolution.xy, gl_FragCoord.xy);
    vec2 st = gl_FragCoord.xy / u_resolution.xy;
    vec3 eye = vec3(8.0, 10.0, 0.0) * 1.0;

    mat4 viewToWorld = viewMatrix(eye, vec3(0.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0));

    vec3 worldDir = (viewToWorld * vec4(viewDir, 0.0)). xyz;

    float dist = shortestDistanceToSurface ( eye, worldDir, MIN_DIST, MAX_DIST);

    if(dist > MAX_DIST - EPSILON)
    {
        //Didn't hit anything]
        vec4 color = vec4(0.93, 0.7, 0.5, 1.0);
        color.g = mix(color.g, st.y, 0.6);
        gl_FragColor = color;
      //  gl_FragColor = filter(gl_FragColor);
        return;
    }

    if(dist>30.0)
    {

      vec3 p = eye + dist * worldDir;

      vec3 K_a = vec3(0.2, 0.25, 0.2);
      vec3 K_d = vec3(0.3, 0.1, 0.3);
      vec3 K_s = vec3(0.0, 0.1, 0.7);
      float shininess = 10.0;

      vec3 color = phongIllumination(K_a, K_d, K_s, shininess, p, eye);
      gl_FragColor = vec4(color, 1.0);
      gl_FragColor = filter(gl_FragColor);
      return;
    }

    vec3 p = eye + dist * worldDir;

    vec3 K_a = vec3(1.2, 1.2, 1.5);
    vec3 K_d = vec3(1.5, 1.5, 1.6);
    vec3 K_s = vec3(1.8, 1.6, 1.8);
    K_a = K_d = K_s = vec3(0.0);
    float shininess = 1000000.0;

    vec3 color = phongIllumination(K_a, K_d, K_s, shininess, p, eye);

    gl_FragColor = vec4(color, 1.0);
    gl_FragColor = filter(gl_FragColor);

    //gl_FragColor   = vec4(1.0, 1.0, 0.0, 1.0);
}
