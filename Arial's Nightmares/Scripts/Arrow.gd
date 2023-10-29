extends Area2D

#preload("res://Nodes/Arrows/LeftArrow.tscn"),
#preload("res://Nodes/Arrows/DownArrow.tscn"),
#preload("res://Nodes/Arrows/RightArrow.tscn")

@onready var sprite = $Sprite2D
@onready var arrow_directions = {
	"Up": preload("res://Assets/Arrows/up.png"),
	"Left": preload("res://Assets/Arrows/left.png"),
	"Down": preload("res://Assets/Arrows/down.png"),
	"Right": preload("res://Assets/Arrows/right.png")
}
@onready var is_on_target = false

var direction
var speed
var velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity and speed:
		self.position += velocity * delta * speed * 100

func start(start_position, direction, velocity, speed):
	self.position = start_position
	self.direction = direction
	self.sprite.set_texture(arrow_directions[direction])
	self.velocity = velocity
	self.speed = speed
