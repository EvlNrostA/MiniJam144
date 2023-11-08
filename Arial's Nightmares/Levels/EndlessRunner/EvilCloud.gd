extends Area2D

const SHADOW_MULTIPLIER = 350
const LEFT_OFFSET = -400
const RIGHT_OFFSET = 900

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
	
		if position.x < LEFT_OFFSET:
			position.x =  DisplayServer.window_get_size().x + RIGHT_OFFSET
			set_speed()

func set_speed():
	speed = randf_range(manager.settings.level_velocity / 2, manager.settings.level_velocity)
