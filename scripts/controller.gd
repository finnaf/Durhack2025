extends Node2D

func _ready():
	load_world_scene(1)


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
			print("has level done")
			instance.connect("level_done", Callable(self, "_on_level_done"))
	else:
		push_error("Failed to load scene at: " + scene_path)

func _on_level_done():
	print("WorldScene: received 'level_done' signal!")
	# You can now load the next level, for example:
	load_world_scene(2)
