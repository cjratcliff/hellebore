extends Control

@onready var up: TextureRect = $Up
@onready var down: TextureRect = $Down
@onready var left: TextureRect = $Left
@onready var right: TextureRect = $Right

var transition_speed: float = 10.0 # Adjust for faster/slower smoothing

var desired_size: float = 0.0 #min_size
var current_size: float = 0.0

# Store original center positions (when there is no spacing)
var base_up_pos: Vector2
var base_down_pos: Vector2
var base_left_pos: Vector2
var base_right_pos: Vector2

func _ready() -> void:
	# Save the initial positions before applying any offset
	base_up_pos = up.position
	base_down_pos = down.position
	base_left_pos = left.position
	base_right_pos = right.position

func _process(delta: float) -> void:
	# Only process if we haven't reached the desired size yet
	if not abs(current_size - desired_size) < 1:
		current_size = lerp(current_size, desired_size, transition_speed * delta)
		
		# Snap when close enough to avoid unnecessary float calculations
		if abs(current_size - desired_size) < 0.01:
			current_size = desired_size
			
		_update_crosshair_positions(current_size)

func _update_crosshair_positions(size: float) -> void:
	up.position = base_up_pos + Vector2(0, -size)
	down.position = base_down_pos + Vector2(0, size)
	left.position = base_left_pos + Vector2(-size, 0)
	right.position = base_right_pos + Vector2(size, 0)

func set_crosshair_size(fov: float, spread_angle: float):
	desired_size = _calc_size(fov, spread_angle)

func _calc_size(vertical_fov: float, spread_angle: float):
	# camera.fov is the vertical fov
	# all input angles are in degrees
	var viewport_height = get_viewport_rect().size.y
	return (viewport_height / 2.0) * (tan(deg_to_rad(spread_angle)) / tan(deg_to_rad(vertical_fov) / 2.0))
