extends Area2D

var dir := Vector2.LEFT
var speed : float = 300
var hitable : bool = true

signal SPAWN

func  _ready():
	connect("SPAWN",Callable(self,"SetSpawn"))
	$Sprite2D.frame = randf_range(0,3)
	pass

func _process(delta):
	Move(delta)
	pass

func Move(delta) -> void:
	position = position.move_toward(position + dir, speed * delta)
	pass

func SetSpawn(newDirection, spawnPos) -> void:
	dir = newDirection
	global_position = spawnPos
	pass
	
func HitPlayer(col) -> void:
	if col.is_in_group("player_group"):
		col.pushed()
	

func delete() -> void:
	queue_free()
	pass

#var newBullet = bullet_refrance.instantiate()
#get_parent().add_child(newBullet)
#ThisBulletVar.emit_signal("SPAWN",Vector2(4,2), global_position)