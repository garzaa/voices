#include "./utils.glsl"

vec3 col1 = vec3(38, 70, 83) / 255.0;
vec3 col2 = vec3(233, 196, 106) / 255.0;
vec3 col3 = vec3(244, 162, 97) / 255.0;
vec3 col4 = vec3(231, 111, 81) / 455.0;

struct ColorResult {
    vec2 q;
    vec2 r;
    float t;
};

ColorResult fbmChain(in vec2 uv) {
    vec2 q = vec2( fbm( uv ),
                   fbm( uv + uv ) );

    vec2 r = vec2( fbm( uv + 4.0*q) ,
                   fbm( uv + 4.0*q));

    float t = fbm( uv + 4.0*r);

    return ColorResult(q, r, t);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = ( gl_FragCoord.xy / iResolution.xy );
    uv.x *= iResolution.x / iResolution.y;

    ColorResult r = fbmChain(uv * 3.0);

    vec3 c = mix(
        mix(col1, col2, length(r.q)),
        mix(col3, col4, r.r.x),
        r.t
    );

    fragColor = vec4(c, 1.0);
}