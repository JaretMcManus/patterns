extends Node

var COLOR: Color = Color.BLACK
var DEBUG_COLOR: Color = Color.YELLOW
var debug: bool = true
var last_line: Line2D = Line2D.new()
var number: int = 0
var space_state: PhysicsDirectSpaceState2D
