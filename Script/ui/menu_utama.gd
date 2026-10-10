extends Control

@onready var indikator = $Indikator
@onready var v_box = $VBoxContainer

var fade_tween: Tween # Variabel tunggal untuk kontrol semua animasi fade

func _ready() -> void:
	indikator.modulate.a = 0
	# Animasi detak jantung tetap jalan
	var pulse = create_tween().set_loops()
	pulse.tween_property(indikator, "scale", Vector2(1.1, 1.1), 0.6)
	pulse.tween_property(indikator, "scale", Vector2(1.0, 1.0), 0.6)

func update_indicator_position(button: Button):
	# 1. Matikan tween fade yang sedang jalan (baik itu muncul atau hilang)
	if fade_tween:
		fade_tween.kill()
	
	# 2. Jalankan animasi MUNCUL (Fade In)
	fade_tween = create_tween()
	fade_tween.tween_property(indikator, "modulate:a", 1.0, 0.2)

	# 3. Hitung posisi dinamis
	var center_x = button.global_position.x + (button.size.x / 2)
	var text_width = button.get_theme_font("font").get_string_size(
		button.text, HORIZONTAL_ALIGNMENT_LEFT, -1, 
		button.get_theme_font_size("font_size")
	).x
	
	# Saya tambahkan -3 di koordinat Y agar posisi berlian lurus di tengah teks
	var target_pos = Vector2(
		center_x - (text_width / 2) - 15,
		button.global_position.y + (button.size.y / 2) - 3 
	)

	# 4. Animasi GERAK meluncur
	var move = create_tween()
	move.tween_property(indikator, "global_position", target_pos, 0.25)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

func _on_v_box_container_mouse_exited() -> void:
	# 5. Matikan tween muncul yang sedang jalan
	if fade_tween:
		fade_tween.kill()
		
	# 6. Jalankan animasi MENGHILANG (Fade Out)
	fade_tween = create_tween()
	fade_tween.tween_property(indikator, "modulate:a", 0.0, 0.3)

# --- Sisa kodingan Signal (Play, Setting, Quit) tetap sama ---

func _on_play_pressed() -> void:
	Global.player_current_attack = true
	get_tree().change_scene_to_file("res://Scene/world/world.tscn")

func _on_setting_pressed() -> void:
	print("Option pressed")
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_mouse_entered() -> void:
	update_indicator_position($VBoxContainer/Play)

func _on_setting_mouse_entered() -> void:
	update_indicator_position($VBoxContainer/Setting)

func _on_quit_mouse_entered() -> void:
	update_indicator_position($VBoxContainer/Quit)