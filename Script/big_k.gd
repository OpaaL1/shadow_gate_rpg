extends CharacterBody2D
var speed = 50
var chase_player = false
var player = null
var stopping_distance = 30

func  _physics_process(delta: float) -> void:
    if chase_player and player:
        # 1. Hitung jarak ke player
        var arah = (player.position - position).normalized()
        var distance = position.distance_to(player.position)
        
        # 2. Hanya bergerak jika jarak lebih besar dari stopping_distance
        if distance > stopping_distance:
            velocity = arah * speed
            move_and_slide()
            update_animation(arah)
        else:
            # Jika sudah dekat, berhenti bergerak tapi tetap hadap player (opsional)
            velocity = Vector2.ZERO
            update_idle_animation(arah)
    else:
        velocity = Vector2.ZERO # Pastikan berhenti saat tidak mengejar
        $AnimatedSprite2D.play("idle_front")

func update_animation(dir: Vector2):
    if abs(dir.x) > abs(dir.y): # ceh arah lebih ke horizontal atau vertikal
        $AnimatedSprite2D.play("walk_side")
        $AnimatedSprite2D.flip_h = dir.x > 0
    else:
        if dir.y > 0:
            $AnimatedSprite2D.play("walk_front")
        else:
            $AnimatedSprite2D.play("walk_back")

func update_idle_animation(dir: Vector2):
    if abs(dir.x) > abs(dir.y): # ceh arah lebih ke horizontal atau vertikal
        $AnimatedSprite2D.play("idle_side")
        $AnimatedSprite2D.flip_h = dir.x > 0
    else:
        if dir.y > 0:
            $AnimatedSprite2D.play("idle_front")
        else:
            $AnimatedSprite2D.play("idle_back")


func _on_area_2d_body_entered(body: Node2D) -> void:
    player = body
    chase_player = true
    

func _on_area_2d_body_exited(body: Node2D) -> void:
    player = null
    chase_player = false
