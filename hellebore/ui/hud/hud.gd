class_name Hud extends CanvasLayer

var debug_max_lines: int = 100
var log_history = []

@onready var ammo_label: Label = $Ammo
@onready var health_bar: TextureProgressBar = $PlayerHealthBar
@onready var debug_label: RichTextLabel = $MC/DebugRichTextLabel
@onready var hit_flash_rect: ColorRect = $HitFlashRect

func set_ammo(amount):
	ammo_label.text = str(amount)

func set_health(health: float, max_health: float):
	health_bar.value = 100.0 * (health / max_health)

func write(text) -> void:
	print(text)
	
	var formatted_text = "[color=%s]%s[/color]" % ["green", str(text)]
	log_history.append(formatted_text)
	
	# Prevent memory bloat by trimming old lines from the start of the array
	if log_history.size() > debug_max_lines:
		log_history.pop_front()
	
	debug_label.text = "\n".join(log_history)

func hit_flash():
	var tween = create_tween()
	tween.tween_property(hit_flash_rect, "color:a", 0.15, 0.075)
	tween.tween_property(hit_flash_rect, "color:a", 0.0, 0.075)
