class_name SlimeBody extends Node
"""
MIT License  
Copyright (c) 2025 DennisFan11
Permission is granted to use, copy, modify, and distribute this software with attribution.  
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.  
"""

#region Interface

## 獲取點陣列
func get_points()-> PackedVector2Array:
	var arr = []
	for i in _body_point_arr:
		arr.append(i.position)
	return arr

## 施加衝擊
func apply_impulse(position: Vector2, vector: Vector2):
	#var comp = func(A:RigidBody2D, B:RigidBody2D):
		#return (A.position - position).length_squared() < (B.position - position).length_squared()
	
	## 尋找最近的 rigidbody
	var dist = func(r:RigidBody2D)-> float: return (r.position-position).length_squared()
	var target_body: RigidBody2D = _body_point_arr[0]
	var last_length: float = dist.call(target_body)
	for new in _body_point_arr:
		var new_length = dist.call(new)
		if new_length < last_length:
			target_body = new
			last_length = new_length
	
	## 施加衝擊
	target_body.apply_central_impulse(vector)

## 獲取中心點
func get_center()-> Vector2:
	var center:Vector2 = Vector2.ZERO
	var points:PackedVector2Array = get_points()
	
	for i in points:
		center += i
	center /= points.size()
	return center
	

#endregion






var player_pos:Vector2 = Vector2.ZERO

func _ready() -> void:
	_spawn_body(player_pos)

func _physics_process(delta: float) -> void:
	_area_constraint()
	if !Geometry2D.is_point_in_polygon(player_pos, get_points()):
		_spawn_body(player_pos)
	#_input_move() TEST
func _process(delta: float) -> void:
	pass

#==================== 內部實做 ========================================

## 節點陣列
var _body_point_arr: Array[RigidBody2D] = []


const BODY_POINT_SIZE = 20 # 30
const BODY_POINT_R = 50.0
## 生成節點
func _spawn_body(pos:Vector2):
	for i in get_children():
		i.queue_free()
	_body_point_arr = []
	for i in range(BODY_POINT_SIZE):
		var angle = (PI*2.0)/BODY_POINT_SIZE * -i
		var node = preload("uid://cvmlmayf7eo4r").instantiate()
		
		node.position = Vector2( sin(angle), cos(angle) ) * BODY_POINT_R + pos
		_body_point_arr.append( node )
		add_child( node )
	
	## 距離約束
	for i in range(BODY_POINT_SIZE):
		var node = PinJoint2D.new()
		var a = _body_point_arr[i]
		var b = _body_point_arr[(i+1) % BODY_POINT_SIZE]
		node.node_a = a.get_path()
		node.node_b = b.get_path()
		node.position = (a.position + b.position) / 2.0
		add_child(node)

const AREA = 7000.0
const CORRECTION_STRENGTH := 0.005
## 氣壓約束
func _area_constraint():
	const MAX_CORRECTION_STRENGTH = 50000.0  # 限制最大氣壓修正力度
	var polygon: PackedVector2Array = []
	var speed:PackedVector2Array = []
	for i in _body_point_arr:
		polygon.append(i.position)

	var area_error = (AREA - _calculate_polygon_area(polygon)) 
	#print("pressure: ", area_error)
	area_error *= CORRECTION_STRENGTH
	var correction_strength = clamp(area_error, -MAX_CORRECTION_STRENGTH, MAX_CORRECTION_STRENGTH)  # 限制修正力度

	for i in range(BODY_POINT_SIZE):
		var normal = _get_normal(polygon, i)
		speed.append(normal * correction_strength)
	for i in range(BODY_POINT_SIZE):
		_body_point_arr[i].apply_central_impulse(speed[i])

## 推離一定距離
func _push(pos:Vector2):
	const LENGTH = 37.0
	const FORCE = 80.0
	for i in range(BODY_POINT_SIZE):
		var target = pos
		var origin = _body_point_arr[i].position
		if (target - origin).length() >= LENGTH:
			continue
		var r_target = _vec2_resize(target, origin, LENGTH)
		_body_point_arr[i].apply_central_impulse(
			(r_target - origin) * FORCE
		)


#==================== TOOL ========================================

## 計算法向量
func _get_normal(polygon: PackedVector2Array, id: int) -> Vector2:
	var prev_point = polygon[(id - 1 + polygon.size()) % polygon.size()]
	var next_point = polygon[(id + 1) % polygon.size()]
	return (next_point - prev_point).orthogonal().normalized()


## 計算多邊形大小
func _calculate_polygon_area(polygon: PackedVector2Array) -> float:
	var n = polygon.size()
	if n < 3:
		return 0.0  # 至少需要 3 个点才能形成多边形

	var area = 0.0
	for i in range(n):
		var j = (i + 1) % n  # 下一个顶点（循环回第一个点）
		area += polygon[i].x * polygon[j].y - polygon[j].x * polygon[i].y

	return abs(area) * 0.5

## 鼠標拖曳 TEST
#func _input_move():
	#if Input.is_action_pressed("L_click"):
		#_push($"..".get_global_mouse_position())

func _vec2_resize(resize_origin:Vector2, target:Vector2, new_length:float)-> Vector2:
	return (target - resize_origin).normalized()*new_length + resize_origin














#
