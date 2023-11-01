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

const MAX_LEFT = -50
const MAX_RIGHT = 1200
const MAX_TOP = -50
const MAX_BOTTOM = 700

@onready var player = $Player

@onready var level_timer = $LevelTimer
@onready var bullet_timer = $BulletTimer

@onready var left_hand = $LeftHand
@onready var right_hand = $RightHand

@onready var clothes_scene = preload("res://Nodes/Enemys/Clothes.tscn")

var wait_time
var settings

func _ready():
	randomize()
	
	if GManager.difficulty == null:
		GManager.difficulty = "easy"
	
	settings = difficulty_settings[GManager.difficulty]
	wait_time = settings.wait_time
	player.speed = settings.speed
	
	bullet_timer.start(wait_time)
	level_timer.start_timer(settings.level_timer)
	
	right_hand.start("RightWave")
	left_hand.start("LeftWave")

func spawn_bullets() -> void:
	var bullet_directions = {
		Vector2.UP: Vector2(randf_range(MAX_LEFT, MAX_RIGHT), MAX_BOTTOM),
		Vector2.DOWN: Vector2(randf_range(MAX_LEFT, MAX_RIGHT), MAX_TOP),
		Vector2.LEFT: Vector2(MAX_RIGHT, randf_range(MAX_TOP, MAX_BOTTOM)),
		Vector2.RIGHT: Vector2(MAX_LEFT, randf_range(MAX_TOP, MAX_BOTTOM))
	}
	
	for direction in bullet_directions.keys():
		var bullet = clothes_scene.instantiate()
		add_child(bullet)
		bullet.emit_signal("SPAWN", direction, bullet_directions[direction], settings.clothes_speed)
	
	bullet_timer.start(wait_time)

func _on_level_timer_timeout():
	GManager.next_level()
