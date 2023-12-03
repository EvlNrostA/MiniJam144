extends Node2D

var difficulty_settings = {
	"easy": {
		"speed": 2.5,
		"nir_speed": 150,
	},
	"normal": {
		"speed": 2,
		"nir_speed": 200,
	},
	"hard": {
		"speed": 2,
		"nir_speed": 220,
	},
}

@onready var player = $arielush
@onready var nir = $nir
var settings

# Called when the node enters the scene tree for the first time.
func _ready():
	if GManager.difficulty == null:
		GManager.start_level("easy")
	
	settings = difficulty_settings[GManager.difficulty]
	player.speed = settings.speed
	
	UI.set_and_start_timer(30, _on_level_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_level_timer_timeout():
	GManager.next_level()


