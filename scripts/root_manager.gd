extends Node2D

@onready var bg = $Background

signal level_done

var paused: bool = true
var tick_acc := 0.0
var manager: PipeStateManager

func _ready():	
	_setup_water(100)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Space"):
		paused = !paused
	
	if paused:
		bg.modulate = Color.GRAY
		return
	else:
		bg.modulate = Color.WHITE
	
	tick_acc += delta
	if tick_acc >= Globals.TICKSPEED:
		var status = manager.tick()
		tick_acc = 0.0
		
		if status == 1:
			emit_signal("level_done")

func _setup_water(start_sum: int):
	manager = PipeStateManager.new()

	for node in get_tree().get_nodes_in_group("LogicalPipes"):
		manager.add_pipe(node)

	var first_pipe = manager.pipes[0]
	first_pipe.add_water(start_sum)
