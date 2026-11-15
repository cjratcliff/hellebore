extends CharacterBody3D

var max_health = 3
var health = max_health
var speed = 4
var gravity = 10

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta: float) -> void:
	var player: Player = Globals.get_player()
	if player == null:
		return
	
	nav_agent.target_position = player.global_position
	
	var next_pos = nav_agent.get_next_path_position()
	var dir = global_position.direction_to(next_pos)
	dir.y = 0
	velocity = dir * speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var dist_to_player = global_position.distance_to(player.global_position)
	if is_on_floor() and dist_to_player < 5:
		jump()
	
	move_and_slide()
	
	if global_position.distance_to(next_pos) > 0.5:
		look_at(global_position + dir * 1000)

func take_damage(amount: float):
	health -= 1
	if health <= 0:
		die()

func die():
	queue_free()

func jump():
	velocity.y += 40
	speed = 8
