extends Node2D

@onready var button = $TextureButton

func _ready():
	GManager.global_music = GManager.menu_music
	GManager.play_global_music()
	GManager.restart_levels()

func _on_button_pressed():
	Audio.stop()
	GManager.global_music = GManager.level_music
	
	Points.points = 0
	
	GManager.next_level()
