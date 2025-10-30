#version 440
#define PI 3.1415926535897932384626433832795

// source : https://www.shadertoy.com/view/XdsXRf
// compile shader: /usr/lib/qt6/bin/qsb --glsl "100 es,120,150" -o radar.frag.qsb radar.frag

// layout(location = 0) in vec2 coord;
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float angle;
};

float LineToPointDistance2D(vec2 a, vec2 b, vec2 p)
{
    vec2 pa = p - a;
    vec2 ba = b - a;

    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);

    return length( pa - ba * h);
}

vec2 RotatePoint(vec2 center, float angleDeg, vec2 p)
{
    float angle = (PI / 180.0) * angleDeg;

    float s = sin(angle);
    float c = cos(angle);

    // translate point back to origin:
    p.x -= center.x;
    p.y -= center.y;

    // rotate point
    float xnew = p.x * c - p.y * s;
    float ynew = p.x * s + p.y * c;

    // translate point back:
    p.x = xnew + center.x;
    p.y = ynew + center.y;

    return p;
}

float AngleVec(vec2 a_, vec2 b_) 
{
    vec3 a = vec3(a_, 0);
    vec3 b = vec3(b_, 0);
    float dotProd = dot(a,b);
    vec3 crossprod = cross(a,b);
    float crossprod_l = length(crossprod);
    float lenProd = length(a) * length(b);
    float cosa = dotProd / lenProd;
    float sina = crossprod_l / lenProd;
    float angle = atan(sina, cosa);

    if (dot(vec3(0, 0, 1), crossprod) < 0.0) 
        angle = 90.0;
    return (angle * (180.0 / PI));
}

void main() {
    vec2 center = vec2(0.5, 0.5);

    float minRes = min(center.x, center.y);
    float radius = minRes - minRes * 0.1;
    float circleWidth = radius * 0.02;
    float lineWitdh = circleWidth * 0.8;
    float angleStela = 180.0;
	  vec2 lineEnd = vec2(center.x, center.y + radius);

    float blue = 0.0;
    float green = 0.0;

    float distanceToCenter = distance(center, qt_TexCoord0.xy);
    float disPointToCircle = abs(distanceToCenter - radius);

    //Draw Circle
    if (disPointToCircle < circleWidth) {
        green = 1.0 - (disPointToCircle / circleWidth);
    }

    //Rotate Line
    lineEnd = RotatePoint(center, angle, lineEnd);

    //Draw Line	
    float distPointToLine = LineToPointDistance2D(center, lineEnd, qt_TexCoord0.xy);
    if (distPointToLine < lineWitdh) {
        float val = 1.0 - distPointToLine / lineWitdh;
        if (val > green) {
            green = val;
        }
    }

    //Draw stela
    float angleStelaToApply = AngleVec(normalize(lineEnd - center),
                                       normalize(qt_TexCoord0.xy - center));
    if (angleStelaToApply < angleStela && distanceToCenter < radius - circleWidth / 2.0 + 1.0) {
		    float factorAngle = 1.0 - angleStelaToApply / angleStela;
        float finalFactorAngle = (factorAngle * 0.5) - 0.15;
        if (finalFactorAngle > green) {
            green = finalFactorAngle;
        }
	  }

	  fragColor = vec4(0.0, green, blue, 1.0);
}
