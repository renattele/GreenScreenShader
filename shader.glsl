vec4 colorAbbr(sampler2D channel, vec2 uv, vec2 shift) {
    float rX = (shift.x - 0.5);
    float rY = (shift.y - 0.5);
    float radius = sqrt(rY*rY + rY*rY);
    vec4 col = texture(channel, uv);
    vec4 col2 = texture(channel, uv + vec2(-0.009 * vec2(rX, rY)));
    float r = col.r;
    float g = (col.g + col2.g)/2.0;
    float b = (col.b + col2.b)/2.0;
    return vec4(r, g, b, 1.0);
}

bool isGreenScreen(vec4 pixel) {
    return pixel.g - 0.1 > pixel.r && pixel.g - 0.1 > pixel.b;
}

vec4 greenScreen(vec4 source, vec4 background) {
    if (isGreenScreen(source)) 
        return background;
    else 
        return source;
}

bool isOutline(vec2 coord, float radius, sampler2D source, sampler2D background) {
    if (!isGreenScreen(texture(source, coord / iResolution.xy))) return false;
    for (float x = coord.x - radius; x < coord.x + radius; x = x + 1.0) {
        for (float y = coord.y - radius; y < coord.y + radius; y = y + 1.0) {
            if (!isGreenScreen(texture(source, vec2(x, y) / iResolution.xy))) return true;
        }
    }
    return false;
}
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{  
	vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 video = texture(iChannel0, uv);
    vec4 background = texture(iChannel1, uv);
    vec4 green = greenScreen(video, background);
    if (isOutline(fragCoord.xy, 5.0, iChannel0, iChannel1)) {
        fragColor = vec4(1.0);
    } else
        fragColor = green;
}
