extends CharacterBody3D

func take_damage(amount: float):
	die()

func die():
	queue_free()
