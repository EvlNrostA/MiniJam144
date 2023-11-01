extends Node2D

@onready var button = $TextureButton

func _ready():
	GManager.restart_levels()

func _on_button_pressed():
	GManager.next_level()
