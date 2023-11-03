extends Node2D

@onready var button = $TextureButton
var delay_timer

func _ready():
	GManager.play_global_music(GManager.menu_music)
	GManager.restart_levels()
	delay_timer = get_tree().create_timer(0.3)

func start():
	if delay_timer.time_left == 0:
		Audio.stop()
		UI.points_set(0)    
		GManager.next_level()

func _unhandled_key_input(event):
	if event.is_action_pressed("space"):
		start()

func _on_button_pressed():
	start()
