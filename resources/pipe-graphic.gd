extends Area2D

@onready var image: AnimatedSprite2D = $Image

@export var frame_choice: int = 0

func _ready():
	image.frame = frame_choice
