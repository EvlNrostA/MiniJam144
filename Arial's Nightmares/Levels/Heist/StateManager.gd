extends Node2D

const PLAYER_SPEED = 1.5

#const CAMERA_SPEED = 3
#const 

var difficulty_settings = {
	"easy": {
		"level_timer": 30,
		"cameras": {
			"Camera1": {
				"min_deg": 89,
				"max_deg": -89,
				"speed": 0.2
			},
		}
	},
	"normal": {
		"level_timer": 30,
		"cameras": {
			"Camera1": {
				"min_deg": 0,
				"max_deg": 180,
				"speed": 0.2
			},
			"Camera2": {
				"min_deg": 0,
				"max_deg": 180,
				"speed": 0.2
			},
		}
	},
	"hard": {
		"level_timer": 30,
		"cameras": {
			"Camera1": {
				"min_deg": 0,
				"max_deg": 180,
				"speed": 0.2
			},
			"Camera2": {
				"min_deg": 0,
				"max_deg": 180,
				"speed": 0.2
			},
			"Camera3": {
				"min_deg": 0,
				"max_deg": 180,
				"speed": 0.2
			}
		}
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
	
	var cameras = get_tree().get_nodes_in_group("Cameras")
	for camera in cameras:
		if camera.name in settings.cameras:
			var camera_settings = settings.cameras[camera.name]
			camera.start(camera_settings.min_deg, camera_settings.max_deg, camera_settings.speed)

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
