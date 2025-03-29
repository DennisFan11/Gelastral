class_name Player extends Node

func respawn(pos:Vector2):
	%WallClimber.position = pos

func _ready() -> void:
	if self.get_parent() != get_tree().root:
		%TestNode.queue_free()

func _physics_process(delta: float) -> void:
	%BodyConstraint.position = _get_player_position()
	%BodyConstraint.constant_angular_velocity = _get_player_speed().x * 50.0
	

func _process(delta: float) -> void:
	
	var poly = %SlimeBody.get_points()
	poly = Geometry2DEX.smooth(poly, 60)
	%BodyPolygon.polygon = poly
	%BodyLine.points = poly
	
	%LerpCamera.target_position = _get_player_position()





#================== TOOL ================
func _get_player_speed()-> Vector2:
	return %WallClimber.velocity
func _get_player_position()-> Vector2:
	return %WallClimber.position




func _input(event: InputEvent) -> void:
	if event.is_action_pressed("L_click"):
		var pos = %WallClimber.get_global_mouse_position()
		%SlimeBody.apply_impulse(pos, (%SlimeBody.get_center()-pos).normalized() * 500.0)
