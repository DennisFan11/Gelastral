class_name BlockShaderManager extends Node

enum TYPE { DIRT, STONE, COAL, IORN, COPPER }
static var palette = {
	TYPE.DIRT: Color("ab8465"),
	TYPE.STONE: Color("3e3551"),
	TYPE.COAL: Color("2c2c25"),
	TYPE.IORN: Color("c56d25"),
	TYPE.COPPER: Color("559642"),
}
static var shader = {
	#TYPE.DIRT: preload("uid://t3bes3wcqq3f"),
	#TYPE.STONE: preload("uid://ei6dj4tohmac")
	
}
