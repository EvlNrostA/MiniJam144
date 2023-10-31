extends Node2D

#@onready var shadow = $CanvasLayer/Shadow
@onready var button = $TextureButton

func _ready():
	button.disabled = true
	
	GManager.restart_levels()
	await GManager.fade_out()
	
	button.disabled = false

func _on_button_pressed():
	GManager.next_level()
