extends Node2D

var serial: GdSerial
var reader_thread: Thread
var stop_thread := false

var manager: PipeStateManager

func _ready():
	_assign_pipes()
	_serial_start()
	
	_run_water()


func _run_water():
	manager = PipeStateManager.new()

	# Step 1: Create Pipe objects for all LogicalPipes
	for node in get_tree().get_nodes_in_group("LogicalPipes"):
		manager.add_pipe(node)

	# Step 3: Optionally set on_full callback
	for node in get_tree().get_nodes_in_group("LogicalPipes"):
		node.on_full = func(): print("pipe is full!")

	# Step 4: Initialize some starting water
	var first_pipe = manager.pipes[0]
	first_pipe.water = 10.0  # give some water to start flow

	# Step 5: Run the simulation
	manager.run(11, true)


func _assign_pipes():
	for pipe_group in get_tree().get_nodes_in_group("pipe_group"):
		if not pipe_group.get_script():
			pipe_group.set_script(load("res://scripts/PipeLogic.gd"))
			pipe_group._ready()


func _serial_start():
	serial = GdSerial.new()
	serial.set_port("COM7")
	serial.set_baud_rate(9600)
	serial.set_timeout(1000)
	
	if serial.open():
		print("Port opened")
		reader_thread = Thread.new()
		reader_thread.start(Callable(self, "_serial_loop"))
	else:
		print("Failed to open port")

func _serial_loop():
	while not stop_thread and serial.is_open():
		if serial.bytes_available() > 0:
			var response = serial.readline()
			if response != "":
				print("Button:", response.strip_edges())
		else:
			OS.delay_msec(5)

func _exit_tree():
	stop_thread = true
	
	if serial and serial.is_open():
		serial.close()

	if reader_thread:
		reader_thread.wait_to_finish()
