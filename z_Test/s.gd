extends AnimatableBody2D
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("L_click"):
		position = get_global_mouse_position()
