extends Area2D

const SHADOW_MULTIPLIER = 350
const MAX_LEFT = -400
const MAX_RIGHT = 2000

@onready var sprite = $Sprite2D
@onready var shadow = $Shadow
@onready var manager = get_tree().current_scene

var speed

func start():
	shadow.position.y = sprite.position.y + SHADOW_MULTIPLIER *  (1 / sprite.scale.y)
	set_speed()

func _process(delta):
	if speed:
		position += Vector2.LEFT * delta * speed
	
		if position.x < MAX_LEFT:
			position.x = MAX_RIGHT
			set_speed()

func set_speed():
	speed = randf_range(manager.settings.level_velocity / 2, manager.settings.level_velocity)
