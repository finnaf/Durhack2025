extends Node2D

var serial: GdSerial
var serial_thread: Thread
var stop_thread := false

var analogue_values: Array = []
var digital_values: Array = []


func _ready():
	analogue_values.resize(6)
	digital_values.resize(4)
	_serial_start()


func _serial_start():
	serial = GdSerial.new()
	serial.set_port("COM8")
	serial.set_baud_rate(9600)
	serial.set_timeout(1000)
	
	if serial.open():
		print("Port opened")
		serial_thread = Thread.new()
		serial_thread.start(Callable(self, "_serial_loop"))
	else:
		print("Failed to open port")


func _exit_tree():
	stop_thread = true
	
	if serial and serial.is_open():
		serial.close()
	if serial_thread:
		serial_thread.wait_to_finish()

func _serial_loop():
	while not stop_thread and serial.is_open():
		while serial.bytes_available() > 0:
			var response: String = serial.readline()
			var options: Array = Array(response.split(";"))
			var int_array = options.map(Callable(func(s): return int(s)))
			
			var _analogue_values = int_array.slice(0, 6)
			var _digital_values = int_array.slice(6, 10)
			
			call_deferred("_update_sensors", _analogue_values, _digital_values)


func _update_sensors(_analogue_values: Array, _digital_values: Array):
	for i in range(len(_analogue_values)):
		analogue_values[i] = _analogue_values[i]
	
	for i in range(len(_digital_values)):
		digital_values[i] = _digital_values[i]
	
	print(str(analogue_values) + " " + str(digital_values))

var _sensor_to_pin = {
	Globals.SensorType.POTENTIOMETER: [analogue_values, 0],
	Globals.SensorType.WET_SENSOR: [analogue_values, 5],
	Globals.SensorType.JOYSTICK_X: [analogue_values, 2],
	Globals.SensorType.JOYSTICK_Y: [analogue_values, 3],
	Globals.SensorType.JOYSTICK_Z: [digital_values, 3],
	Globals.SensorType.HALL_EFFECT_SENSOR: [digital_values, 2],
	Globals.SensorType.TOUCH_SENSOR: [digital_values, 0],
	Globals.SensorType.BUTTON: [digital_values, 1],
	Globals.SensorType.STEAM_SENSOR: [analogue_values, 4],
	Globals.SensorType.RAGE_SENSOR: [analogue_values, 1]
}

var rage_countdown = 0

func isTriggered(sensor: Globals.SensorType):
	var pin = _sensor_to_pin[sensor][1]
		
	match sensor:
		Globals.SensorType.POTENTIOMETER: return analogue_values[pin] > 230
		Globals.SensorType.WET_SENSOR: return analogue_values[pin] > 400
		Globals.SensorType.JOYSTICK_X: return analogue_values[pin] > 600
		Globals.SensorType.JOYSTICK_Y: return analogue_values[pin] > 600
		Globals.SensorType.JOYSTICK_Z: return digital_values[pin] == 1
		Globals.SensorType.HALL_EFFECT_SENSOR: return digital_values[pin] == 1
		Globals.SensorType.TOUCH_SENSOR: return digital_values[pin] == 1
		Globals.SensorType.BUTTON: return digital_values[pin] == 1
		Globals.SensorType.STEAM_SENSOR: return analogue_values[pin] > 100
		Globals.SensorType.RAGE_SENSOR: 
			if rage_countdown > 0:
				return true
			
			if analogue_values[pin] > 10:
				rage_countdown = 2000
				return true
			else:
				return false
	
	return false
   
