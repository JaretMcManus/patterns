extends Node2D

@export var Bud = preload("res://scenes/bud.tscn")
var root: Bud

func _ready() -> void:
	root = Bud.instantiate()
	root.position = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	add_child(root)
	print("hi")
	
