extends CharacterBody3D

var speed = 3

func _physics_process(delta: float) -> void:
	var dir = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		dir += Vector3.FORWARD
	if Input.is_action_pressed("move_back"):
		dir += Vector3.BACK
	
	if Input.is_action_pressed("strafe_left"):
		dir += Vector3.LEFT
	if Input.is_action_pressed("strafe_right"):
		dir += Vector3.RIGHT
	
	velocity = dir.normalized() * speed
	move_and_slide()
