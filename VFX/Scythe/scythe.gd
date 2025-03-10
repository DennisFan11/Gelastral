@tool

extends Node2D



const R = 30.0
const R_X = 30.0
const R_Y = 15.0
const POINT = 30
@export_tool_button("gen_point") var dosome = gen_point

func gen_point():
	var points:PackedVector2Array = []
	const START_AT = PI/4.0
	const END_AT = 7.0*PI/4.0
	for i in range(POINT):
		var angle = START_AT + (END_AT-START_AT)/POINT*i
		points.append( Vector2(-cos(angle) * R_X, -sin(angle) * R_Y) )
	%Line2D.points = points
	print("point gened !")
