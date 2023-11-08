extends Area2D

var dir := Vector2.LEFT
var speed : float
var hitable : bool = true

signal SPAWN

func  _ready():
	connect("SPAWN",Callable(self,"SetSpawn"))
	$Sprite2D.frame = randf_range(0,4)

func _physics_process(delta):
	Move(delta)

func Move(delta) -> void:
	if speed:
		position += dir * speed * delta

func SetSpawn(new_direction, new_speed, spawn_pos) -> void:
	dir = new_direction
	speed = new_speed
	global_position = spawn_pos
	
func HitPlayer(col) -> void:
	col.pushed()
