extends Area2D

const SHADOW_MULTIPLIER = 350
const SCREEN_OFFSET = 300

@onready var sprite = $Sprite2D
@onready var shadow = $Shadow
@onready var manager = get_tree().current_scene
@onready var start_xposition = GManager.get_shown_window_rect().size.x + SCREEN_OFFSET
@onready var end_xposition = GManager.get_shown_window_rect().position.x - SCREEN_OFFSET
var speed

func start():
	shadow.position.y = sprite.position.y + SHADOW_MULTIPLIER *  (1 / sprite.scale.y)
	set_speed()

func _process(delta):
	if speed:
		position += Vector2.LEFT * delta * speed
	
		if position.x < end_xposition:
			position.x =  start_xposition
			set_speed()

func set_speed():
	speed = randf_range(manager.settings.level_velocity / 2, manager.settings.level_velocity)
