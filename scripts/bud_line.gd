class_name BudLine extends Node2D

@export_group("Connected Nodes")
@export var line: Line2D
@export var area: Area2D
@export var collision_shape: CollisionShape2D

func init(parent_pos: Vector2, child_pos: Vector2):
	create_line(parent_pos, child_pos)
	create_hitbox(parent_pos, child_pos)


func create_line(parent_pos: Vector2, child_pos: Vector2):
	line.default_color = Global.COLOR
		
	line.add_point(Vector2.ZERO)
	line.add_point(child_pos - parent_pos)


func create_hitbox(start: Vector2, end: Vector2):
	var rect := RectangleShape2D.new()
	var length = start.distance_to(end)
	rect.set_size(Vector2(length, 25/3.0))
	
	collision_shape.shape = rect
	collision_shape.position = (end - start) / 2
	collision_shape.rotation = start.direction_to(end).angle()
	
