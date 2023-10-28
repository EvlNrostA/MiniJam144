extends Node

@onready var Bullet_Refrance = preload("res://Nodes/Enemys/enemy_bullet.tscn")
var difficulty : = 5


func _ready():
	start("normal")
	print(difficulty)
	call_deferred("SpawnBullets")
	$Timer.start()
	pass

func SpawnBullets() -> void:
	var buttomBullet = Bullet_Refrance.instantiate()
	var buttomPos = GetRandomNum(24,648)
	var leftBullet = Bullet_Refrance.instantiate()
	var leftPos = GetRandomNum(136,648)
	var rightBullet = Bullet_Refrance.instantiate()
	var rightPos = GetRandomNum(136,648)
	
	get_parent().add_child(buttomBullet)
	get_parent().add_child(leftBullet)
	get_parent().add_child(rightBullet)
	
	buttomBullet.emit_signal("SPAWN",Vector2.UP,Vector2(buttomPos,648))
	rightBullet.emit_signal("SPAWN",Vector2.RIGHT,Vector2(0,leftPos))
	leftBullet.emit_signal("SPAWN",Vector2.LEFT,Vector2(1128,rightPos))
	
	if difficulty >= 1.5:
		print("a")
		difficulty -= 0.5
	
	$Timer.wait_time = difficulty
	$Timer.start()
	pass

func GetRandomNum(min,max) -> float:
	randomize()
	var num = randf_range(min,max)
	return num

var difficulties = {
	"easy": {
		"wait_time": 5
	},
	"normal": {
		"wait_time": 2.5
	},
	"hard": {
		"wait_time": 0.5
	},
}

func start(dif) -> void:
	difficulty = difficulties[dif].wait_time
	pass
