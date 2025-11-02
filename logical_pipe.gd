extends Node2D

@export var open := true
@export var water := 0.0
@export var capacity := 10.0

@export var connections: Array[NodePath] = []
var on_full: Callable

var connected_pipes: Array[Node2D] = []

var color = Color(0, 0, 1)
var size = Vector2(26, 10)

func _ready():
	_resolve_connections()

func _draw():
	size.y = (32*3) * (water / capacity)
	draw_rect(Rect2(Vector2(0, -size.y), size), color)

func receive(amount: float) -> float:
	if water >= capacity:
		return 0.0
	
	var accepted = min(amount, capacity - water)
	water += accepted

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
