extends Node2D

@export var open := true
@export var water := 0.0
@export var capacity := 10.0

@export var connections: Array[NodePath] = []
var on_full: Callable

var connected_pipes: Array[Node2D] = []

var color = Color(0, 0, 1)
var water_container_size = Vector2(26, 10)

func open_valve():
	open = true
func close_valve():
	open = false

func add_water(amount: float):
	queue_redraw()
	water += amount
func sub_water(amount: float):
	add_water(-amount)

func set_capacity(amount: float):
	capacity = amount

func is_leaf():
	return connections.is_empty()



func _ready():
	_resolve_connections()

func _draw():
	water_container_size.y = (32*3) * (water / capacity)
	draw_rect(
		Rect2(Vector2(0, -water_container_size.y), water_container_size), 
		color
	)

func receive(amount: float) -> float:
	if water >= capacity:
		return 0.0
	
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
