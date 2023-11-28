extends Node2D

var difficulty_settings = {
	"easy": {
		"count": 2,
		"hide_delay": [1, 2],
		"reveal_delay": [1, 1.5],
		"level_timer": 15,
		"speed": 2.5,
		"score_multiplier": 1
	},
	"normal": {
		"count": 4,
		"hide_delay": [1, 2],
		"reveal_delay": [1, 1.5],
		"level_timer": 20,
		"speed": 2.5,
		"score_multiplier": 1
	},
	"hard": {
		"count": 8,
		"hide_delay": [1, 2],
		"reveal_delay": [1, 1.5],
		"level_timer": 20,
		"speed": 2.5,
		"score_multiplier": 1.5
	},
}

@onready var player = $Player
@onready var joystick = $Joystick
@onready var noam_fogles = get_tree().get_nodes_in_group("NoamFogle")

var settings
var noam_fogle_count
var hidden_noam_fogles : Array
	
func _ready():
	if GManager.difficulty == null:
		GManager.start_level("easy")
		
	if not GManager.is_mobile:
		joystick.visible = false

	settings = difficulty_settings[GManager.difficulty]
	noam_fogle_count = settings.count
	player.speed = settings.speed
	
	UI.set_timer(settings.level_timer, _on_level_timer_timeout)
	
	await GManager.show_tooltip()

	UI.start_timer()

func _process(_delta):
	if UI.timer_running():
		GManager.copy_array(hidden_noam_fogles, noam_fogles.filter(func(noam_fogle): return noam_fogle.hiding))
		spawn_noam_fogle()
	
func spawn_noam_fogle():
	var available_noam_fogles = clamp(noam_fogle_count, 0, noam_fogles.size())
	var revealed_noam_fogle_count = noam_fogles.size() - hidden_noam_fogles.size()
	
	if not hidden_noam_fogles.is_empty() and revealed_noam_fogle_count < available_noam_fogles:
		#print("revealed: ", revealed_noam_fogle_count)
		var noam_fogle = hidden_noam_fogles.pick_random()
		noam_fogle.hide_and_reveal(GManager.randf_list_range(settings.reveal_delay),
								   GManager.randf_list_range(settings.hide_delay))
	
	elif revealed_noam_fogle_count > available_noam_fogles:
		print(revealed_noam_fogle_count, " more than ", noam_fogle_count)
	
func won_game():
	UI.points_add_time_left(settings.score_multiplier)
	GManager.next_level()

func _on_level_timer_timeout():
	player.lost = true
	await player.death_animation()
	GManager.game_over()
