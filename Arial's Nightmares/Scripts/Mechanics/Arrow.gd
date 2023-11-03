extends Area2D

const arrow_directions = {
	"Up": preload("res://Assets/Mechanics/up.png"),
	"Left": preload("res://Assets/Mechanics/left.png"),
	"Down": preload("res://Assets/Mechanics/down.png"),
	"Right": preload("res://Assets/Mechanics/right.png")
}

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var pressed = false

var direction
var speed
var velocity

func _ready():
	sprite.set_texture(arrow_directions[direction])

func _process(delta):
	position += velocity * delta * speed
