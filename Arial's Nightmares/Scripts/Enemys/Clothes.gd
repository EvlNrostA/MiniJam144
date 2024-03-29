extends Area2D

@onready var sprite = $Sprite2D
var dir := Vector2.LEFT
var speed : float
var hitable : bool = true

signal SPAWN

func  _ready():
	connect("SPAWN",Callable(self,"SetSpawn"))
	sprite.frame = randf_range(0,4)

func _process(delta):
	Move(delta)
	sprite.rotate(speed * delta)

func Move(delta) -> void:
	position += dir * speed * delta * 100

func SetSpawn(newDirection, spawnPos, speed) -> void:
	dir = newDirection
	global_position = spawnPos
	self.speed = speed
	
func HitPlayer(col) -> void:
	col.hit()
	
func _on_area_entered(area):
	queue_free()
