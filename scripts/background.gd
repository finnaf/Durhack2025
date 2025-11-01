extends Sprite2D

func _ready():
	var atlas_tex := AtlasTexture.new()
	atlas_tex.atlas = preload("res://resources/spritesheet.tres")
	atlas_tex.region = Rect2(30, 30, 120, 120) # x, y, width, height
	self.texture = atlas_tex
	self.position = Vector2(10, 10)
