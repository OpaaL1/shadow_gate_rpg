extends ProgressBar

@onready var timer = $Timer
@onready var stamina_bar = $StaminaBar

var stamina = 0 : set = _set_stamina

func _set_stamina(new_stamina):
    var prev_stamina = stamina
    stamina = min(max_value, new_stamina)
    value = stamina

    if stamina < prev_stamina:
        timer.start()
    else:
        stamina_bar.value = stamina

func init_stamina(_stamina):
    stamina = _stamina
    max_value = stamina
    value = stamina
    stamina_bar.max_value = stamina
    stamina_bar.value = stamina

func _on_timer_timeout() -> void:
    stamina_bar.value = stamina
