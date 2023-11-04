extends Node2D

@onready var button = $TextureButton
var delay_timer

func _ready():
	Audio.play_music(Audio.menu_music)
	GManager.restart_levels()

func start():
	if not Fade.fading():
		UI.points_set(0)
		GManager.next_level()

func _unhandled_key_input(event):
	if event.is_action_pressed("Space"):
		start()

func _on_button_pressed():
	start()

func _on_touch_screen_button_pressed():
	start()
