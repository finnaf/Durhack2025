extends Node2D

var tick_acc := 0.0
var manager: PipeStateManager

func _ready():	
	_setup_water(100)

func _physics_process(delta: float) -> void:
	tick_acc += delta
	if tick_acc >= Globals.TICKSPEED:
		manager.tick()
		tick_acc = 0.0

func _setup_water(start_sum: int):
	manager = PipeStateManager.new()

	for node in get_tree().get_nodes_in_group("LogicalPipes"):
		manager.add_pipe(node)

	var first_pipe = manager.pipes[0]
	first_pipe.add_water(start_sum)
