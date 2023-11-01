extends Node2D

var difficulty_settings = {
	"easy": {
		"count": 1,
		"hide_delay": [1, 2],
		"reveal_delay": [0.7, 1.2],
		"level_timer": 30,
		"speed": 2.5
	},
	"normal": {
		"count": 3,
		"hide_delay": [1, 2],
		"reveal_delay": [0.7, 1.2],
		"level_timer": 30,
		"speed": 3
	},
	"hard": {
		"count": 7,
		"hide_delay": [1, 2],
		"reveal_delay": [0.7, 1.2],
		"level_timer": 20,
		"speed": 3
	},
}
 
@onready var level_timer = $LevelTimer
@onready var player = $"Player_Tamplate"
@onready var noam_fogles = get_tree().get_nodes_in_group("NoamFogle")

var settings
var noam_fogle_count
	
func _ready():
	randomize()

	settings = difficulty_settings[GManager.difficulty]
	noam_fogle_count = settings.count
	player.speed = settings.speed

	level_timer.start_timer(settings.level_timer)

func _process(_delta):
	if settings and noam_fogles:
		spawn_noam_fogles()
	
func spawn_noam_fogles():	
	var hidden_noam_fogles = noam_fogles.filter(func(noam_fogle): return noam_fogle.hiding)
	var revealed_noam_fogle_count = noam_fogles.size() - hidden_noam_fogles.size()
	
	if not hidden_noam_fogles.is_empty() and revealed_noam_fogle_count < noam_fogle_count:
		var noam_fogle = hidden_noam_fogles.pick_random()
		noam_fogle.hide_and_reveal(randf_list_range(settings.reveal_delay), 
								   randf_list_range(settings.hide_delay))
	
	elif revealed_noam_fogle_count > noam_fogle_count:
		print(revealed_noam_fogle_count, " more than ", noam_fogle_count)

func randf_list_range(list_range) -> float:
	return randf_range(list_range[0], list_range[1])

func won_game():
	GManager.next_level()

func _on_level_timer_timeout():
	GManager.game_over()
