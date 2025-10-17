// Vertex shader
struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@vertex
fn vs_main(
    @builtin(vertex_index) in_vertex_index: u32,
) -> VertexOutput {
    var out: VertexOutput;

    // indices 0, 1, 2 -> -1.0, -1.0, 3.0
    let x = f32((i32(in_vertex_index & 2u) * 4) - 1);
    // indices 0, 1, 2 -> 1.0, -3.0, 1.0
    let y = 1.0 - f32(i32(in_vertex_index & 1u) * 4);
    let xy = vec2<f32>(x, y);

    out.clip_position = vec4<f32>(xy, 0.0, 1.0);

    return out;
}


// Fragment shader
struct ShaderState {
    resolution_x: u32,
    resolution_y: u32,
    elapsed: f32,
}

@group(0) @binding(0)
var<uniform> shader_state: ShaderState;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = in.clip_position.xy / vec2<f32>(f32(shader_state.resolution_x), f32(shader_state.resolution_y));
    return vec4<f32>(uv.x, sin(shader_state.elapsed), uv.y, 1.0);
}

