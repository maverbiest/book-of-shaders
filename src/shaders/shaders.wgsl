// Vertex shader

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) frag_coord: vec2<f32>,
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
    out.frag_coord = xy * 0.5 + vec2<f32>(0.5);

    return out;
}


// Fragment shader

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = in.frag_coord;
    return vec4<f32>(uv.x, 0.0, uv.y, 1.0);
}
