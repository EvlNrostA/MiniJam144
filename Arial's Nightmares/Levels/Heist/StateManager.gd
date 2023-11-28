extends Node2D

var difficulty_settings = {
	"easy": {
		"level_timer": 15,
		"speed": 2.5,
	},
	"normal": {
		"level_timer": 20,
		"speed": 2.5,
	},
	"hard": {
		"level_timer": 20,
		"speed": 2.5,
	}
}

@onready var player = $Player
@onready var joystick = $Joystick

var settings
	
func _ready():
	if GManager.difficulty == null:
		GManager.start_level("easy")

	settings = difficulty_settings[GManager.difficulty]
	player.speed = settings.speed

	UI.set_timer(settings.level_timer, _on_level_timer_timeout)
	await GManager.show_tooltip()
	UI.start_timer()
	
func won_game():
	UI.points_add_time_left()
	GManager.next_level()

func _on_level_timer_timeout():
	player.lost = true
	await player.death_animation()
	GManager.game_over()
