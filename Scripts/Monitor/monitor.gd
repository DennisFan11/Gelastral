extends Node
func _process(delta: float) -> void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	%FPSLabel.text = "fps: " + str(fps)
