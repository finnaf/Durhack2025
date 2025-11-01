extends Node2D

var serial: GdSerial
var reader_thread: Thread
var stop_thread := false

func _ready():
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
