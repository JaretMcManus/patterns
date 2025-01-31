class_name Bud extends Node2D


var bud_children: Array[Bud] = []
var child_areas: Array[Area2D] = []
var parent: Bud

#var negative_open: bool = true
#var positive_open: bool = true

@export_group("Drawing")
var COLOR: Color = Global.COLOR
@export_subgroup("Line")
var Line: Line2D
@export var LINE_WIDTH: float = 5

@export_subgroup("Circle")
@export var DO_DRAW_CIRCLE: bool = false
@export var CIRCLE_RADIUS: float = 4

@export var MINIMUM_ANGLE_TO_SIBLING: float = deg_to_rad(30)


var Bud_scene = preload("res://scenes/bud.tscn")

func _ready() -> void:
	Line = get_children().filter(
		func(child): return child is Line2D
	)[0]
	Line.default_color = COLOR
	Line.width = LINE_WIDTH


func spawn_child(length: float, angle: float) -> Bud:
	## Get the out_line (line through the parent and self)
	var out_line: Vector2 = parent.position.direction_to(self.position)
	out_line *= length # scale to length
	
	## rotate line
	var child_position_offset = out_line.rotated(angle)
	
	## Check angle to other children
	for other_child in self.bud_children:
		var other_child_offset = other_child.position - self.position
		var angle_between = acos(child_position_offset.normalized().dot(other_child_offset.normalized()))
		
		if angle_between < MINIMUM_ANGLE_TO_SIBLING: return null
		
	
	## Check for collisions
	
	 
	## Make child
	var child: Bud = Bud_scene.instantiate()
	child.parent = self
	self.bud_children.append(child)
	child.position = self.position + child_position_offset
	child.queue_redraw()
	
	## Connect Line2d
	Line.add_point(Vector2.ZERO)
	Line.add_point(child.position - self.position)

	## Make Collision shape
	add_collision_segment(self.position, child.position)
	
	return child


func add_collision_segment(start: Vector2, end: Vector2) -> void:
	var new_shape = CollisionShape2D.new()
	$Line2D/StaticBody2D/Area2D.add_child(new_shape)
	var rect = RectangleShape2D.new()
	new_shape.position = (end - start) / 2
	new_shape.rotation = start.direction_to(end).angle()
	var length = start.distance_to(end)
	rect.extents = Vector2(length / 2, 10)
	new_shape.shape = rect
	
func _draw() -> void:
	if DO_DRAW_CIRCLE:
		draw_circle(Vector2.ZERO, CIRCLE_RADIUS, COLOR, true)
