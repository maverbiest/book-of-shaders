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

fn ease_in_out_sine(x: f32) -> f32 {
    return -(cos(3.14f * x) - 1.0f) / 2.0f;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = vec2<f32>(f32(shader_state.resolution_x), f32(shader_state.resolution_y));
    //flip the y-axis so 0.0 is at the bottom of the screen
    var st = vec2<f32>(in.position.x / resolution.x, 1.0f - (in.position.y / resolution.y));

    var pct = vec3<f32>(st.x);
    pct.r = step(st.x, 0.0);
    pct.b = step(st.x, 0.33);
    pct.g = step(st.x, 0.66);
    //pct.r = smoothstep(0.0, 1.0, st.x);
    //pct.g = sin(st.x * 3.14);
    //pct.b = pow(st.x, 0.5);

    var color_a: vec3<f32> = vec3<f32>(0.149, 0.141, 0.912);
    var color_b: vec3<f32> = vec3<f32>(1.0, 0.833, 0.224);


    var color = mix(color_a, color_b, pct);

    color = mix(color, vec3<f32>(1.0, 0.0, 0.0), plot_curve(st, pct.r));
    color = mix(color, vec3<f32>(0.0, 1.0, 0.0), plot_curve(st, pct.g));
    color = mix(color, vec3<f32>(0.0, 0.0, 1.0), plot_curve(st, pct.b));

    return vec4<f32>(color, 1.0);
}

