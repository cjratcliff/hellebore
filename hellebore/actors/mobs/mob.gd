extends CharacterBody3D

var max_health = 3
var health = max_health
var speed = 2

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta: float) -> void:
	var player: Player = Globals.get_player()
	if player != null:
		nav_agent.target_position = player.global_position
		var dir = global_position.direction_to(nav_agent.get_next_path_position())
		dir.y = 0
		velocity = dir * speed
		move_and_slide()

func take_damage(amount: float):
	health -= 1
	if health <= 0:
		die()

func die():
	queue_free()
