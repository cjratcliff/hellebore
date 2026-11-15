class_name Hud extends CanvasLayer

var debug_max_lines: int = 100
var log_history = []

@onready var ammo_label: Label = $Ammo
@onready var debug_label: RichTextLabel = $MC/DebugRichTextLabel

func set_ammo(amount):
	ammo_label.text = str(amount)

func write(text) -> void:
	print(text)
	
	var formatted_text = "[color=%s]%s[/color]" % ["green", str(text)]
	log_history.append(formatted_text)
	
	# Prevent memory bloat by trimming old lines from the start of the array
	if log_history.size() > debug_max_lines:
		log_history.pop_front()
	
	debug_label.text = "\n".join(log_history)
