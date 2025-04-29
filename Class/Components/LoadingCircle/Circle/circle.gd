@tool
extends Node2D

@export var R:float :
	set(new):
		R = new
		%Sprite2D.scale = Vector2.ONE / 128.0 * R
