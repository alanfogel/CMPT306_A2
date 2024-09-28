extends CharacterBody2D

@export var turn_speed := 3.0
@export var recoil_force := 1.0
@export var warping_duration := 1.0

var warping_timer := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var rotate_sprite = $RotateSprite
	var fire_sprite = $FireSprite
	var warp_sprite = $WarpSprite
	var camera = get_viewport().get_camera_2d()
	var viewport_size = get_viewport_rect().size

	if rotate_sprite != null and fire_sprite != null:
		var is_rotating = false
		var is_fireing = false

		if Input.is_action_pressed("ui_left"):
			rotate(-turn_speed * delta)
			rotate_sprite.play("RotateLeft")
			is_rotating = true
		elif Input.is_action_pressed("ui_right"):
			rotate(turn_speed * delta)
			rotate_sprite.play("RotateRight")
			is_rotating = true


		if Input.is_action_pressed("ui_accept"):
			# spawn bullet

			# player is pushed backwards
			var direction = Vector2(-sin(rotation), cos(rotation)).normalized()

			velocity += direction * recoil_force

			fire_sprite.play("FireBullet")
			is_fireing = true

		# Play Idle animation only if not rotating or firing
		if not is_rotating:
			rotate_sprite.play("Idle")
		if not is_fireing:
			fire_sprite.play("Idle")

	
	# Move the player
	move_and_slide();

	# Teleporting the player to the other side of the screen
	var camera_position = camera.global_position
	var half_viewport_size = viewport_size / 2
	var teleported = false

	if position.x < camera_position.x - half_viewport_size.x:
		position.x = camera_position.x + half_viewport_size.x
		teleported = true
	elif position.x > camera_position.x + half_viewport_size.x:
		position.x = camera_position.x - half_viewport_size.x
		teleported = true
	
	if position.y < camera_position.y - half_viewport_size.y:
		position.y = camera_position.y + half_viewport_size.y
		teleported = true
	elif position.y > camera_position.y + half_viewport_size.y:
		position.y = camera_position.y - half_viewport_size.y
		teleported = true

	# Play warping animation if teleported
	if teleported:
		warp_sprite.play("Warping")
		warping_timer = warping_duration

	# Update warping timer
	if warping_timer > 0:
		warping_timer -= delta
		if warping_timer <= 0:
			warp_sprite.play("Idle")  # Optionally switch to an idle animation
