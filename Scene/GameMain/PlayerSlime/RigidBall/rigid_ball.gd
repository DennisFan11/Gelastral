extends RigidBody2D





#func _physics_process(delta: float) -> void:
	#if (get_global_mouse_position() - position).length() <= 10.0 and \
		#Input.is_action_pressed("L_click"):
		#apply_central_impulse((get_global_mouse_position() - position) * 300.0 * delta)
