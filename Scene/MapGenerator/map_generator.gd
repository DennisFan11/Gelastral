class_name MapGenerator extends Node

var _thread_count:int = 1
var _screen_shooter_scene := preload("uid://d0wlq7akw4376")

const MAP_SIZE: Vector2 = Vector2(5, 5)

## 修改線程數量
func _on_thread_slider_value_changed(value: float) -> void:
	%ThreadLabel.text = str(int(value)) + " 線程"
	_thread_count = int(value)



## 開始對整張地圖分塊捷圖
func _on_save_button_pressed() -> void: # TODO FIXME
	_set_input_disabled(true)
	await _single_save()
	_set_input_disabled(false)

func _single_save():
	var data = TerrainData.new()
	var prog = 0.0
	var prog_max = MAP_SIZE.x * MAP_SIZE.y
	for i in range(MAP_SIZE.x):
		for j in range(MAP_SIZE.y):
			for z in await %ScreenShooter.scan_block(Vector2(i, j)):
				data.add_dict_to_key(z)
				print(z)
			prog += 1
			print_rich(_progress_bar(prog / prog_max))
	MapData.instance.terrain_data = data
	MapData.save_map("test")
	

#func _thread_save():
	#var thread_arr:Array[Thread] = []
	#var shooter_arr:Array[ScreenShooter] = []
	#var pos_arr:Array[Array] = []
	#
	#for i in range(_thread_count):
		#var node = _screen_shooter_scene.instantiate()
		#add_child(node)
		#shooter_arr.append(node)
		#pos_arr.append([])
		#thread_arr.append(Thread.new())
	#
	### 獲取所有要生成的座標
	#var need_pos = []
	#for i in range(MAP_SIZE.x):
		#for j in range(MAP_SIZE.y):
			#need_pos.append(Vector2(i, j))
	#
	### 設定線程資料
	#var id = 0
	#for i in need_pos:
		#pos_arr[id].append(i)
		#id += 1; if id >= pos_arr.size(): id = 0
	#
	### 啟動線程
	#for i in range(_thread_count):
		#thread_arr[i].start(_gen_block.bind(i, pos_arr[i], shooter_arr[i]))
	#
	### 等待所有線程完成
	#var map_data = MapData.new()
	#for i in thread_arr:
		#for j in await i.wait_to_finish():
			#map_data.add_dict_to_key(j)
	#
	#for i in shooter_arr:
		#i.queue_free()
	#
	#map_data.save_map("test") # FIXME

#func _gen_block(id:int, need_pos:Array[Vector2], node:ScreenShooter)-> Array[Dictionary]:
	#var return_data:Array[Dictionary] = []
	#for i in need_pos:
		#return_data += await node.scan_block(i)
	#return return_data

## 是否允許輸入
func _set_input_disabled(b:bool):
	%SaveButton.disabled = b
	%ThreadSlider.editable = !b
	%FileNameEdit.editable = !b


#--------------------------------Tool--------------------------

func _progress_bar(i:float)->String: #NOTE 輸出bbcode進度條
	
	const length:float = 20
	var boader = true
	var s = "\nprogress: ["
	for k in range(length):
		if (k/length)<i:
			s+= "[color=green]-[/color]"
		else:
			if boader:
				s+="|"
				boader = false
			s+= "-"
	s+= "]"
	return s
