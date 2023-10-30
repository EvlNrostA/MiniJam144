extends Node2D

@onready var shadow = $CanvasLayer/Shadow
@onready var canvas_animation_player = $CanvasLayer/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	#shadow.scale = Vector2(0, 0)
	GManager.levels_left = []
	GManager.current_batch_index = 0

func _on_button_pressed():
	#GManager.fade_in()
	GManager.next_level()
