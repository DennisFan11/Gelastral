## MapManager 充當 地圖物件工廠
extends Node2D

const BLOCK_SIZE:Vector2 = Vector2(100.0, 100.0)

#region DestroyableBlock 操作區域

func add_DestroyableBlock( node:DestroyableBlock ): # FIXME WIP
	add_child(node) 

func clip( global_polygon:PackedVector2Array ):
	for i in _get_collide_bodies(global_polygon):
		if i.is_in_group("Block"):
			var block:DestroyableBlock = i.get_parent()
			block.Clip(global_polygon)

## 高壓場景專用
func clip_after( global_polygon:PackedVector2Array ):
	for i in _get_collide_bodies(global_polygon):
		if i.is_in_group("Block"):
			var block:DestroyableBlock = i.get_parent()
			block.After_Optimize_Clip(global_polygon)

var merge_busy:bool = false
## NOTE 合併所有相同id物件, 並切割不同id物件, 時間過後自分裂
func merge( global_polygon:PackedVector2Array, id:int ):
	merge_busy = true
	
	var marge_node:DestroyableBlock = null
	var bodies:Array[Node2D] = _get_collide_bodies(global_polygon)
	
	#for i in range(bodies.size()): # ATTENTION 導致 Bug
		#if bodies[i].is_in_group("Block") and bodies[i].get_parent().ID == id:
			#marge_node = bodies.pop_at(i).get_parent()
			#marge_node.Merge(global_polygon)
			#break
	if !marge_node: # 相同id實例不存在
		marge_node = DestroyableBlock.new(id, _get_GridPos_from_polygon(global_polygon), global_polygon)
		add_DestroyableBlock(marge_node)
		marge_node.Merge(PackedVector2Array()) ### NOTE 手動觸發自分裂
		
	for i in bodies:
		
		if i.is_in_group("Block"):
			var block:DestroyableBlock = i.get_parent()
			if block.ID == id:
				await marge_node.Merge(block.Polygon)
				block.queue_free() 
			else:
				block.Clip(global_polygon)
	merge_busy = false

#endregion End of DestroyableBlock 操作區域

## 用於提示玩家的純視覺節點
func add_hint_node(node:Node2D): # FIXME WIP
	add_child(node)

var _dict:Dictionary = {}
func spawn_item( _name:String ): # FIXME WIP
	pass







#--------------------------內部實作---------------------------





func _ready() -> void:
	DestroyableBlock.BlockSize = BLOCK_SIZE

## 推算網格座標
func _get_GridPos_from_polygon( global_polygon:PackedVector2Array )-> Vector2:
	var center:Vector2
	for i in global_polygon:
		center += i
	center /= global_polygon.size()
	return (center/BLOCK_SIZE).floor()*BLOCK_SIZE

## 2D 物理空間查詢
func _get_collide_bodies( global_polygon:PackedVector2Array )-> Array[Node2D]:
	var shape_rid = PhysicsServer2D.convex_polygon_shape_create() # 凸多邊形
	PhysicsServer2D.shape_set_data(shape_rid, global_polygon)

	var params = PhysicsShapeQueryParameters2D.new()
	params.shape_rid = shape_rid
	params.collide_with_areas = false
	params.collide_with_bodies = true
	
	var result: Array[Node2D] = []
	for i in get_world_2d().direct_space_state.intersect_shape(params):
		result.append(i["collider"])
	
	PhysicsServer2D.free_rid(shape_rid)
	return result
