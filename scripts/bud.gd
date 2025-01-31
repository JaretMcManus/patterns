class_name Bud extends Node2D


var bud_children: Array[Bud] = []
var parent: Bud
var bud_lines: Array[BudLine] = []


@export_group("Drawing")
var COLOR: Color = Global.COLOR
@export_subgroup("Circle")
@export var DO_DRAW_CIRCLE: bool = false
@export var CIRCLE_RADIUS: float = 4
@export_group("Angle")
@export var MINIMUM_ANGLE_TO_SIBLING: float = deg_to_rad(30)


var Bud_scene = preload("res://scenes/bud.tscn")
var Bud_line_scene = preload("res://scenes/bud_line.tscn")


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
	
	## Make child
	var child: Bud = Bud_scene.instantiate()
	child.parent = self
	self.bud_children.append(child)
	child.position = self.position + child_position_offset
	child.queue_redraw()
	
	## Make BudLine
	var new_bud_line: BudLine = Bud_line_scene.instantiate()
	self.add_child(new_bud_line)
	new_bud_line.init(self.position, child.position)
	
	## Check for Collisions
	await get_tree().physics_frame
	await get_tree().physics_frame
	var collisions = new_bud_line.area.get_overlapping_areas()
	var current_bud_areas = bud_lines.map(func(bl: BudLine): return bl.area)
	collisions = collisions.filter(func(collided): return collided not in current_bud_areas)
	
	if collisions.size() > 0:
		print("cant create line, COLLISION")
		new_bud_line.queue_free()
		child.queue_free()
		return null

	#debug coloring
	if Global.debug:
		Global.last_line.set_default_color(Global.COLOR)
		new_bud_line.line.set_default_color(Global.DEBUG_COLOR)
		Global.last_line = new_bud_line.line

	bud_lines.append(new_bud_line)
	child.bud_lines.append(new_bud_line)
	new_bud_line.visible = true
	return child
	
func _draw() -> void:
	if DO_DRAW_CIRCLE:
		draw_circle(Vector2.ZERO, CIRCLE_RADIUS, COLOR, true)
