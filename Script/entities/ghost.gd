extends Sprite2D

func _ready() -> void:
    var tween = get_tree().create_tween()
    tween.tween_property(self, "modulate:a", 0.0, 0.3)
    tween.tween_callback(queue_free)