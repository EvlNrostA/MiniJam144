extends Node2D

const PLAYER_SPEED = 1.5

var difficulty_settings = {
	"easy": {
		"level_timer": 30,
		"cameras": []
	},
	"normal": {
		"level_timer": 30,
		"cameras": []
	},
	"hard": {
		"level_timer": 30,
		"cameras": []
	}
}

@onready var player = $Player
@onready var joystick = $Joystick
@onready var coin = $Coin

@onready var coin_taken = false
@onready var should_move = false

var settings
	
func _ready():
	if GManager.difficulty == null:
		GManager.start_level("easy")

	settings = difficulty_settings[GManager.difficulty]
	
	player.speed = PLAYER_SPEED
	coin.pickup_function = Callable(pickup_coin)

	UI.set_timer(settings.level_timer, _on_level_timer_timeout)
	
	await GManager.show_tooltip()
	
	should_move = true
	UI.start_timer()
	
func pickup_coin():
	coin_taken = true
	
func _on_end_line_body_entered(body):
	if coin_taken:
		UI.points_add_time_left()
		GManager.next_level()
	
func _on_level_timer_timeout():
	player.lost = true
	await player.death_animation()
	GManager.game_over()
