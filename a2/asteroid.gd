class_name Asteroid
extends RigidBody2D

@export var speed := 100.0
@export var max_distance := 1000.0
var velocity := Vector2()
var rotation_speed := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	linear_damp = 0
	angular_damp = 0
	add_to_group("asteroids")
	linear_velocity = velocity
	angular_velocity = rotation_speed

# Called at a fixed frequency. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Move the asteroid
	# position += velocity * delta
	# rotation += rotation_speed * delta

	# Check if the asteroid is too far from the screen
	if position.length() > max_distance:
		queue_free()


func _on_body_entered(body: Node) -> void:
	print(body)
	if body.is_in_group("asteroids"):
		print("2 asteroids just collided!")
