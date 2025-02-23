class_name DestroyableBlock
extends SLable


var _base_scene:DestoryableBlockBaseScene
## 分塊大小用於自動切割
static var BlockSize: Vector2

var Busy:bool = false

var ID:int:
	set(new):
		ID = new
		_base_scene.ID = new
var Position:Vector2:
	set(new):
		Position = new
		_base_scene.Position = new
var Polygon:PackedVector2Array: # global polygon FIXME 原本為 local
	set(new):
		if Geometry2D.triangulate_polygon(new).size() == 0:
			queue_free()
			return
		#new = Geometry2D.convex_hull(new)
		Polygon = new
		_base_scene.Polygon = new


#region SLable 實做區域

func _save_dict()-> Dictionary:
	return {"ID":ID, "Position":Position, "Polygon":Polygon}
func _load_dict(dict: Dictionary):
	ID = dict["ID"]
	Position = dict["Position"]
	Polygon = dict["Polygon"]

#endregion

## 創建新的實例
func _init(_id:int, _position:Vector2, _polygon:PackedVector2Array) -> void:
	var file := preload("res://MapObjects/DestroyableBlock/BaseScene/DestoryableBlock_BaseScene.tscn")
	_base_scene = file.instantiate()
	add_child(_base_scene)
	ID = _id; Position = _position; Polygon = _polygon
	


func Clip(global_polygon:PackedVector2Array)-> float:
	var value = _clip(global_polygon)
	return value

func Merge(global_polygon:PackedVector2Array)-> float:
	var value = _merge(global_polygon)
	#print("merge ", value)
	return value

func After_Optimize_Clip(global_polygon:PackedVector2Array)-> float:
	var value = _after_optimize_clip(global_polygon)
	return value





#region  實作

#region Tools (to_global, to_local, _group_spawn)

func _group_spawn(id:int, pos:Vector2, global_polygon_arr:Array[PackedVector2Array]):
	for global_polygon:PackedVector2Array in global_polygon_arr:
		MapManager.add_DestroyableBlock(DestroyableBlock.new(id, pos, global_polygon))
#endregion


var _split_timer:Timer
var _optimize_timer:Timer

func _gen_timers():
	_split_timer = Timer.new()
	add_child(_split_timer)
	_split_timer.timeout.connect(_self_split)
	_split_timer.one_shot = true
	
	_optimize_timer = Timer.new()
	add_child(_optimize_timer)
	_optimize_timer.timeout.connect(_self_optimize)
	_optimize_timer.one_shot = true


func _set_split_timer():
	if _split_timer:
		_split_timer.start(1.0)
	else:
		_gen_timers()
func _set_optimize_timer():
	if _optimize_timer:
		_optimize_timer.start(1.0)
	else:
		_gen_timers()



func _self_split(): # 區塊優化
	var BLOCK_SIZE = BlockSize.x
	var arr_pos = []
	var arr_poly:Array[PackedVector2Array] = [] # global polygon arr
	var R= 8 # 擴張涉及的區塊 越大的單次擴張需要越大的值
	for x in range(-R,R+1): # 初始化 座標及多邊形陣列
		for y in range(-R,R+1):
			var pos = Vector2(x,y)*BLOCK_SIZE + Position
			arr_pos.append(pos)
			arr_poly.append(PackedVector2Array([
				Vector2(pos.x,pos.y),
				Vector2(pos.x+BLOCK_SIZE,pos.y),
				Vector2(pos.x+BLOCK_SIZE,pos.y+BLOCK_SIZE),
				Vector2(pos.x,pos.y+BLOCK_SIZE)
			]))
	# 相交生成
	for i in range(arr_pos.size()):
		var need_polygons = Geometry2D.intersect_polygons(Polygon, arr_poly[i])
		_group_spawn(ID, arr_pos[i], need_polygons)
	queue_free()
	return

var last_origin:PackedVector2Array = []
func _self_optimize():
	Polygon = (GeometryTool.VertexOptimization(Polygon, last_origin, BlockSize))
	last_origin = []

func _clip(global_polygon:PackedVector2Array)-> float:
	var origin = Polygon
	var clipped := Geometry2D.clip_polygons(origin, global_polygon)
	if clipped.size() == 0:
		queue_free()
		return GeometryTool.Calculate_polygon_area(origin, global_polygon)
	
	for i in range(clipped.size()):# 全體頂點優化
		clipped[i] = GeometryTool.VertexOptimization(clipped[i], origin, BlockSize)
	clipped = GeometryTool.Merge_hole_polygon(clipped) # 合併有孔多邊形
	Polygon = (clipped.pop_front()) # 重設自身多邊形
	_group_spawn(ID, Position, clipped) # 實例化剩餘多邊形
	return GeometryTool.Calculate_polygon_area(origin, global_polygon) # 面積計算

func _merge(global_polygon:PackedVector2Array)->float:
	var origin = Polygon
	var merged = Geometry2D.merge_polygons(origin, global_polygon)
	if merged.size() == 0:
		assert(false)
		queue_free()
		return GeometryTool.Calculate_polygon_area(origin, global_polygon)
	
	#for i in range(merged.size()):# 全體頂點優化
		#merged[i] = VertexOptimization(merged[i], origin, BlockSize)
	### BUG 沒有帶孔多邊形合併
	Polygon = (merged.pop_front()) # 重設自身多邊形
	_group_spawn(ID, Position, merged) # 實例化剩餘多邊形
	
	### ATTENTION Self Split timer start
	_set_split_timer()
	
	return GeometryTool.Calculate_polygon_area(origin, global_polygon) # 面積計算

func _after_optimize_clip(global_polygon:PackedVector2Array)-> float: # TEST 高壓場景用
	Busy = true
	var origin = Polygon
	var clipped = Geometry2D.clip_polygons(origin, global_polygon)
	if clipped.size() == 0:
		queue_free()
		return GeometryTool.Calculate_polygon_area(origin, global_polygon)
	clipped = GeometryTool.Merge_hole_polygon(clipped) # 合併有孔多邊形
	Polygon = (clipped.pop_front()) # 重設自身多邊形
	_group_spawn(ID, Position, clipped) # 實例化剩餘多邊形
	
	### ATTENTION Self optimize timer start
	if last_origin.size() == 0:
		last_origin = origin
	_set_optimize_timer()
		
	Busy = false
	
	return GeometryTool.Calculate_polygon_area(origin, global_polygon) # 面積計算

#endregion

#
