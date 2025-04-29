class_name MapData extends Resource

static var instance:MapData:
	get:
		if ! instance:
			instance = MapData.new()
		return instance

@export var spawn_point:Vector2 = Vector2(5000.0, -100.0)
@export var terrain_data:TerrainData



#region save Load

static func get_save_path()-> String:
	if not DirAccess.dir_exists_absolute("user://Map/PreGenMaps"):
		DirAccess.make_dir_recursive_absolute("user://Map/PreGenMaps")
	return "user://Map/PreGenMaps/"

static func save_map(file_name:String):
	ResourceSaver.save(instance, get_save_path()+file_name+".tres",0)

static func load_map(file_name:String):
	instance = ResourceLoader.load(get_save_path()+file_name+".tres", "MapData")


#endregion



#
