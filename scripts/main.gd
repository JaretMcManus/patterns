extends Node2D
@export var node_label: Label
var node_amount: int = 1
@export_group("length")
@export var default_length = 20
@export var length_var = .6

@export_group("angle")
@export var default_angle = deg_to_rad(45)
@export var angle_var = 0.3

@export_group("")
@export var RETRY_AMOUNT = 3
var Bud_scene = preload("res://scenes/bud.tscn")
var root: Bud
var viable_buds: Array[Bud] = []

func _physics_process(delta: float) -> void:
	Global.space_state = get_world_2d().direct_space_state
	if viable_buds.size() != node_amount:
		node_amount = viable_buds.size()
		node_label.set_text("Viable Nodes: %s" % node_amount)

	
	
func _ready() -> void:
	## Add root node to middle of screen
	root = Bud_scene.instantiate()
	root.position = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	add_child(root)
	root.queue_redraw()
	
	## Add a dummy root parent so root has a valid direction
	var dummy = Bud_scene.instantiate()
	var random_angle = randf_range(0, 2 * PI)
	# pythagoras
	dummy.position = Vector2(root.position.x + cos(random_angle), root.position.y + sin(random_angle))
	root.parent = dummy
	
	## Add root to viable buds list
	viable_buds.append(root)
	
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = .25
	timer.connect("timeout", _on_timeout)
	timer.start()
	
func _on_timeout():
	calculate_next_line()
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_next_line()

func get_next_line() -> void:
	while not await calculate_next_line(): 
		print("failed to make child")

func calculate_next_line() -> bool:
	var new_length = randomize_value(default_length, length_var)
	var new_angle = randomize_value(default_angle, angle_var)
	
	## Possibly flip angle
	if randi() % 2 == 0:
		new_angle *= -1
	
	## get random viable node
	var off_bud = viable_buds.pick_random()
	for i in range(RETRY_AMOUNT):
		var child = await off_bud.spawn_child(new_length, new_angle)
		if child:
			viable_buds.append(child)
			add_child(child)
			return true

	viable_buds.erase(off_bud)
	return false


func randomize_value(default: float, variance: float) -> float:
	return default * (1 + randf_range(-variance, variance))
