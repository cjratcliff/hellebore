extends CharacterBody3D

var speed = 2

func _physics_process(delta: float) -> void:
	velocity = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		velocity = Vector3.FORWARD * speed
	if Input.is_action_pressed("move_back"):
		velocity = Vector3.BACK * speed
	
	move_and_slide()
