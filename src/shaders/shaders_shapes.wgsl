// Vertex shader
struct VertexOutput {
    @builtin(position) position: vec4<f32>,
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

    out.position = vec4<f32>(xy, 0.0, 1.0);

    return out;
}


// Fragment shader
struct ShaderState {
    // 32 bytes total
    resolution_x: u32,
    resolution_y: u32,
    elapsed: f32,
    mouse_pos_x: f32,
    mouse_pos_y: f32,
    // padding to align to 16-byte boundary
    _pad0: f32,
    _pad1: f32,
    _pad2: f32,
}

@group(0) @binding(0)
var<uniform> shader_state: ShaderState;

fn plot_straight(st: vec2<f32>) -> f32 {
    return 1.0 - smoothstep(0.0, 0.02, abs(st.y - st.x));
}

fn plot_curve(st: vec2<f32>, pct: f32) -> f32 {
    let a = smoothstep(pct - 0.01f, pct, st.y);
    let b = smoothstep(pct, pct + 0.01f, st.y);
    return a - b;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = vec2<f32>(f32(shader_state.resolution_x), f32(shader_state.resolution_y));
    //flip the y-axis so 0.0 is at the bottom left of the screen
    var st = vec2<f32>(in.position.x / resolution.x, 1.0f - (in.position.y / resolution.y));

    var pct = distance(vec2<f32>(0.5), st) / max(0.0001, sin(abs(shader_state.elapsed)));
    pct = smoothstep(0.4, 0.5, pct);
    //let pct = smoothstep(0.0, 1.0, distance(vec2<f32>(0.5), st));
    let color = vec3(1.0 - pct) * vec3(1.0, 0.0, 0.0);

    return vec4<f32>(color, 1.0);
}

