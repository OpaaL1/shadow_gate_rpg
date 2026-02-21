extends CharacterBody2D

const speed = 100
var posisi_awal = "none"

func _ready():
	$AnimatedSprite2D.play("idle_down")

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):

	if Input.is_action_pressed("ui_right"):
		posisi_awal = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		posisi_awal = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		posisi_awal = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		posisi_awal = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
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

	
