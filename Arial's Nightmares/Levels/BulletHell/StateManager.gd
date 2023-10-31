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

@onready var canvas_animation_player = $"CanvasLayer/AnimationPlayer"
@onready var level_timer = $"LevelTimer"
@onready var bullet_timer = $BulletTimer
@onready var player = $"Player_BulletHell"
@onready var Bullet_Refrance = preload("res://Nodes/Enemys/enemy_bullet.tscn")
@onready var stopped = false

var wait_time
var settings

func _ready():
	$CanvasLayer.visible = true
	await GManager.fade_out(canvas_animation_player)
	
	randomize()
	
	settings = difficulty_settings[GManager.difficulty]
	wait_time = settings.wait_time
	player.speed = settings.speed
	
	bullet_timer.start(wait_time)
	level_timer.start(settings.level_timer)

func SpawnBullets() -> void:
	var buttomBullet = Bullet_Refrance.instantiate()
	var buttomPos = randf_range(24,648)
	var leftBullet = Bullet_Refrance.instantiate()
	var leftPos = randf_range(136,648)
	var rightBullet = Bullet_Refrance.instantiate()
	var rightPos = randf_range(136,648)
	
	get_parent().add_child(buttomBullet)
	get_parent().add_child(leftBullet)
	get_parent().add_child(rightBullet)
	
	buttomBullet.emit_signal("SPAWN",Vector2.UP,Vector2(buttomPos,648), settings.clothes_speed)
	rightBullet.emit_signal("SPAWN",Vector2.RIGHT,Vector2(0,leftPos), settings.clothes_speed)
	leftBullet.emit_signal("SPAWN",Vector2.LEFT,Vector2(1128,rightPos), settings.clothes_speed)
	
	bullet_timer.start(wait_time)
	
func free_nodes():
	var bullets = get_tree().get_nodes_in_group("Bullets")
	for bullet in bullets:
		bullet.queue_free()
		
	get_node("StaticBody2D").queue_free()
		
	#await get_tree().create_timer(0.01).timeout
