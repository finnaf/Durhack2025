extends Node2D

func _ready():
	pass


func load_world_scene(level: int = 0):
	var folder_path := "res://scenes/levels"
	var scene_path = "%s/scene-%d.tscn" % [folder_path, level]
	
	if not ResourceLoader.exists(scene_path):
		push_error("Scene not found: " + scene_path)
		return
	
	var scene: PackedScene = load(scene_path)
	if scene:
		var instance = scene.instantiate()
		add_child(instance)
		print("Loaded scene:", scene_path)
		if instance.has_signal("level_done"):
			instance.connect("level_done", Callable(self, "_on_level_done"))
	else:
		push_error("Failed to load scene at: " + scene_path)

func _on_level_done():
	print("WorldScene: received 'level_done' signal!")
	# You can now load the next level, for example:
	load_world_scene(2)

func _process(delta: float) -> void:
	var num_pressed := _get_number_key_pressed()
	
	if num_pressed != -1:
		# Avoid repeated triggering while key is held down
		_load_world_for_number(num_pressed)


func _get_number_key_pressed() -> int:
	for i in range(KEY_0, KEY_9 + 1):
		if Input.is_key_pressed(i): # <- "just_pressed" avoids repeats
			return i - KEY_0
	return -1


func _load_world_for_number(num_pressed: int) -> void:
	print("Loading world:", num_pressed)
	
	# Free all child nodes except ones with _serial_start()
	for child in get_children():
		if not child.has_method("_serial_start"):
			child.queue_free()
	
	# Give Godot one frame to process the frees before instantiating new stuff
	await get_tree().process_frame
	
	load_world_scene(num_pressed)
	
	# Optional: Wait 1 second after loading (async-friendly)
	await get_tree().create_timer(1.0).timeout
