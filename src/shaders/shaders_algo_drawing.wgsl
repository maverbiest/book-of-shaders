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
    let a = smoothstep(pct - 0.02f, pct, st.y);
    let b = smoothstep(pct, pct + 0.02f, st.y);
    return a - b;
}

fn impulse(k: f32, x: f32) -> f32 {
    let h = k * x;
    return h * exp(1.0 - h);
}


@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = vec2<f32>(f32(shader_state.resolution_x), f32(shader_state.resolution_y));
    //flip the y-axis so 0.0 is at the bottom of the screen
    var st = vec2<f32>(in.position.x / resolution.x, 1.0f - (in.position.y / resolution.y));

    //let y = pow(st.x, 10.0);
    //let y = step(0.5, st.x);
    //let y = smoothstep(0.1, 0.9, st.x);
    //let y = smoothstep(0.2, 0.5, st.x) - smoothstep(0.5, 0.8, st.x);
    //let y = sin((shader_state.elapsed * st.x) * 3.14f * 1.0f);
    //let y = st.x % 0.5f;
    //let y = fract(st.x);
    let y = impulse(6.0, st.x);
    var color: vec3<f32> = vec3<f32>(y);

    let pct = plot_curve(st, y);
    color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);

    return vec4<f32>(color, 1.0);
}

