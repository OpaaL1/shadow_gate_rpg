extends CharacterBody2D

const speed = 100
var posisi_awal = "none"

func _ready():
	$AnimatedSprite2D.play("idle_down")

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	var x_arah = Input.get_axis("ui_left", "ui_right") #inputan untuk arah kiri kanan
	var y_arah = Input.get_axis("ui_up", "ui_down") #inputan untuk arah atas bawah
	var arah = Vector2 (x_arah, y_arah).normalized()

	velocity = arah * speed
	
	if x_arah != 0:
		if x_arah > 0:
			posisi_awal = "right"
		else:
			posisi_awal = "left"
	elif y_arah != 0:
		if y_arah > 0:
			posisi_awal = "down"
		else:
			posisi_awal = "up" 
	
	if arah != Vector2.ZERO:
		play_anim(1)
	else :
		play_anim(0)

	move_and_slide()

func play_anim(movement):
	var posisi = posisi_awal
	var animasi = $AnimatedSprite2D

	if posisi == "right":
		animasi.flip_h = false
		if movement == 1:
			animasi.play("run_side")
		elif movement == 0:
			animasi.play("idle_side")
	elif posisi == "left":
		animasi.flip_h = true
		if movement == 1:
			animasi.play("run_side")
		elif movement == 0:
			animasi.play("idle_side")
	elif posisi == "down":
		animasi.flip_h = false
		if movement == 1:
			animasi.play("run_down")
		elif movement == 0:
			animasi.play("idle_down")
	elif posisi == "up":
		animasi.flip_h = false
		if movement == 1:
			animasi.play("run_up")
		elif movement == 0:
			animasi.play("idle_up")

	
