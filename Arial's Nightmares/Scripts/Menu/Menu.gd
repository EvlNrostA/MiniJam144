extends Node2D

var delay_timer

func _ready():
	Audio.play_music(Audio.menu_music)
	GManager.restart_levels()	

func _unhandled_key_input(event):
	if event.is_action_pressed("Space"):
		GManager.start()

func _on_button_pressed():
	GManager.start()
