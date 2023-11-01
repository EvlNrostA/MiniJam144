extends Area2D

const MIN_SPEED = 2
const MAX_SPEED = 4

@onready var sprite = $Sprite2D
var speed

func _ready():
	speed = randf_range(MIN_SPEED, MAX_SPEED)

func _process(_delta):
	position += Vector2.LEFT * speed
	
	if position.x < -400:
		position.x = 2000
		speed = randf_range(MIN_SPEED, MAX_SPEED)
