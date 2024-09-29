extends CharacterBody2D

@export var turn_speed := 3.0
@export var recoil_force := 30.0
@export var fire_rate := 0.75 
@export var fire_animation_duration := 0.5
@export var bounce_factor := 15
@export var max_health := 100
@export var damage_amount := 10

var rocket_scene := load("res://rocket.tscn")
var damage_timer := 0.0
var damage_duration := 1.0
var warping_timer := 0.0
var warping_duration := 1.0
var fire_cooldown := 0.0
var fire_animation_timer := 0.0
var is_firing = false
var spark_particles: GPUParticles2D
var health := max_health
var health_bar: ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spark_particles = $GPUParticles2D
	spark_particles.emitting = false
	print(health_bar)
	health_bar = get_node("/root/Main Scene/Healthbar/Control/HealthBar")
	print(health_bar)
	health_bar.max_value = max_health  # Set the max value of the health bar
	health_bar.value = max_health  # Initialize the health bar to full


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var rotate_sprite = $RotateSprite
	var fire_sprite = $FireSprite
	var warp_sprite = $WarpSprite
	var fire_sound = $FireSound
	var collision_sound = $CollisionSound

	var camera = get_viewport().get_camera_2d()
	var viewport_size = get_viewport_rect().size

	if rotate_sprite != null and fire_sprite != null:
		var is_rotating = false

		if Input.is_action_pressed("ui_left"):
			rotate(-turn_speed * delta)
			rotate_sprite.play("RotateLeft")
			is_rotating = true
		elif Input.is_action_pressed("ui_right"):
			rotate(turn_speed * delta)
			rotate_sprite.play("RotateRight")
			is_rotating = true


		if Input.is_action_pressed("ui_accept") and fire_cooldown <= 0:
			# spawn rocket
			var rocket = rocket_scene.instantiate()

			rocket.position = position
			rocket.rotation = rotation
			rocket.add_to_group("rockets")
			get_parent().add_child(rocket)

			# player is pushed backwards
			var direction = Vector2(-sin(rotation), cos(rotation)).normalized()
			velocity += direction * recoil_force

			fire_sprite.play("FireBullet")
			fire_sound.play()
			is_firing = true
			fire_animation_timer = fire_animation_duration

			fire_cooldown = fire_rate

		# Play Idle animation only if not rotating or firing
		if not is_rotating:
			rotate_sprite.play("Idle")
		if not is_firing:
			fire_sprite.play("Idle")
	
	# Update fire animation timer
		if is_firing:
			fire_animation_timer -= delta
			if fire_animation_timer <= 0:
				is_firing = false
	
	# Move the player and check for collisions
	var collision = move_and_collide(velocity * delta)
	
	move_and_slide()
		
	var collided = false
	if collision:
		collided = true
		print("Collision!")
		# Apply bounce effect
		var normal = collision.get_normal()
		velocity = velocity.bounce(normal) * bounce_factor
		print("Collided set to true")

	if collided:
		spark_particles.global_position = collision.get_position()
		spark_particles.emitting = true
		damage_timer = damage_duration
		print(collision_sound)
		collision_sound.play()
		# Decrease health and update health bar
		health -= damage_amount
		health_bar.value = health


	# Update damage timer
	if damage_timer > 0:
		damage_timer -= delta
		if damage_timer <= 0:
			spark_particles.emitting = false



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

	if fire_cooldown > 0:
		fire_cooldown -= delta
