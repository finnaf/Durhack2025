extends Area2D

@onready var image: AnimatedSprite2D = $Image
@onready var bg_pipe: AnimatedSprite2D = $BackgroundPipe

@export var frame_choice: int = 0
@export_enum("Vertical", "Horizontal", "Valve", "DownOut", "UpOut", "LeftOut", "RightOut") var animation_frame: int = 0

func _ready():
	image.frame = animation_frame
	
	if animation_frame == 2:
		bg_pipe.visible = true
