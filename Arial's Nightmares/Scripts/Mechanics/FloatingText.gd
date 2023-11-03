extends Node2D

@onready var label = $Label
@onready var animation_player = $AnimationPlayer

func display(text, label_position, size, color):
	label.text = text
	label.position = label_position
	label.label_settings.font_size = size
	label.label_settings.font_color = color
	
	#visible = true
	animation_player.play("Float")
	await animation_player.animation_finished
