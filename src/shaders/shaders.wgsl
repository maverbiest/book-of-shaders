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
    out.clip_position = vec4<f32>(x, y, 0.0, 1.0);
    return out;
}


// Fragment shader

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(0.0, 0.0, 0.0, 1.0);
}
