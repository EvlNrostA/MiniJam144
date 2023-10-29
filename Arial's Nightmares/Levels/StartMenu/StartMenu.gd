extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GManager.levels_left = []
	GManager.current_batch_index = 0

func _on_button_pressed():
	GManager.next_level()
