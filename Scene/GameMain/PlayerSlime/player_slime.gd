extends CharacterBody2D

func _ready() -> void:
	if self.get_parent() != get_tree().root:
		%TestNode.queue_free()
