// Vertex shader

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@vertex
fn vs_main(
    @builtin(vertex_index) in_vertex_index: u32,
) -> VertexOutput {
    var out: VertexOutput;
    let x = f32(i32(in_vertex_index & 2u) - 1);
    let y = 1.0 - (f32(in_vertex_index & 1u) * 2.0);
    out.clip_position = vec4<f32>(x, y, 0.0, 1.0);
    return out;
}


// Fragment shader

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(0.0, 0.0, 0.0, 1.0);
}
