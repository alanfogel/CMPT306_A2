extends Node2D

@export var asteroid_scene := preload("res://asteroid.tscn")
@export var spawn_interval := 1.0
@export var spawn_distance := 400.0
@export var min_speed := 100.0
@export var max_speed := 350.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start a timer to spawn asteroids periodically
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_spawn_asteroid"))
	add_child(timer)

# Function to spawn an asteroid outside the camera view
func _spawn_asteroid() -> void:
	var asteroid = asteroid_scene.instantiate()
	var screen_center = get_viewport().size / 1500.0
	
	# Randomize the spawn position outside the camera view
	var angle = randf_range(0, 2 * PI)
	var spawn_vector = Vector2(cos(angle), sin(angle))
	var spawn_position = spawn_vector * spawn_distance
	asteroid.position = spawn_position
	
	# Set the asteroid's velocity towards the center of the screen
	var direction = (-asteroid.position).normalized()

	print("Asteroid Position: ", asteroid.position)
	print("Screen Center: ", screen_center)
	print("Direction: ", direction)

	# var random_offset = Vector2(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2))
	# direction += random_offset
	# direction = direction.normalized()
	# asteroid.velocity = direction * asteroid.speed
	
	# Randomize the speed of the asteroid
	var speed = randf_range(min_speed, max_speed)
	asteroid.velocity = direction * speed

	add_child(asteroid)
