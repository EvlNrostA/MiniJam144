extends Node

var difficulties = {
	"easy": {
		"count": 1,
		"position_delay": [1, 2],
		"reveal_delay": [1, 1.5],
		"level_timer": 30,
		"speed": 2
	},
	"normal": {
		"count": 3,
		"position_delay": [1, 2],
		"reveal_delay": [0.4, 0.7],
		"level_timer": 30,
		"speed": 3
	},
	"hard": {
		"count": 5,
		"position_delay": [1, 2],
		"reveal_delay": [0.4, 0.7],
		"level_timer": 30,
		"speed": 3
	},
}
 
@onready var noam_fogle_scene = preload("res://Nodes/Enemys/NoamFogle.tscn")
@onready var player = $"../Player_Tamplate"
@onready var level_timer = $"../LevelTimer"

var noam_fogle_count
var noam_fogles # Remove?

func _ready():
	start("normal")
	
func start(selected_difficulty):
	var difficulty = difficulties[selected_difficulty]
	noam_fogle_count = difficulty.count
	
	player.speed = difficulty.speed
	
	var holes = get_tree().get_nodes_in_group("Holes")
	noam_fogles = []
	for i in range(noam_fogle_count):
		var noam_fogle = noam_fogle_scene.instantiate()
		noam_fogles.append(noam_fogle)
		add_child(noam_fogles[i])
		noam_fogles[i].start(holes, difficulty.position_delay, difficulty.reveal_delay)

	level_timer.wait_time = difficulty.level_timer
	level_timer.start()
