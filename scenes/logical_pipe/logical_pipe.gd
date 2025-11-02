extends Node2D

@export var water: int = 0
@export var magnitude: int = 3
@export var is_vertical := true
@export var is_final := false



@export var sensors: Array[Globals.SensorType] = []

var capacity: int

@export var connections: Array[NodePath] = []

var connected_pipes: Array[Node2D] = []

var color = Color(0, 0.2, 0.9)
var water_container_size = Vector2(26, 10)

@onready var serial_controller: Node3D = get_node("SerialController")
	
func isOpen():
	for sensor in sensors:
		if (!serial_controller.isTriggered(sensor)):
			return false
	
	return true

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
	
	capacity = Globals.PIPESIZE.x * magnitude
	
	

func _draw():
	if water <= 1:
		return
	
	if is_vertical:
		water_container_size.y = water
		draw_rect(
			Rect2(Vector2(1, -water_container_size.y), water_container_size), 
			color
		)
	else:
		water_container_size.y = (water / magnitude)
		water_container_size.x = magnitude * Globals.WATERSIZE.x
		draw_rect(
			Rect2(Vector2(1, -water_container_size.y - 8), water_container_size), 
			color
		)

func receive(amount: int) -> int:
	if water >= capacity:
		return 0
	
	var accepted = min(amount, capacity - water)
	add_water(accepted)
	
	if (water == capacity and is_final):
		return -1

	return accepted

func _resolve_connections():
	for path in connections:
		var node = get_node_or_null(path)
		if node:
			connected_pipes.append(node)

func _to_string() -> String:
	return "open=%s water: %.2f/%d" % [str(isOpen()), water, capacity]
