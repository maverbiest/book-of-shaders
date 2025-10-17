# book-of-shaders
Working through The Book of Shaders (https://thebookofshaders.com/)

Instead of using GLSL -- which the book uses -- I will try to implement their examples using Rust, wgpu, and wgsl.

## TODO:
- [x] Make a full screen triangle using a vertex shader (just using indices, no vertex buffer yet)
- [x] Color the triangle using a fragment shader
- [ ] Because the triangle extends beyond the screen, we can't simply use the coordinates from the triangle for setting the colour. Instead, we should create a bind group that contains the screen resolution and use this to normalise @builtin(frag_coord) in the fragment shader
- [ ] Send the program uptime to the fragment shader, use this to change color over time
