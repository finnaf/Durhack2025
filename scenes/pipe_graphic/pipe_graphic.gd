extends Node2D

@onready var image: AnimatedSprite2D = $Image
@onready var bg_pipe: AnimatedSprite2D = $BackgroundPipe

@export_enum(
	"Vertical", 
	"Horizontal", 
	"CornerLeft", 
	"CornerRight", 
	"LRight", 
	"LLeft", 
	"TJunction",
	"RightT",
	"LeftT",
	"Crisscross",
	"Button") var animation_frame: int = 0

func _ready():
	image.frame = animation_frame
	
	if animation_frame == 2:
		bg_pipe.visible = true
