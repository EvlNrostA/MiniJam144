extends Area2D

@onready var player = $"../Player"
@onready var sprite = $Sprite2D
@onready var rope = $"../Rope"

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready():
	rope.points[0] = sprite.position

func _physics_process(_delta):
	rope.points[1] = make_canvas_position_local(player.position + Vector2(0, 15))

func _on_arielush_entered(body):
	if body.is_in_group("player_group"):
		body.death()
