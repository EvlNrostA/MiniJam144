extends Area2D

const SPEED_MULTIPLIER = 100

@onready var floating_text = $FloatingText
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var arrow_directions = {
	"Up": preload("res://Assets/Mechanics/up.png"),
	"Left": preload("res://Assets/Mechanics/left.png"),
	"Down": preload("res://Assets/Mechanics/down.png"),
	"Right": preload("res://Assets/Mechanics/right.png")
}
@onready var pressed = false

var direction
var speed
var velocity

func _process(delta):
	if velocity and speed:
		self.position += velocity * delta * speed * SPEED_MULTIPLIER

func start(start_position, direction, velocity, speed):
	self.position = start_position
	self.direction = direction
	self.sprite.set_texture(arrow_directions[direction])
	self.velocity = velocity
	self.speed = speed
