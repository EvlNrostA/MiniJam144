extends Node2D

var difficulty_settings = {
	"easy": {
		"speed": 3000,
		"level_timer": 20,
		"level_velocity": 400,
		"obstacle_wait_range": [2, 4]
	},
	"normal": {
		"speed": 2000,
		"level_timer": 30,
		"level_velocity": 1000,
		"obstacle_wait_range": [1, 4]
	},
	"hard": {
		"speed": 100,
		"level_timer": 30,
		"level_velocity": 1500,
		"obstacle_wait_range": [1, 3]
	}
}

@onready var obstacle_scene = preload("res://Levels/EndlessRunner/Obstacle.tscn")

@onready var player = $Player
@onready var level_timer = $LevelTimer
@onready var tile_timer = $TileTimer

var settings

func _ready():
	randomize()
	
	if GManager.difficulty == null:
		GManager.restart_levels()
	
	settings = difficulty_settings[GManager.difficulty]
	player.speed = settings.speed
	player.shadow.visible = false
	
	var clouds = get_tree().get_nodes_in_group("Clouds")
	for cloud in clouds:
		cloud.start()
	
	level_timer.start_timer(settings.level_timer)
	start_tiles()

func start_tiles():
	tile_timer.start(GManager.randf_list_range(settings.obstacle_wait_range))

func _on_timer_timeout():
	var obstacle = obstacle_scene.instantiate()
	add_child(obstacle)
	obstacle.emit_signal("SPAWN", Vector2.LEFT, settings.level_velocity, Vector2(1230, 530))
	
	start_tiles()
	
func _on_level_timer_timeout():
	GManager.next_level()
