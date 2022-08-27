uniform sampler2D tInput;
uniform float delta;
uniform float angle;

float random(vec3 scale, float seed, vec3 xyz){
    return fract(sin(dot(xyz+seed, scale))*43758.5453+seed);
}

vec4 fragment(vec2 uv, vec2 fragCoord) {
    vec4 o = texture(tInput, uv);
    vec4 color=vec4(0.0);
    float total=0.0;
    vec2 tDelta = delta * vec2(cos(angle), sin(angle));
    float offset=random(vec3(12.9898, 78.233, 151.7182), 0.0, vec3(fragCoord, 1000.0));
    for (float t=-30.0;t<=30.0;t++){
        float percent=(t+offset-0.5)/30.0;
        float weight=1.0-abs(percent);
        vec4 saample=texture(tInput, uv+tDelta*percent);
        saample.rgb*=saample.a;
        color+=saample*weight;
        total+=weight;
    }

    if (total == 0.) total = 1.;
    vec4 fragcolor=  color / total;
    fragcolor.rgb = fragcolor.rgb/ fragcolor.a+0.01;
    return fragcolor;
}