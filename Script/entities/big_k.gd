extends CharacterBody2D
var speed = 50
var chase_player = false
var player = null
var stopping_distance = 30

@onready var animated_sprite_2d: AnimatedSprite2D = $pivot/AnimatedSprite2D
@onready var healthbar = $CanvasLayer/Healtbar
#var hitbox
var health = 150
var is_dead = false

func _ready() -> void:
    healthbar.init_health(health)


func  _physics_process(delta: float) -> void:
    if chase_player and player:
        var arah = (player.position - position).normalized() #menghitung jarak player
        var distance = position.distance_to(player.position)
 
        if distance > stopping_distance: #mengecek jarak player dengan enemy
            velocity = arah * speed
            move_and_slide()
            update_animation(arah)
        else:
            velocity = Vector2.ZERO
            update_idle_animation(arah)
    else:
        velocity = Vector2.ZERO # Pastikan berhenti saat tidak mengejar
        animated_sprite_2d.play("idle_front")


func update_animation(dir: Vector2):
    if abs(dir.x) > abs(dir.y): 
        animated_sprite_2d.play("walk_side")
        if dir.x > 0:
            $pivot.scale.x = -1
        else:
            $pivot.scale.x = 1
    else:
        $pivot.scale.x = 1
        if dir.y > 0:
            animated_sprite_2d.play("walk_front")
        else:
            animated_sprite_2d.play("walk_back")

func update_idle_animation(dir: Vector2):
    if abs(dir.x) > abs(dir.y): 
        animated_sprite_2d.play("idle_side")
        if dir.x > 0:
            $pivot.scale.x = -1
        else:
            $pivot.scale.x = 1
    else:
        $pivot.scale.x = 1
        if dir.y > 0:
            animated_sprite_2d.play("idle_front")
        else:
            animated_sprite_2d.play("idle_back")


func _on_area_2d_body_entered(body: Node2D) -> void:
    player = body
    chase_player = true
    

func _on_area_2d_body_exited(body: Node2D) -> void:
    player = null
    chase_player = false

func enemy():
    pass

func take_damage(amount):
    health -= amount
    print("Darah musuh sisa: ", health)

    if health <= 0:
        die()

    healthbar.health = health

func die():
    is_dead = true
    print("Musuh Mati!")
    queue_free()
