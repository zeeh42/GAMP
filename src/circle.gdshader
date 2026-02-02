shader_type canvas_item;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // remap UV from [0,1] to [-1,1]
    float dist = length(uv);

    if (dist > 1.0) {
        discard; // outside the circle
    }

    COLOR = texture(TEXTURE, UV);
}
