extends Node

var difficulties = {
	"Easy": {
		"Count": 1,
		"PositionDelay": [1, 2],
		"RevealDelay": [1, 1.5]
	},
	"Normal": {
		"Count": 3,
		"PositionDelay": [1, 2],
		"RevealDelay": [0.4, 0.7]
	},
	"Hard": {
		"Count": 5,
		"PositionDelay": [1, 2],
		"RevealDelay": [0.4, 0.7]
	},
}
 
@onready var noam_fogle_scene = preload("res://Nodes/Enemys/NoamFogle.tscn")

var noam_fogle_count
var noam_fogles = []
var player

func _ready():
	start("Normal")
	
func start(difficulty):
	player = $"../Player_Tamplate"
	var holes = get_tree().get_nodes_in_group("Holes")
	noam_fogle_count = difficulties[difficulty]["Count"]
	var position_delay = difficulties[difficulty]["PositionDelay"]
	var reveal_delay = difficulties[difficulty]["RevealDelay"]
	
	for i in range(noam_fogle_count):
		var noam_fogle = noam_fogle_scene.instantiate()
		noam_fogles.append(noam_fogle)
		add_child(noam_fogles[i])
		noam_fogles[i].start(holes, position_delay, reveal_delay)
