extends Area2D

@export var speed := 100.0
var velocity := Vector2()
var rotation_speed := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called at a fixed frequency. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Move the asteroid
	position += velocity * delta
	rotation += rotation_speed * delta
