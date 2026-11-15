class_name FirstPersonCamera extends Camera3D

var is_shaking: bool = false
var shake_intensity: float = 0.05

func _process(delta: float) -> void:
	if is_shaking:
		h_offset = randf_range(-shake_intensity, shake_intensity)
		v_offset = randf_range(-shake_intensity, shake_intensity)
	else:
		h_offset = 0.0
		v_offset = 0.0

func trigger_shake() -> void:
	is_shaking = true
	get_tree().create_timer(0.15).timeout.connect(func():
		is_shaking = false
	)
