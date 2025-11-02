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
	else:
		push_error("Failed to load scene at: " + scene_path)
