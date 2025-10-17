# book-of-shaders
Working through The Book of Shaders (https://thebookofshaders.com/)

Instead of using GLSL -- which the book uses -- I will try to implement their examples using Rust, wgpu, and wgsl.

## TODO:
- [x] Make a full screen triangle using a vertex shader (just using indices, no vertex buffer yet)
- [ ] Color the triangle using a fragment shader
- [ ] Send the program uptime to the fragment shader, use this to change color over time
