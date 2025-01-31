extends Node2D

@export_group("length")
@export var default_length = 60
@export var length_var = .5

@export_group("angle")
@export var default_angle = deg_to_rad(45)
@export var angle_var = .4

var Bud_scene = preload("res://scenes/bud.tscn")
var root: Bud
var viable_buds: Array[Bud] = []

func _ready() -> void:
	## Add root node to middle of screen
	root = Bud_scene.instantiate()
	root.position = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	add_child(root)
	
	## Add a dummy root parent so root has a valid direction
	var dummy = Bud_scene.instantiate()
	var random_angle = randf_range(0, 2 * PI)
	# pythagoras
	dummy.position = Vector2(root.position.x + cos(random_angle), root.position.y + sin(random_angle))
	root.parent = dummy
	
	## Add root to viable buds list
	viable_buds.append(root)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		calculate_next_line()


func calculate_next_line() -> void:
	var new_length = randomize_value(default_length, length_var)
	var new_angle = randomize_value(default_angle, angle_var)
	
	## Possibly flip angle
	if randi() % 2 == 0:
		new_angle *= -1
	
	var child = root.spawn_child(new_length, new_angle)
	add_child(child)


func randomize_value(default: float, variance: float) -> float:
	return default * (1 + randf_range(-variance, variance))
