class_name Asteroid
extends RigidBody2D

@export var speed := 100.0
var max_distance := 1000.0
var min_size := 1.0
var velocity := Vector2()
var rotation_speed := 0.0
var size := 64.0

# Preload the asteroid scene
var asteroid_scene = preload("res://asteroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	linear_damp = 0
	angular_damp = -1.0
	linear_velocity = velocity
	angular_velocity = rotation_speed
	add_to_group("asteroids")

# Called at a fixed frequency. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:

	# Check if the asteroid is too far from the screen
	if position.length() > max_distance:
		queue_free()

func on_hit():
	var score_label = get_node("/root/Main Scene/ScoreLabel")
	score_label.increment_score()

	if size > min_size:
		# Spawn two smaller asteroids
		spawn_smaller_asteroids()
	else:
		# Remove the asteroid if it's too small
		queue_free()

# Function to spawn two smaller asteroids
func spawn_smaller_asteroids():
	var new_size = size / 2.0
	
	# Create the first smaller asteroid
	spawn_smaller_asteroid(new_size, position + Vector2(new_size, 0), velocity.rotated(randf_range(-0.1, 0.1)) * randf_range(0.9, 1.1), rotation_speed * randf_range(0.5, 1.5))	
	
	# Create the second smaller asteroid
	spawn_smaller_asteroid(new_size, position + Vector2(-new_size, 0), velocity.rotated(randf_range(-0.1, 0.1)) * randf_range(0.9, 1.1), rotation_speed * randf_range(0.5, 1.5))

	# Remove the current asteroid
	queue_free()

# Function to spawn a smaller asteroid with given parameters
func spawn_smaller_asteroid(new_size: float, new_position: Vector2, new_velocity: Vector2, new_rotation_speed: float):
	var asteroid = asteroid_scene.instantiate()
	asteroid.size = new_size
	asteroid.position = new_position
	asteroid.velocity = new_velocity
	asteroid.rotation_speed = new_rotation_speed
	get_parent().add_child(asteroid)
	asteroid.set_size(new_size)

# Function to set the asteroid size
func set_size(new_size: float):
	size = new_size
	scale = Vector2(size / 2, size / 2)


func _on_body_entered(body: Node) -> void:
	on_hit()
