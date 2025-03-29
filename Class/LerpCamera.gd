class_name LerpCamera extends Camera2D

var target_position: Vector2 = Vector2.ZERO
var move_speed: float = 5.0

func _process(delta: float) -> void:
	offset = offset.lerp( target_position, move_speed * delta )

const ZOOM_SPEED = 0.1
func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("scroll_up"):
		var tween = get_tree().create_tween()
		tween.tween_property(self, "zoom", zoom*1.2, ZOOM_SPEED)
	if event.is_action_pressed("scroll_down"):
		var tween = get_tree().create_tween()
		tween.tween_property(self, "zoom", zoom*0.8, ZOOM_SPEED)
