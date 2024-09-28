extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("Idle");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# if some_condition:
	# 	play("some_animation")
	# else:
	# 	play("idle")
	pass
