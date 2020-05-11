#version 300 es
#define MAX_LIGHTS (10)

precision mediump float;

in vec3 frag_pos;
in vec3 frag_normal;
in vec2 frag_texcoord;

uniform vec3 light_ambient;
uniform vec3 light_position[10];
uniform vec3 light_color[10];
uniform vec3 camera_position;
uniform vec3 material_color;      // Ka and Kd
uniform vec3 material_specular;   // Ks
uniform float material_shininess; // n
uniform sampler2D image;          // use in conjunction with Ka and Kd

out vec4 FragColor;

void main() {
    vec3 diffuse = vec3(0.0, 0.0, 0.0);
    vec3 specular = vec3(0.0, 0.0, 0.0);
    
    for(int i=0; i<MAX_LIGHTS; i++) {
        vec3 l = normalize(light_position[i] - frag_pos);
        vec3 n = normalize(frag_normal);
        vec3 r = vec3(2.0, 2.0, 2.0)*dot(n,l)*n - l;
        vec3 v = normalize(camera_position - frag_pos);
        diffuse = diffuse + max(light_color[i] * dot(n, l), vec3(0.0, 0.0, 0.0));
        specular = specular + max(light_color[i] * pow(dot(r, v), material_shininess), vec3(0.0, 0.0, 0.0));
    }

    vec3 base_color = vec3(vec4(material_color, 1.0) * texture(image, frag_texcoord));
    FragColor = vec4(min(
        base_color * light_ambient + 
        base_color * diffuse +
        material_specular * specular,
        vec3(1,1,1)), 1.0);
}
