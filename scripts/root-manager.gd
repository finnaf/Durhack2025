extends Node2D

var tick_acc := 0.0

var serial: GdSerial
var serial_thread: Thread
var stop_thread := false

var manager: PipeStateManager

func _ready():
	_assign_pipes()
	_serial_start()
	
	_setup_water(300)


func _physics_process(delta: float) -> void:
	tick_acc += delta
	if tick_acc >= Globals.TICKSPEED:
		manager.tick()
		tick_acc = 0.0

func _setup_water(start_sum: int):
	manager = PipeStateManager.new()

	for node in get_tree().get_nodes_in_group("LogicalPipes"):
		manager.add_pipe(node)
		node.on_full = func(): print("pipe is full!")

	var first_pipe = manager.pipes[0]
	first_pipe.add_water(start_sum)

func _assign_pipes():
	for pipe_group in get_tree().get_nodes_in_group("pipe_group"):
		if not pipe_group.get_script():
			pipe_group.set_script(load("res://scripts/PipeLogic.gd"))
			pipe_group._ready()


func _serial_start():
	serial = GdSerial.new()
	serial.set_port("/dev/ttyUSB0")
	serial.set_baud_rate(9600)
	serial.set_timeout(1000)
	
	if serial.open():
		print("Port opened")
		serial.clear_buffer()
		serial_thread = Thread.new()
		serial_thread.start(Callable(self, "_serial_loop"))
	else:
		print("Failed to open port")


func _serial_loop():
	while not stop_thread and serial.is_open():
		while serial.bytes_available() > 0:
			var response: String = serial.readline()
			var options: Array = Array(response.split(";"))
			var int_array = options.map(Callable(func(s): return int(s)))
			
			var analogue_values = int_array.slice(0, 6)
			var digital_values = int_array.slice(6, 10)
			
			call_deferred("_update_sensors", analogue_values, digital_values)


func _update_sensors(analogue_values: Array, digital_values: Array):
	$Label.text = str(analogue_values) + " " + str(digital_values)
	

func _exit_tree():
	stop_thread = true
	
	if serial and serial.is_open():
		serial.close()

	if serial_thread:
		serial_thread.wait_to_finish()
