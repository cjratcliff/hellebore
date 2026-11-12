extends CanvasLayer

@onready var ammo_label: Label = $Ammo

func set_ammo(amount):
	ammo_label.text = str(amount)
