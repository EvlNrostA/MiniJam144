extends Node

var difficulty_settings = {
	"easy": {
		"wait_time": 5,
		"level_timer": 30
	},
	"normal": {
		"wait_time": 2.5,
		"level_timer": 30
	},
	"hard": {
		"wait_time": 0.5,
		"level_timer": 30
	},
}

@onready var level_timer = $"../LevelTimer"
@onready var Bullet_Refrance = preload("res://Nodes/Enemys/enemy_bullet.tscn")
var wait_time : = 5
var settings

func _ready():
	settings = difficulty_settings[GManager.difficulty]
	wait_time = settings.wait_time
	print(wait_time)
	call_deferred("SpawnBullets")
	$Timer.start()
	
	level_timer.start(settings.level_timer)
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
	
	if wait_time >= 1.5:
		print("a")
		wait_time -= 0.5
	
	$Timer.wait_time = wait_time
	$Timer.start()
	pass

func GetRandomNum(min,max) -> float:
	randomize()
	var num = randf_range(min,max)
	return num

func _on_level_timer_timeout():
	GManager.next_level()
