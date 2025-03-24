extends Node

func _ready() -> void:
	_spawn_body()
func _physics_process(delta: float) -> void:
	#_test_move()
	#_distance_constraint()
	#_area_constraint()
	_test_move()
	_set_camera()

const BODY_POINT_SIZE = 30
const BODY_POINT_R = 50.0

var _body_point_arr: Array = []

func _spawn_body():
	for i in range(BODY_POINT_SIZE):
		var angle = (PI*2.0)/BODY_POINT_SIZE * -i
		var node = preload("uid://cvmlmayf7eo4r").instantiate()
		
		node.position = Vector2( sin(angle), cos(angle) ) * BODY_POINT_R
		_body_point_arr.append( node )
		add_child( node )
		#node.linear_damp = DAMPING
	
	for i in range(BODY_POINT_SIZE):
		_body_point_arr[i].front = _body_point_arr[(i+1) % BODY_POINT_SIZE]
		_body_point_arr[i].back = _body_point_arr[(i-1)]
		
	for i in range(BODY_POINT_SIZE):
		var join = preload("uid://der36220txty8").instantiate()
		
		join.node_a = _body_point_arr[i].get_path()
		join.node_b = _body_point_arr[(i+1) % BODY_POINT_SIZE].get_path()
		print(join.node_a, join.node_b)
		add_child(join)




const FIX_SPEED: = 40.0
const MAX_DISTANCE := 5.0
const DAMPING := 1.5
#const G = 5.0
#
#func _distance_constraint():
	#for i in range(BODY_POINT_SIZE):
		#var body_a = _body_point_arr[i]
		#var body_b = _body_point_arr[(i+1) % BODY_POINT_SIZE]
		#
		## 计算当前两刚体之间的距离差
		#var delta = body_b.position - body_a.position
		#var current_distance = delta.length()
		#var error = current_distance - MAX_DISTANCE
		#
		## 如果当前距离超过允许的最大距离，则施加修正冲量
		#if error > 0:
			## 修正量取一半分别施加给 body_a 和 body_b，确保整体平衡
			#var correction = delta.normalized() * error * 0.5 * FIX_SPEED
			##body_a.velocity += correction
			##body_b.velocity += -correction
			#body_a.apply_central_impulse(correction)
			#body_b.apply_central_impulse(-correction)


const AREA = 10.0
const MAX_CORRECTION_STRENGTH = 30.0  # 限制最大修正力度

func _area_constraint():
	var polygon: PackedVector2Array = []
	for i in _body_point_arr:
		polygon.append(i.position)

	var area_error = AREA - _calculate_polygon_area(polygon)
	var correction_strength = clamp(area_error * 0.01, -MAX_CORRECTION_STRENGTH, MAX_CORRECTION_STRENGTH)  # 限制修正力度

	for i in range(BODY_POINT_SIZE):
		var normal = _get_normal(polygon, i)
		_body_point_arr[i].apply_central_impulse(normal * correction_strength)



func _get_normal(polygon: PackedVector2Array, id: int) -> Vector2:
	if polygon.size() < 2:
		return Vector2.ZERO  

	# 取前一个点、当前点、下一个点
	var prev_point = polygon[id - 1] if id > 0 else polygon[-1]
	var curr_point = polygon[id]
	var next_point = polygon[(id + 1) % polygon.size()]

	# 计算两条边的法线并求平均
	var tangent1 = (curr_point - prev_point).normalized()
	var tangent2 = (next_point - curr_point).normalized()
	var normal1 = Vector2(-tangent1.y, tangent1.x)
	var normal2 = Vector2(-tangent2.y, tangent2.x)

	# 平均化法线并归一化
	var avg_normal = (normal1 + normal2).normalized()

	return avg_normal



func _calculate_polygon_area(polygon: PackedVector2Array) -> float:
	var n = polygon.size()
	if n < 3:
		return 0.0  # 至少需要 3 个点才能形成多边形

	var area = 0.0
	for i in range(n):
		var j = (i + 1) % n  # 下一个顶点（循环回第一个点）
		area += polygon[i].x * polygon[j].y - polygon[j].x * polygon[i].y

	return abs(area) * 0.5




#====================Test AREA========================================




func _test_move():
	if Input.is_action_pressed("L_click"):
		_body_point_arr[0].apply_central_impulse(
			(_body_point_arr[0].get_global_mouse_position() - _body_point_arr[0].position) * FIX_SPEED
		)
		#_body_point_arr[0].position = _body_point_arr[0].get_global_mouse_position()


func _set_camera():
	var center_pos = Vector2.ZERO
	for i in _body_point_arr:
		center_pos += i.position
	center_pos /=BODY_POINT_SIZE
	%Camera2D.offset = center_pos
	#%Camera2D.offset = _body_point_arr[0].position














#
