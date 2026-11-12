extends CharacterBody3D

var speed = 5
var max_ammo = 6
var ammo = max_ammo
var gravity = 10

var look_sensitivity = 0.003

@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_ammo(max_ammo)

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
		crosshair.set_min_size()
	else:
		crosshair.set_max_size()
	
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
	var end = origin + camera.project_ray_normal(viewport_center) * 1000
	
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
	var hud = get_tree().get_first_node_in_group("hud")
	hud.set_ammo(ammo)

func jump():
	velocity.y += 5
