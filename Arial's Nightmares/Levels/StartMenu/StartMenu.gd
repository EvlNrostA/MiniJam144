extends Node2D

@onready var shadow = $CanvasLayer/Shadow
@onready var canvas_animation_player = $CanvasLayer/AnimationPlayer
@onready var button = $TextureButton

func _ready():
	$CanvasLayer.visible = true
	GManager.restart_levels()
	pass

func _on_button_pressed():
	GManager.next_level()
