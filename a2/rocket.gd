extends Area2D

@export var speed := 200.0
@export var lifetime := 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start a timer to remove the rocket after its lifetime
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	add_child(timer)
	timer.start()

# Called at a fixed frequency. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Move the rocket forward
	position += Vector2(sin(rotation), -cos(rotation)) * speed * delta

# Function to remove the rocket from the scene
func _on_Timer_timeout() -> void:
	queue_free()