extends Area2D

var dir := Vector2.LEFT
var speed : float
var hitable : bool = true

signal SPAWN

func  _ready():
	connect("SPAWN",Callable(self,"SetSpawn"))
	$Sprite2D.frame = randf_range(0,4)
	pass

func _process(delta):
	Move(delta)
	$Sprite2D.rotate(speed * delta)
	pass

func Move(delta) -> void:
	position += dir * speed * delta * 100
	pass

func SetSpawn(newDirection, spawnPos, speed) -> void:
	dir = newDirection
	global_position = spawnPos
	self.speed = speed
	pass
	
func HitPlayer(col) -> void:
	print("GameOver")
	GManager.game_over()
	pass

#var newBullet = bullet_refrance.instantiate()
#get_parent().add_child(newBullet)
#ThisBulletVar.emit_signal("SPAWN",Vector2(4,2), global_position)
