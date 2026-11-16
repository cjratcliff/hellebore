class_name Player extends CharacterBody3D

# settings
var speed = 5
var max_ammo = 6
var min_spread = 1.5 # degrees
var max_spread = 6.0 # degrees
var max_health = 5
var gravity = 10

var ammo = max_ammo
var health = max_health
var spread = 0.0 # degrees

var look_sensitivity = 0.003

@onready var camera: FirstPersonCamera = $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_ammo(max_ammo)
	Globals.get_hud().set_health(health, max_health) # health bar

func _physics_process(delta: float) -> void:
	var dir = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		dir -= transform.basis.z
	if Input.is_action_pressed("move_back"):
		dir += transform.basis.z
	
	if Input.is_action_pressed("strafe_left"):
		dir -= transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		dir += transform.basis.x
	
	var crosshair = get_tree().get_first_node_in_group("crosshair")
	if dir == Vector3.ZERO:
		spread = min_spread
	else:
		spread = max_spread
	
	crosshair.set_crosshair_size(camera.fov, spread)
	
	velocity.x = dir.normalized().x * speed
	velocity.z = dir.normalized().z * speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	# Don't move the camera if in menu
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * look_sensitivity) # pan
		camera.rotate_x(-event.relative.y * look_sensitivity) # tilt

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump()
	
	if event.is_action_pressed("fire"):
		fire()
	
	if event.is_action_pressed("reload"):
		reload()

func fire():
	if ammo <= 0:
		return
	
	set_ammo(ammo - 1)
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	
	# Cast from the center of the camera
	var viewport_center := get_viewport().get_visible_rect().size / 2
	var origin = camera.project_ray_origin(viewport_center)
	var forward = camera.project_ray_normal(viewport_center)
	var direction = get_spread_direction(forward, spread)
	var end = origin + direction * 1000

	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)
	
	if result:
		var hit_object = result.collider
		if hit_object.has_method("take_damage"):
			hit_object.take_damage(1)

func reload():
	set_ammo(max_ammo)
	
func set_ammo(amount):
	ammo = amount
	Globals.get_hud().set_ammo(ammo)

func jump():
	velocity.y += 5

func take_damage(amount: float):
	health -= amount
	Globals.get_hud().set_health(health, max_health)
	Globals.get_hud().hit_flash()
	camera.trigger_shake()

func _on_hitbox_body_entered(body: Node3D) -> void:
	take_damage(1)

func get_spread_direction(forward: Vector3, half_angle_deg: float) -> Vector3:
	# uniform sampling in a cone around the forward vector
	# half_angle_deg is the angle from forward to the edge of the cone
	var cos_max := cos(deg_to_rad(half_angle_deg))
	var cos_theta := randf_range(cos_max, 1.0)   # uniform over the cone's solid angle
	var sin_theta := sqrt(1.0 - cos_theta * cos_theta)
	var phi := randf() * TAU

	# Build an orthonormal basis around the forward direction
	var helper := Vector3.UP if absf(forward.dot(Vector3.UP)) < 0.99 else Vector3.RIGHT
	var right := forward.cross(helper).normalized()
	var up := right.cross(forward).normalized()

	return (forward * cos_theta
		+ right * (sin_theta * cos(phi))
		+ up * (sin_theta * sin(phi))).normalized()
