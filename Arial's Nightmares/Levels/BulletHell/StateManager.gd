extends Node2D

var difficulty_settings = {
	"easy": {
		"wait_time": 0.5,
		"level_timer": 30,
		"speed": 1,
		"clothes_speed": 1
	},	
	"normal": {
		"wait_time": 0.5,
		"level_timer": 30,
		"speed": 1,
		"clothes_speed": 2
	},
	"hard": {
		"wait_time": 1,
		"level_timer": 30,
		"speed": 0.5,
		"clothes_speed": 3
	}
}

@onready var player = $Player_BulletHell

@onready var level_timer = $LevelTimer
@onready var bullet_timer = $BulletTimer

@onready var Bullet_Refrance = preload("res://Nodes/Enemys/enemy_bullet.tscn")

var wait_time
var settings

func _ready():
	randomize()
	
	settings = difficulty_settings[GManager.difficulty]
	wait_time = settings.wait_time
	player.speed = settings.speed
	
	bullet_timer.start(wait_time)
	level_timer.start_timer(settings.level_timer)

func SpawnBullets() -> void:
	var buttomBullet = Bullet_Refrance.instantiate()
	var buttomPos = randf_range(24,648)
	var leftBullet = Bullet_Refrance.instantiate()
	var leftPos = randf_range(136,648)
	var rightBullet = Bullet_Refrance.instantiate()
	var rightPos = randf_range(136,648)
	
	add_child(buttomBullet)
	add_child(leftBullet)
	add_child(rightBullet)
	
	buttomBullet.emit_signal("SPAWN",Vector2.UP,Vector2(buttomPos,648), settings.clothes_speed)
	rightBullet.emit_signal("SPAWN",Vector2.RIGHT,Vector2(0,leftPos), settings.clothes_speed)
	leftBullet.emit_signal("SPAWN",Vector2.LEFT,Vector2(1128,rightPos), settings.clothes_speed)
	
	bullet_timer.start(wait_time)

func _on_level_timer_timeout():
	GManager.next_level()
