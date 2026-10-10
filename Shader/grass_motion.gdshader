shader_type canvas_item;

uniform float speed = 1.0;
uniform float min_strength = 0.05;
uniform float max_strength = 0.2;

void vertex() {
    // UV.y mendekati 0 berarti bagian ATAS rumput
    // UV.y mendekati 1 berarti bagian BAWAH rumput (akar)
    float is_top = 0.5 - UV.y; 
    
    // Rumus goyangan sinosuid
    float sway = sin(TIME * speed) * mix(min_strength, max_strength, is_top);
    
    // Terapkan gerakan ke koordinat X
    VERTEX.x += is_top * sway * 30.0;
}
