extends Node2D

var difficulties = {
	"easy": {
		"count": 1,
		"position_delay": [1, 2],
		"reveal_delay": [1, 1.5],
		"level_timer": 30,
		"speed": 3
	},
	"normal": {
		"count": 3,
		"position_delay": [1, 2],
		"reveal_delay": [0.5, 1],
		"level_timer": 30,
		"speed": 3
	},
	"hard": {
		"count": 6,
		"position_delay": [1, 2],
		"reveal_delay": [0.5, 1],
		"level_timer": 30,
		"speed": 3
	},
}
 
@onready var noam_fogle_scene = preload("res://Nodes/Enemys/NoamFogle.tscn")
@onready var player = $"Player_Tamplate"
@onready var level_timer = $"LevelTimer"

var noam_fogle_count
var noam_fogles

func _ready():
	start("hard")
	
func start(difficulty):
	var settings = difficulties[difficulty]
	noam_fogle_count = settings.count
	
	player.speed = settings.speed
	
	var holes = get_tree().get_nodes_in_group("Holes")
	noam_fogles = []
	for i in range(noam_fogle_count):
		var noam_fogle = noam_fogle_scene.instantiate()
		noam_fogles.append(noam_fogle)
		add_child(noam_fogle)
		noam_fogle.start(holes, settings.position_delay, settings.reveal_delay)

	level_timer.wait_time = settings.level_timer
	level_timer.start()
