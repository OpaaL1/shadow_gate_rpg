extends CharacterBody2D

const speed = 100
var posisi_awal = "none"
var dash_speed = 300
var is_dash = false
var current_speed

#var hitbox
var health = 100
var stamina = 100
var player_alive = true

#state serangan
var attack_ip = false 
var can_attack = true

@onready var anim_player = $AnimationPlayer
@onready var animasi = $AnimatedSprite2D

func _ready():
    $AnimatedSprite2D.play("idle_down")

    if not $dashTimer.timeout.is_connected(_on_dash_timer_timeout):
        $dashTimer.timeout.connect(_on_dash_timer_timeout)

func _physics_process(delta):
    if not attack_ip:
        player_movement(delta)
        dash()
    
    attack()

# function untuk menentukan arah player
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

    #dash
    if is_dash:
        current_speed = dash_speed
    else:
        current_speed = speed
    velocity = arah * current_speed

    move_and_slide()

# function untuk menentukan animasi sesuai arah player
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

#function untuk membuat dash-effect
func dash():
    if Input.is_action_just_pressed("ui_text_backspace"):
        is_dash = true
        $dashTimer.start()	
        $ghostTimer.start()
        add_ghost()
        

func _on_dash_timer_timeout() -> void:
    is_dash = false
    $ghostTimer.stop()

const GHOST_SCENE = preload("res://Scene/actors/ghost.tscn")

#function copy ghost
func add_ghost():
    var ghost = GHOST_SCENE.instantiate()
    ghost.global_position = global_position
    ghost.texture = $AnimatedSprite2D.sprite_frames.get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.frame)
    ghost.flip_h = $AnimatedSprite2D.flip_h

    get_tree().root.add_child(ghost)

#function sword
func _on_sword_hit_area_entered(area: Area2D) -> void:
    var victim = area
    victim = area.owner
    print("Pedang menyentuh sesuatu: ", area.name)
    
    if victim.has_method("take_damage"):
        victim.take_damage(20)
        print("Musuh kena tebas")

func attack():
    var posisi = posisi_awal

    if Input.is_action_just_pressed("attack"):
        attack_ip = true
        can_attack = false

        if posisi == "up":
            animasi.flip_h = false
            anim_player.play("up_attack")
        elif posisi == "down":
            animasi.flip_h = false
            anim_player.play("down_attack")
        elif posisi == "right":
            animasi.flip_h = false
            anim_player.play("side_attack")
        elif posisi == "left":
            animasi.flip_h = true
            anim_player.play("side_attack_left")

        stamina -= 10
        print("Stamina sisa : ", stamina)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if "attack" in anim_name:
        attack_ip = false
        can_attack = true
