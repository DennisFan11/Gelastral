class_name MapData extends Resource

@export var terrain:Dictionary = {}
# {"ID":ID, "PosID":PosID, "Polygon":Polygon}
"""
{
	key: [{"ID":ID, "PosID":Position, "Polygon":Polygon}, ...],
	key: [{"ID":ID, "PosID":Position, "Polygon":Polygon}, ...],
}
"""
#region Save

## 將實例寫入存檔 (由MapManager使用)
func add_instance_block_to_key( block:DestroyableBlock ):
	add_block_to_key(block.ID, block.PosID, block.Polygon)

## 將實例寫入存檔 (由MapGenerator使用)
func add_dict_to_key( dict:Dictionary ):
	add_block_to_key(dict["ID"], dict["PosID"], dict["Polygon"])

## 將block 資料寫入存檔 
func add_block_to_key(ID:int, PosID:Vector2, Polygon:PackedVector2Array):
	var new:Array = []
	if terrain.has(PosID): ## 擁有 key 就裁剪
		var old:Array = terrain[PosID]
		for i in old: # 切割所有舊方塊
			var new_polygons = Geometry2D.clip_polygons(i["Polygon"], Polygon)
			for new_polygon in new_polygons:
				new.append( block_to_dict(ID, PosID, new_polygon) )
	new.append(block_to_dict(ID, PosID, Polygon)) # 添加新方塊
	terrain[PosID] = new

static func block_to_dict(ID:int, PosID:Vector2, Polygon:PackedVector2Array):
	return {"ID":ID, "PosID":PosID, "Polygon":Polygon}
static func get_save_path()-> String:
	if not DirAccess.dir_exists_absolute("res://Map/PreGenMaps"):
		DirAccess.make_dir_recursive_absolute("res://Map/PreGenMaps")
	return "res://Map/PreGenMaps/"

func save_map(file_name:String):
	ResourceSaver.save(self, get_save_path()+file_name+".tres",0)
#endregion

#region Load


static func load_map(file_name:String)-> MapData:
	return ResourceLoader.load(get_save_path()+file_name+".tres", "MapData")

func spawn_blocks():
	for i in terrain.values():
		for j in i:
			MapManager.add_DestroyableBlock(
				DestroyableBlock.new( j["ID"], j["PosID"], j["Polygon"] )
			)
#endregion



#
