extends Node2D

@export var speed := 400.0
@export var lifetime := 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Rocket ready")
