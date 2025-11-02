extends Node2D

@export var open := true
@export var water: int = 1
@export var magnitude: int = 3
@export var is_vertical := true

var capacity: int

@export var connections: Array[NodePath] = []
var on_full: Callable

var connected_pipes: Array[Node2D] = []

var color = Color(0, 0, 1)
var water_container_size = Vector2(26, 10)

func open_valve():
	open = true
func close_valve():
	open = false

func add_water(amount: int):
	queue_redraw()
	water += amount
func sub_water(amount: int):
	add_water(-amount)

func set_capacity(amount: int):
	capacity = amount

func is_leaf():
	return connections.is_empty()



func _ready():
	_resolve_connections()
	
	if is_vertical:
		capacity = Globals.PIPESIZE.y * magnitude
	else:
		capacity = Globals.PIPESIZE.x * magnitude

func _draw():
	water_container_size.y = water
	draw_rect(
		Rect2(Vector2(0, -water_container_size.y), water_container_size), 
		color
	)

func receive(amount: int) -> int:
	if water >= capacity:
		return 0
	
	var accepted = min(amount, capacity - water)
	add_water(accepted)

	if (water == capacity and on_full):
		on_full.call()
	return accepted

func _resolve_connections():
	for path in connections:
		var node = get_node_or_null(path)
		if node:
			connected_pipes.append(node)

func _to_string() -> String:
	return "open=%s water: %.2f/%d" % [str(open), water, capacity]
