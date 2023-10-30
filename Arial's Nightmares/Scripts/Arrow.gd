extends Area2D

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var arrow_directions = {
	"Up": preload("res://Assets/Arrows/up.png"),
	"Left": preload("res://Assets/Arrows/left.png"),
	"Down": preload("res://Assets/Arrows/down.png"),
	"Right": preload("res://Assets/Arrows/right.png")
}
@onready var pressed = false

var direction
var speed
var velocity

func _process(delta):
	if velocity and speed:
		self.position += velocity * delta * speed * 100

func start(start_position, direction, velocity, speed):
	self.position = start_position
	self.direction = direction
	self.sprite.set_texture(arrow_directions[direction])
	self.velocity = velocity
	self.speed = speed
