extends Node2D

var difficulty_settings = {
	"easy": {
		"speed": 3000,
		"level_timer": 20
	},
	"normal": {
		"speed": 2000,
		"level_timer": 30
	},
	"hard": {
		"speed": 100,
		"level_timer": 30
	}
}

const LEVEL_VELOCITY = Vector2.LEFT * 2

@onready var bullet_refrance = preload("res://Levels/YAM/obstacle.tscn")
@onready var player = $Player_Tamplate
@onready var level_timer = $LevelTimer

var settings

# Called when the node enters the scene tree for the first time.
func _ready():
	GManager.difficulty = "easy"
	settings = difficulty_settings[GManager.difficulty]
	player.speed = settings.speed
	
	level_timer.start(settings.level_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	
	var newOB = bullet_refrance.instantiate()
	get_parent().add_child(newOB)
	newOB.emit_signal("SPAWN",Vector2.LEFT, Vector2(1350, 530))
	
	
	randomize()
	$Timer.wait_time = randf_range(1.6, 6.0)
	$Timer.start()
	
func _on_level_timer_timeout():
	GManager.next_level()
