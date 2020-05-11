#version 300 es
#define MAX_LIGHTS (10)

precision highp float;

in vec3 vertex_position;
in vec3 vertex_normal;
in vec2 vertex_texcoord;

uniform vec3 light_ambient;
uniform vec3 light_position[MAX_LIGHTS];
uniform vec3 light_color[MAX_LIGHTS];
uniform vec3 camera_position;
uniform float material_shininess;
uniform vec2 texture_scale;
uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

out vec3 ambient;
out vec3 diffuse;
out vec3 specular;
out vec2 frag_texcoord;

void main() {
    gl_Position = projection_matrix * view_matrix * model_matrix * vec4(vertex_position, 1.0);
    frag_texcoord = vertex_texcoord * texture_scale;

    vec3 world_pos = vec3(model_matrix * vec4(vertex_position, 1.0));

    diffuse = vec3(0,0,0);
    specular = vec3(0,0,0);
    
    for(int i=0; i<MAX_LIGHTS; i++) {
        vec3 l = normalize(light_position[i] - world_pos);
        vec3 n = normalize(vertex_normal);
        vec3 r = vec3(2,2,2)*dot(n, l)*vertex_normal - l;
        vec3 v = normalize(camera_position - world_pos);
        diffuse = diffuse + max(light_color[i] * dot(n, l), vec3(0,0,0));
        specular = specular + max(light_color[i] * pow(dot(r, v), material_shininess), vec3(0,0,0));
    }
    ambient = light_ambient;
}
