class_name LoadingCircle extends Node2D

var scene = preload("res://Class/Components/Circle/Circle.tscn")
var circles:Array[Circle] = []

func _ready() -> void:
	for i in range(CIRCLE_COUNT):
		var node:Circle = scene.instantiate()
		add_child(node)
		circles.append(node)
		node.R = CIRCLE_R

const CIRCLE_COUNT = 3
const R = 35.0
const CIRCLE_R = 30.0
const SPEED = 8.0
func _process(delta: float) -> void:
	var time = Time.get_unix_time_from_system()
	for i in range(CIRCLE_COUNT):
		var angle = time*SPEED + PI*2/CIRCLE_COUNT*i
		circles[i].position = Vector2(cos(angle), sin(angle)) * R








#
