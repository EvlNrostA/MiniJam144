extends Node2D

var difficulty_settings = {
	"easy": {
		"speed": 3000,
		"level_timer": 20,
		"level_velocity": 2
	},
	"normal": {
		"speed": 2000,
		"level_timer": 30,
		"level_velocity": 4
	},
	"hard": {
		"speed": 100,
		"level_timer": 30,
		"level_velocity": 8
	}
}

@onready var bullet_refrance = preload("res://Levels/EndlessRunner/Obstacle.tscn")
@onready var player = $Player_Tamplate
@onready var level_timer = $LevelTimer
@onready var tile_timer = $TileTimer

var settings

func _ready():
	randomize()
	
	settings = difficulty_settings[GManager.difficulty]
	player.speed = settings.speed
	player.shadow.visible = false
	
	level_timer.start_timer(settings.level_timer)
	tile_timer.start(randf_range(1.6, 6.0))

func _on_timer_timeout():
	var newOB = bullet_refrance.instantiate()
	get_parent().add_child(newOB)
	newOB.emit_signal("SPAWN",Vector2.LEFT * settings.level_velocity, Vector2(1230, 530))
	
	tile_timer.start(randf_range(1.6, 6.0))
	
func _on_level_timer_timeout():
	GManager.next_level()
