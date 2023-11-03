extends Node2D

@onready var button = $TextureButton

func _ready():
	GManager.play_global_music(GManager.menu_music)
	GManager.restart_levels()

func _on_button_pressed():
	Audio.stop()
	UI.points_set(0)
	GManager.next_level()
