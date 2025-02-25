class_name ScreenShooter extends Node



## 返回 [{"ID":ID, "PosID":PosID, "Polygon":Polygon}]
func scan_block(
		block_id:Vector2, 
		map_size: Vector2 = Vector2(5, 5), # 地圖尺寸
		block_size: Vector2 = MapManager.BLOCK_SIZE, # 方塊尺寸
		precision: Vector2 =  Vector2.ONE # 掃描精度
	)-> Array[Dictionary]:
	
	%MapShader.set_size(map_size * block_size)
	%MapShader.position = (map_size * block_size)/2.0
	%Viewport.size = block_size * precision
	
	%Camera2D.offset = (block_id * block_size) + Vector2.ONE * (block_size/2.0)
	%Camera2D.zoom = precision
	for i:Node2D in %MapShader.get_scan_array():
		i.visible = false
	
	var block_arr:Array[Dictionary] = []
	
	for layer in range(%MapShader.get_scan_array().size()):
		
		# NOTE 截圖
		%MapShader.get_scan_array()[layer].visible = true
		await RenderingServer.frame_post_draw
		var img = %Viewport.get_texture().get_image()
		%MapShader.get_scan_array()[layer].visible = false
		
		var bitmap = BitMap.new()
		bitmap.create_from_image_alpha(img, 0.9)
		var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(), bitmap.get_size()), 5.0)
		
		for i in range(polygons.size()): # Re_scale
			for j in range(polygons[i].size()):
				polygons[i][j] = polygons[i][j]/precision + (block_id * block_size)
		# NOTE 對 polygons 進行處理
		for polygon in polygons:
			block_arr.append(MapData.block_to_dict(
				layer, 
				block_id, 
				GeometryTool.VertexOptimization(polygon, polygon, block_size)
			))
	return block_arr






#
		
