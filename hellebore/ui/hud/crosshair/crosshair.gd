extends Control

@onready var up: TextureRect = $Up
@onready var down: TextureRect = $Down
@onready var left: TextureRect = $Left
@onready var right: TextureRect = $Right

func _ready() -> void:
	up.position += Vector2(0, -20)
	down.position += Vector2(0, 20)
	left.position += Vector2(-20, 0)
	right.position += Vector2(20, 0)
