extends RigidBody2D

const MAX_DISTANCE := 10.0
var front:RigidBody2D
var back:RigidBody2D

#func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#var pos = state.transform.origin
	#if (front.position - pos).length()>= MAX_DISTANCE:
		#pos = _vec2_resize(front.position, pos, MAX_DISTANCE/2.0)
	#if (back.position - pos).length()>= MAX_DISTANCE:
		#pos = _vec2_resize(back.position, pos, MAX_DISTANCE/2.0)
	#state.transform.origin = pos
	#reset_physics_interpolation.call_deferred()
	##position = pos

func _vec2_resize(pos:Vector2, target:Vector2, new_length:float)-> Vector2:
	return (target - pos).normalized()*new_length + pos


#
