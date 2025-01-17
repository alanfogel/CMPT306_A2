extends Node2D

@export var asteroid_scene := preload("res://asteroid.tscn")
@export var spawn_interval := 1.0
@export var spawn_distance := 780.0 #TODO: should I make this the screen size?
@export var min_speed := 50.0
@export var max_speed := 200.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start a timer to spawn asteroids periodically
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_spawn_asteroid"))
	add_child(timer)
	_spawn_asteroid()
	
	

# Function to spawn an asteroid outside the camera view
func _spawn_asteroid() -> void:
	var asteroid = asteroid_scene.instantiate() as Asteroid
	# Randomize the spawn position outside the camera view
	var angle = randf_range(0, 2 * PI)
	var spawn_vector = Vector2(cos(angle), sin(angle))
	var spawn_position = spawn_vector * spawn_distance
	asteroid.position = spawn_position
	
	# Set the asteroid's velocity towards the center of the screen
	var direction = (-asteroid.position).normalized()

	# Add some random offset to the direction
	var random_offset = Vector2(randf_range(-0.4, 0.4), randf_range(-0.4, 0.4))
	direction += random_offset
	direction = direction.normalized()

	# Randomize the rotational speed
	asteroid.rotation_speed = randf_range(-2.0, 2.0)

	# Randomize the initial size of the asteroid
	var scale_factor = randf_range(0.5, 2.0)
	asteroid.get_node("CollisionShape2D").scale = Vector2(scale_factor, scale_factor)
	asteroid.set_size(scale_factor)

	# Set the mass of the asteroid based on its size
	asteroid.mass = scale_factor * 10

	# Randomize the speed of the asteroid
	var speed = randf_range(min_speed, max_speed)
	asteroid.velocity = direction * speed
	add_child(asteroid)
