class_name Bud extends Node2D

var children: Array[Bud] = []
var parent: Bud
@export var Line: Line2D
var Bud_scene = preload("res://scenes/bud.tscn")

func _ready() -> void:
	pass

func spawn_child(length: float, angle: float) -> Bud:
	## Get the out_line (line through the parent and self)
	var out_line: Vector2 = (parent.position - self.position).normalized()
	out_line *= length # scale to length
	
	## rotate line
	var child_position_offset = out_line.rotated(angle)
	
	## Make child
	var child: Bud = Bud_scene.instantiate()
	child.position = self.position + child_position_offset
	child.queue_redraw()
	## Connect Line2d
	
	## Make Collision shape
	
	return child
	
	
