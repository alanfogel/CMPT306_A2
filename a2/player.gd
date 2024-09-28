extends CharacterBody2D

@export var turn_speed := 3.0
@export var recoil_force := 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var animated_sprite = $AnimatedSprite2D

	if animated_sprite != null:
		if Input.is_action_pressed("ui_left"):
			rotate(-turn_speed * delta)
			animated_sprite.play("RotateLeft")
		elif Input.is_action_pressed("ui_right"):
			rotate(turn_speed * delta)
			animated_sprite.play("RotateRight")
		elif Input.is_action_pressed("ui_accept"):
			# spawn bullet

			# player is pushed backwards
			var direction = Vector2(-sin(rotation), cos(rotation)).normalized()

			velocity += direction * recoil_force

			animated_sprite.play("FireBullet")
		else:
			animated_sprite.play("Idle")
	move_and_slide();
