extends ProgressBar

@onready var timer = $Timer

var health = 0 : set = _set_health

func _set_health(new_health):
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free()
	
	
func init_health(_health):
		health = _health
		max_value = health
		value = health


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
