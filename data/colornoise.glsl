#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER
#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform float frame; uniform float period;
uniform vec2 size;
uniform vec2 roff; uniform vec2 goff; uniform vec2 boff;
uniform vec2 mouse;
uniform float colorLevels;
uniform float freq; uniform vec3 rgbf; uniform float tfreq;
uniform float ndiv;
uniform float hstart; uniform float hdiv;
uniform float gf;

// Map function
float ofMap(float value, float inputMin, float inputMax, float outputMin, float outputMax, bool clamp) {
  float outVal = ((value - inputMin) / (inputMax - inputMin) * (outputMax - outputMin) + outputMin);

  if( clamp ){
    if(outputMax < outputMin){
      if( outVal < outputMax ) outVal = outputMax;
      else if( outVal > outputMin ) outVal = outputMin;
    }else{
      if( outVal > outputMax ) outVal = outputMax;
      else if( outVal < outputMin ) outVal = outputMin;
    }
  }
  return outVal;
}

// HSV2RGB
vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
// get decimal loopily
float getDec(float v){
  if(mod(floor(v),2.0)!=0.0){return fract(v);} else{return 1-fract(v);}
}
// round to number
float r2n(float n,float base){
  return base*roundEven(n/base);
}
// ???
float divn(float i,float n){
  if(mod(floor(i*n/size.x),2) == 0){
    return 1;
  } else return -1;
}
// loop value
float hloop(float h){
  if(h < 0){
    return h - floor(h);
  } else {
    if(h >= 1){
      return h - floor(h);
    } else {return h;}
  }
}
// bounce value
float hbounce(float h){
  float hn = hloop(h);
  if(h != hn){
    return hloop(h - 2*hn);
  } else {return h;}
}
// trig func
float trigf(vec2 pos,vec2 tfreqs,vec2 sfreqs,float tim){
  float c1 = TWO_PI*sfreqs.x*pos.x;
  float s1 = TWO_PI*sfreqs.y*pos.y;
  float c2 = TWO_PI*sfreqs.y*pos.x;
  float s2 = TWO_PI*sfreqs.x*pos.y;
  float t1 = TWO_PI*tfreqs.x*tim;
  // float v = (cos(c1) + sin(s1))*(cos(c2) + sin(s2));
  float v = (cos(c1)*sin(s1)-cos(c2)*sin(s2))*ofMap(cos(t1),-1,1,.1,10,false);
  return v;
}

// MAIN
void main(void){
    float t = mod(frame,period)/period;
    vec2 mfreq = vec2(abs(ofMap(mouse.x,0.,size.x,-5.,5.,false)),
                      abs(ofMap(mouse.y,0.,size.y,-5.,5.,true)));
    float rmag = distance(gl_FragCoord.xy,roff.xy)/length(size);
    float gmag = distance(gl_FragCoord.xy,goff.xy)/length(size);
    float bmag = distance(gl_FragCoord.xy,boff.xy)/length(size);
    vec2 npos = gl_FragCoord.xy/size.xy;
    // vec2 npos = vec2(gl_FragCoord.x/size.x,gl_FragCoord.y/size.y);
    float ch = trigf(npos,vec2(tfreq,tfreq),mfreq,0);
    float hrf = ofMap(cos(TWO_PI*t),-1,1,.1,2,false);
    float h = r2n(hbounce(hstart + ch*hdiv*hrf),colorLevels);
    float brf = ofMap(length(mouse),0,length(size),.01,.5,false);
    float br = r2n(hbounce(ch*brf),colorLevels);
    br = pow(sin(TWO_PI*br),1);
    // float gf = ofMap(sin(TWO_PI*t),-1,1,.1,2,false);
    // float r =  sin(TWO_PI*(tfreq*t+rgbf.x*freq*rmag));
    // float g =  sin(TWO_PI*(tfreq*t+rgbf.y*freq*gmag));
    // float b =  sin(TWO_PI*(tfreq*t+rgbf.z*freq*bmag));
    // float m = r2n(ofMap(pow(r*r+g*g+b*b,0.5),0,pow(3,0.5),0,1,true),colorLevels);
    // float m = ofMap(r+g+b,-3,3,0,1,true);
    // float h = r2n(hloop(hstart+(r+g+b)/hdiv),colorLevels);
    // float br = r2n(ofMap(r+g+b,-3,1,0,1,true),colorLevels);
    vec4 rgba = vec4(hsv2rgb(vec3(h,1,br)),1);
    // vec4 rgba = vec4(r*r,g*g,b*b,1.0);
    gl_FragColor = rgba;
}